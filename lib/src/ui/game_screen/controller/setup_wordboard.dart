import 'package:get_it/get_it.dart';
import 'package:wordle_game/src/ui/game_screen/controller/observable_game_data.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/type_state.dart';
import 'package:wordle_game/src/utils/extension.dart';

import '../../../data_source/word_list/word_list_repository.dart';
import '../../../utils/constants.dart';

/// need code optimization

class SetupWordBoard {
  /// CONVENTION:
  /// - GreenState: RightCharRightPositionState
  /// - YellowState: RightCharWrongPositionState
  /// - BlackState: WrongCharacterState
  ///

  final wordListRepository = GetIt.I.get<WordListRepository>();
  final ObservableGameData _liveData;

  SetupWordBoard(this._liveData);

  // getter & setter -----------------------------------------------------------

  int get wordLength {
    return _liveData.wordLength.value;
  }

  set wordLength(int n) {
    _liveData.wordLength.value = n;
  }

  int? _currentPositionInWord;

  int get currentPositionInWord {
    _currentPositionInWord ??= _getCurrentPositionInWord();
    return _currentPositionInWord!;
  }

  set currentPositionInWord(int n) {
    _currentPositionInWord = n;
  }

  String get targetWord => _liveData.targetWord.value;

  set targetWord(String newValue) {
    _liveData.targetWord.value = newValue;
  }

  int _getCurrentPositionInWord() {
    int pointer = _findLastCharPositionOfInitialState();
    if (pointer < 0) return 0;
    return (pointer + 1) % targetWord.length;
  }

  // func ----------------------------------------------------------------------

  void initWordBoard(int itemNumber, int wordLength) {
    this.wordLength = wordLength;
    _liveData.gameBoardStateList.value =
        List.filled(itemNumber, const InitialCharacterState(Const.SPACE_CHAR));
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
        int lastEmptyChar = _firstEmptyCharPosition();
        if (lastEmptyChar < 0) return;

        _liveData.gameBoardStateList[lastEmptyChar] =
            InitialCharacterState(String.fromCharCode(ascii));

        _liveData.typeState.value = TypingState(ascii: ascii);

        currentPositionInWord++;
      }
    }

    void _inputDelete() {
      if (!_isStartOfWord()) {
        _liveData.gameBoardStateList[_lastCharPosition()] =
            const InitialCharacterState(Const.SPACE_CHAR);
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
                _liveData.targetWord.value, tempInputCompletedWord);

            final tempLastChar = _lastCharPosition();

            for (int i = 0; i < wordLength; i++) {
              if (statusList[i] == CharStateAlias.RIGHT_CHAR_RIGHT_POSITION) {
                _updateGreenState(tempLastChar - wordLength + 1 + i);
              } else if (statusList[i] == CharStateAlias.WRONG_CHAR) {
                _updateBlackState(tempLastChar - wordLength + 1 + i);
              } else if (statusList[i] ==
                  CharStateAlias.RIGHT_CHAR_WRONG_POSITION) {
                _updateYellowState(tempLastChar - wordLength + 1 + i);
              }
            }

            currentPositionInWord = 0;

            _notifyTypingState(const EnterState());

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
  }

  void resetWordBoard() {
    (i) {
      _liveData.gameBoardStateList[i] =
          const InitialCharacterState(Const.SPACE_CHAR);
    }.repeat(_liveData.gameBoardStateList.length);
    currentPositionInWord = 0;
    setupTargetWord();
  }

  String getCompleteWord() {
    /// when this function is called, last char is in the end of word
    final lastChar = _lastCharPosition();
    String result = '';
    for (int i = lastChar + 1 - wordLength; i < lastChar + 1; i++) {
      result += _liveData.gameBoardStateList[i].char;
    }
    return result;
  }

  void setupTargetWord({Function(bool)? wordReady}) async {
    _liveData.targetWord.value = await wordListRepository.getRandomWord();
    wordReady ?? (true);
  }

  // private -------------------------------------------------------------------

  bool _isMatchedTargetWord(String word) {
    return word.toLowerCase() == _liveData.targetWord.value;
  }

  void _isExistedWord(String word, Function(bool) result) async {
    bool b = await wordListRepository.isWordExist(word);
    result(b);
  }

  // notify states -------------------------------------------------------------

  void _notifyTypingState(TypeState newTypeState) {
    _liveData.typeState.value = const InitialState();
    _liveData.typeState.value = newTypeState;
  }

  void _updateBlackState(int position) {
    final tempChar = _liveData.gameBoardStateList[position].char;
    _liveData.gameBoardStateList[position] = WrongCharacterState(tempChar);
  }

  void _updateGreenState(int position) {
    final tempChar = _liveData.gameBoardStateList[position].char;
    _liveData.gameBoardStateList[position] =
        RightCharacterRightPositionState(tempChar);
  }

  void _updateYellowState(int position) {
    final tempChar = _liveData.gameBoardStateList[position].char;
    _liveData.gameBoardStateList[position] =
        RightCharacterWrongPositionState(tempChar);
  }

  void _notifyGameState(GameState newGameState) {
    _liveData.gameState.value = const PlayingGameState();
    _liveData.gameState.value = newGameState;
  }

  // shorten function ----------------------------------------------------------

  bool _isLastTry() =>
      _lastCharPosition() + 1 >= _liveData.gameBoardStateList.length;

  bool _isEndOfWord() {
    return currentPositionInWord >= wordLength;
  }

  bool _isStartOfWord() {
    return currentPositionInWord <= 0;
  }

  int _findLastCharPositionOfInitialState() {
    return _liveData.gameBoardStateList.initialCharStateHasCharPosition;
  }

  int _firstEmptyCharPosition() {
    return _liveData.gameBoardStateList.firstEmptyCharPosition;
  }

  int _lastCharPosition() {
    return _liveData.gameBoardStateList.lastCharPosition;
  }
}
