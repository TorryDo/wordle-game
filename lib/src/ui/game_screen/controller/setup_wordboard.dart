import 'package:get_it/get_it.dart';
import 'package:wordle_game/src/ui/game_screen/controller/game_observable_data.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/type_state.dart';
import 'package:wordle_game/src/utils/extension.dart';

import '../../../data_source/word_list/word_list_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/logger.dart';

class SetupWordBoard {
  final _logger = Logger()
      .setDebugEnabled(Constants.IS_DEBUG_ANABLED)
      .setTag((SetupWordBoard).toString());

  final wordListRepository = GetIt.I.get<WordListRepository>();
  final GameObservableData liveData;

  static const String SPACE_CHAR = ' ';

  int get wordLength {
    return liveData.wordLength.value;
  }

  set wordLength(int n) {
    liveData.wordLength.value = n;
  }

  int? _currentPositionInWord;

  int get currentPositionInWord {
    _currentPositionInWord ??= _getCurrentPositionInWord();
    // _logger.d("currentPosInWOrd = ${_currentPositionInWord!}");
    return _currentPositionInWord!;
  }

  set currentPositionInWord(int n) {
    _currentPositionInWord = n;
  }

  SetupWordBoard(this.liveData);

  String get targetWord => liveData.targetWord.value;

  set targetWord(String newValue) {
    liveData.targetWord.value = newValue;
  }

  int _getCurrentPositionInWord() {
    int pointer = _findLastCharPositionOfInitialState();
    if (pointer < 0) return 0;
    return (pointer + 1) % targetWord.length;
  }

  // func ----------------------------------------------------------------------

  void initWordBoard(int itemNumber, int wordLength) {
    this.wordLength = wordLength;
    liveData.gameBoardStateList.value =
        List.filled(itemNumber, const InitialCharacterState(SPACE_CHAR));
  }

  // get callback from keyboard widget
  void type(int ascii) {
    // _currentPositionInWord ??= _getCurrentPositionInWord();

    /// 3 input types
    void _inputAtoZ() {
      if (_isEndOfWord()) {
        // when the cursor in the end, do nothing
        _notifyTypingState(const TailOfWordState());
        return;
      } else {
        int lastEmptyChar = _findEmptyCharPosition();
        if (lastEmptyChar < 0) return;

        liveData.gameBoardStateList[lastEmptyChar] =
            InitialCharacterState(String.fromCharCode(ascii));

        liveData.typeState.value = TypingState(ascii: ascii);

        currentPositionInWord++;
      }
    }

    void _inputDelete() {
      if (!_isStartOfWord()) {
        liveData.gameBoardStateList[_findLastCharPosition()] =
            const InitialCharacterState(SPACE_CHAR);
        currentPositionInWord--;
        _notifyTypingState(const DeleteState());
        return;
      } else {
        // when the cursor in the start of word, do nothing
        _notifyTypingState(const HeadOfWordState());
        return;
      }
    }

    /*
     * check if word exists in the words db file.
     * if yes, reset currentPosition and find next char. if not, do nothing
     *
     */
    void _inputEnter() {
      if (_isEndOfWord()) {
        final tempInputCompletedWord = getCompleteWord();

        _isExistedWord(tempInputCompletedWord, (isCorrect) {
          if (isCorrect) {
            final statusList = getCharactersStatusListInWord(
                liveData.targetWord.value, tempInputCompletedWord);

            final tempLastChar = _findLastCharPosition();

            for (int i = 0; i < wordLength; i++) {
              if (statusList[i] == CharStateAlias.RIGHT_CHAR_RIGHT_POSITION) {
                _notifyToRightCharRightPlaceState(
                    tempLastChar - wordLength + 1 + i);
              } else if (statusList[i] == CharStateAlias.WRONG_CHAR) {
                _notifyWrongCharState(tempLastChar - wordLength + 1 + i);
              } else if (statusList[i] ==
                  CharStateAlias.RIGHT_CHAR_WRONG_POSITION) {
                _notifyToRightCharWrongPlaceState(
                    tempLastChar - wordLength + 1 + i);
              }
            }

            currentPositionInWord = 0;

            _notifyTypingState(EnterState());
            /*wordStates: liveData.gameBoardStateList.sublist(
                    _findLastCharPosition() - wordLength + 1,
                    _findLastCharPosition() + 1)*/

            if (_isMatchedTargetWord(tempInputCompletedWord)) {
              /// YOU WIN THIS GAME

              _notifyGameState(const EndGameState(hasWon: true));
            } else if (_isLastTry()) {
              /// YOU LOSE THIS GAME, IDIOT
              _notifyGameState(const EndGameState(hasWon: false));
            }
          } else {
            _notifyTypingState(const WrongWordState());
          }
        });
      } else {
        // meaning not a suitable word. Need to complete the word
        _notifyTypingState(const WordNotCompletedState());
        return;
      }
    }

    if (ascii >= 65 && ascii <= 90) {
      _inputAtoZ();
    } else if (ascii == 127) {
      _inputDelete();
    } else if (ascii == 10) {
      _inputEnter();
    }

    // _logger.d(liveData.gameBoardStateList.toString());
    // _logger.d(liveData.gameBoardStateList.lastIndexWhere((c) => c.char != EMPTY_CHAR).toString());
  }

