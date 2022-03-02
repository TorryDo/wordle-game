import 'package:get_it/get_it.dart';
import 'package:wordle_game/src/ui/game_screen/controller/game_observable_data.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/type_state.dart';
import 'package:wordle_game/src/utils/extension.dart';

import '../../../data_source/word_list/word_list_repository.dart';

class SetupWordBoard {
  static const WRONG_CHAR = 0;
  static const RIGHT_CHAR_RIGHT_PLACE = 2;
  static const RIGHT_CHAR_WRONG_PLACE = 1;
  static const PLACE_HOLDER_CHAR = '-';

  final wordListRepository = GetIt.I.get<WordListRepository>();
  final GameObservableData liveData;

  static const String emptyChar = ' ';
  var wordLength = 0;
  var _currentPositionInWord = 0;

  SetupWordBoard(this.liveData) {
    /// check if previous game still be there

    setupTargetWord();
  }

  // func ----------------------------------------------------------------------

  void setupTheGame(int itemNumber, int wordLength) {
    this.wordLength = wordLength;
    liveData.gameBoardStateList.value =
        List.filled(itemNumber, const InitialCharacterState(emptyChar));
  }

  // get callback from keyboard widget
  void type(int ascii) {
    /// 3 input types
    void _inputAtoZ() {
      if (!_isEndOfWord(wordLength, _currentPositionInWord)) {
        int lastEmptyChar = _findLastEmptyCharPosition();
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
            const InitialCharacterState(emptyChar);
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
            final statusList = _getCharactersStatusListInWord(
                liveData.targetWord.value, tempInputCompletedWord);

            final tempLastChar = _findLastCharPosition();

            for (int i = 0; i < wordLength; i++) {
              if (statusList[i] == RIGHT_CHAR_RIGHT_PLACE) {
                _notifyToRightCharRightPlaceState(
                    tempLastChar - wordLength + 1 + i);
              } else if (statusList[i] == WRONG_CHAR) {
                _notifyWrongCharState(tempLastChar - wordLength + 1 + i);
              } else if (statusList[i] == RIGHT_CHAR_WRONG_PLACE) {
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
  }

  void resetTheGame() {
    (i) {
      liveData.gameBoardStateList[i] = const InitialCharacterState(emptyChar);
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

  // private -------------------------------------------------------------------

  List<int> _getCharactersStatusListInWord(String target, String input) {
    input = input.toLowerCase();

    List<int> rs = List.filled(target.length, WRONG_CHAR);

    List<String> targetChars = target.split('');

    for (int i = 0; i < target.length; i++) {
      if (!target.contains(input[i])) {
        input = input.replaceCharAt(i, PLACE_HOLDER_CHAR);
      }
    }

    final size = target.length;

    for (int i = 0; i < size; i++) {
      if (!targetChars.contains(input[i])) continue;
      targetChars.remove(input[i]);

      if (input[i] == PLACE_HOLDER_CHAR) continue;
      if (target[i] == input[i]) {
        rs[i] = RIGHT_CHAR_RIGHT_PLACE;
        continue;
      }
      rs[i] = RIGHT_CHAR_WRONG_PLACE;
    }

    return rs;
  }

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
    liveData.gameState.value = newGameState;
  }

  // shorten function ----------------------------------------------------------

  bool _isLastTry() =>
      _findLastCharPosition() + 1 >= liveData.gameBoardStateList.length;

  bool _isEndOfWord(int wordLength, int position) => position == wordLength;

  bool _isStartOfWord(int position) => position <= 0;

  int _findLastEmptyCharPosition() =>
      liveData.gameBoardStateList.indexWhere((c) => c.char == emptyChar);

  int _findLastCharPosition() =>
      liveData.gameBoardStateList.lastIndexWhere((c) => c.char != emptyChar);
}
