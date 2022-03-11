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

  static const String EMPTY_CHAR = ' ';
  var wordLength = 0;
  var _currentPositionInWord = 0;

  SetupWordBoard(this.liveData); /* {
    _currentPositionInWord = _getCurrentPositionInWord();
  }*/

  String get targetWord => liveData.targetWord.value;

  set targetWord(String newValue) {
    liveData.targetWord.value = newValue;
  }

  // int _getCurrentPositionInWord() {
  //   var emptyCharPos = _findEmptyCharPosition();
  //   if(emptyCharPos)
  //   return emptyCharPos % targetWord.length;
  // }

  // func ----------------------------------------------------------------------

  void initWordBoard(int itemNumber, int wordLength) {
    this.wordLength = wordLength;
    liveData.gameBoardStateList.value =
        List.filled(itemNumber, const InitialCharacterState(EMPTY_CHAR));
  }

  // get callback from keyboard widget
  void type(int ascii) {
    /// 3 input types
    void _inputAtoZ() {
      if (!_isEndOfWord(wordLength, _currentPositionInWord)) {
        int lastEmptyChar = _findEmptyCharPosition();
        if (lastEmptyChar < 0) return;

        liveData.gameBoardStateList[lastEmptyChar] =
            InitialCharacterState(String.fromCharCode(ascii));

        liveData.typeState.value = TypingState(ascii: ascii);

        _currentPositionInWord++;
      } else {
        // when the cursor in the end, do nothing
        _notifyTypingState(const TailOfWordState());
        return;
      }
    }

    void _inputDelete() {
      if (!_isStartOfWord(_currentPositionInWord)) {
        liveData.gameBoardStateList[_findLastCharPosition()] =
        const InitialCharacterState(EMPTY_CHAR);
        _currentPositionInWord--;
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
      if (_isEndOfWord(wordLength, _currentPositionInWord)) {
        final tempInputCompletedWord = getCompleteWord();

        _isExistedWord(tempInputCompletedWord, (isCorrect) {
          if (isCorrect) {
            final statusList = getCharactersStatusListInWord(
                liveData.targetWord.value, tempInputCompletedWord);

            final tempLastChar = _findLastCharPosition();

            for (int i = 0; i < wordLength; i++) {
              if (statusList[i] == CharacterState.RIGHT_CHAR_RIGHT_PLACE) {
                _notifyToRightCharRightPlaceState(
                    tempLastChar - wordLength + 1 + i);
              } else if (statusList[i] == CharacterState.WRONG_CHAR) {
                _notifyWrongCharState(tempLastChar - wordLength + 1 + i);
              } else
              if (statusList[i] == CharacterState.RIGHT_CHAR_WRONG_PLACE) {
                _notifyToRightCharWrongPlaceState(
                    tempLastChar - wordLength + 1 + i);
              }
            }

            _currentPositionInWord = 0;

            _notifyTypingState(EnterState(
                wordStates: liveData.gameBoardStateList.sublist(
                    _findLastCharPosition() - wordLength + 1,
                    _findLastCharPosition() + 1)));

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
      liveData.gameBoardStateList[i] = const InitialCharacterState(EMPTY_CHAR);
    }.repeat(liveData.gameBoardStateList.length);
    _currentPositionInWord = 0;
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

  bool _isEndOfWord(int wordLength, int position) => position == wordLength;

  bool _isStartOfWord(int position) => position <= 0;

  int _findEmptyCharPosition() =>
      liveData.gameBoardStateList.indexWhere((c) => c.char == EMPTY_CHAR);

  int _findLastCharPosition() =>
      liveData.gameBoardStateList.lastIndexWhere((c) => c.char != EMPTY_CHAR);
}