  void resetWordBoard() {
    (i) {
      liveData.gameBoardStateList[i] = const InitialCharacterState(SPACE_CHAR);
    }.repeat(liveData.gameBoardStateList.length);
    currentPositionInWord = 0;
    setupTargetWord();
  }

  String getCompleteWord() {
    /// when this function is called, last char is in the end of word
    final lastChar = _findLastCharPosition();
    String result = '';
    for (int i = lastChar + 1 - wordLength; i < lastChar + 1; i++) {
      result += liveData.gameBoardStateList[i].char;
    }
    return result;
  }

  void setupTargetWord({Function(bool)? wordReady}) async {
    liveData.targetWord.value = await wordListRepository.getRandomWord();
    wordReady ?? (true);
  }

  /// private ------------------------------------------------------------------

  bool _isMatchedTargetWord(String word) {
    return word.toLowerCase() == liveData.targetWord.value;
  }

  void _isExistedWord(String word, Function(bool) result) async {
    bool b = await wordListRepository.isWordExist(word);
    result(b);
  }

  // notify states -------------------------------------------------------------

  void _notifyTypingState(TypeState newTypeState) {
    liveData.typeState.value = const InitialState();
    liveData.typeState.value = newTypeState;
  }

  void _notifyWrongCharState(int position) {
    final tempChar = liveData.gameBoardStateList[position].char;
    liveData.gameBoardStateList[position] = WrongCharacterState(tempChar);
  }

  void _notifyToRightCharRightPlaceState(int position) {
    final tempChar = liveData.gameBoardStateList[position].char;
    liveData.gameBoardStateList[position] =
        RightCharacterRightPositionState(tempChar);
  }

  void _notifyToRightCharWrongPlaceState(int position) {
    final tempChar = liveData.gameBoardStateList[position].char;
    liveData.gameBoardStateList[position] =
        RightCharacterWrongPositionState(tempChar);
  }

  void _notifyGameState(GameState newGameState) {
    liveData.gameState.value = const InitialGameState();
    liveData.gameState.value = newGameState;
  }

  // shorten function ----------------------------------------------------------

  bool _isLastTry() =>
      _findLastCharPosition() + 1 >= liveData.gameBoardStateList.length;

  bool _isEndOfWord() {
    // _logger.d("$currentPositionInWord --- $wordLength");
    return currentPositionInWord >= wordLength;
  }

  bool _isStartOfWord() {
    return currentPositionInWord <= 0;
  }

  int _findLastCharPositionOfInitialState() {
    int rs = _findLastCharPosition();
    if (rs < 0) return -1;
    if (liveData.gameBoardStateList[rs] is InitialCharacterState) {
      return rs;
    }

    return -1;
  }

  int _findEmptyCharPosition() =>
      liveData.gameBoardStateList.indexWhere((c) => c.char == SPACE_CHAR);

  int _findLastCharPosition() =>
      liveData.gameBoardStateList.lastIndexWhere((c) => c.char != SPACE_CHAR);
}
