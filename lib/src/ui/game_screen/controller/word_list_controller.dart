import 'package:get/get.dart';
import 'package:wordle_game/src/ui/game_screen/controller/character_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/type_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/word_controller.dart';
import 'package:wordle_game/src/ui/game_screen/controller/word_state_listener.dart';
import 'package:wordle_game/src/utils/extension.dart';

class WordListController extends WordController {
  static const String emptyChar = ' ';
  var _currentPositionInWord = 0;
  WordStateListener? wordStateListener;

  RxList<CharacterState> gameBoardStateList = RxList<CharacterState>();
  Rx<TypeState> typeState = Rx<TypeState>(const InitialState());

  WordListController() {
    /// check if previous game still be there

    super.setupTargetWord();
  }

  // func ----------------------------------------------------------------------

  void addWordStateListener(WordStateListener wordStateListener) {
    this.wordStateListener = wordStateListener;
  }

  void setupTheGame(int itemNumber, int wordLength) {
    this.wordLength = wordLength;
    gameBoardStateList.value =
        List.filled(itemNumber, const InitialCharacterState(emptyChar));
  }

  // get callback from keyboard widget
  void type(int ascii) {
    /// 3 input types
    void _inputAtoZ() {
      if (!isEndOfWord(wordLength, _currentPositionInWord)) {
        int lastEmptyChar = _findLastEmptyCharPosition();
        if (lastEmptyChar < 0) return;

        gameBoardStateList[lastEmptyChar] =
            InitialCharacterState(String.fromCharCode(ascii));

        typeState.value = TypingState(ascii: ascii);

        _currentPositionInWord++;
      } else {
        // when the cursor in the end, do nothing
        _notifyTypingState(const TailOfWordState());
        return;
      }
    }

    void _inputDelete() {
      if (!isStartOfWord(_currentPositionInWord)) {
        gameBoardStateList[_findLastCharPosition()] =
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

    void _inputEnter() {
      if (isEndOfWord(wordLength, _currentPositionInWord)) {
        // check if word exists in the words db file. if yes, reset currentPosition and find next char. if not, do nothing


        final tempInputCompletedWord = _getCompleteWord();

        _notifyTypingState(EnterState(word: tempInputCompletedWord));

        if (super.isMatchedTargetWord(tempInputCompletedWord)) {
          /// YOU WIN THIS GAME

          (position) {
            _notifyToRightCharRightPlaceState(position);
          }.loop(_findLastCharPosition(), _findLastCharPosition() - wordLength);

          wordStateListener!.onCorrectWord();
          return;
        }

        super.isExistWord(tempInputCompletedWord, (isCorrect) {
          if (isCorrect) {
            final statusList = getCharactersStatusListInWord(
                targetWord.value, tempInputCompletedWord);

            final tempLastChar = _findLastCharPosition();

            for (int i = 0; i < wordLength; i++) {
              if (statusList[i] == WordController.RIGHT_CHAR_RIGHT_PLACE) {
                _notifyToRightCharRightPlaceState(
                    tempLastChar - wordLength + 1 + i);
              } else if (statusList[i] == WordController.WRONG_CHAR) {
                _notifyWrongCharState(tempLastChar - wordLength + 1 + i);
              } else if (statusList[i] ==
                  WordController.RIGHT_CHAR_WRONG_PLACE) {
                _notifyToRightCharWrongPlaceState(
                    tempLastChar - wordLength + 1 + i);
              }
            }

            _currentPositionInWord = 0;
          } else {
            wordStateListener!.onWrongWord();
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
      gameBoardStateList[i] = const InitialCharacterState(emptyChar);
    }.repeat(gameBoardStateList.length);
    _currentPositionInWord = 0;
  }

  // private -------------------------------------------------------------------

  int _findLastEmptyCharPosition() =>
      gameBoardStateList.indexWhere((c) => c.char == emptyChar);

  int _findLastCharPosition() =>
      gameBoardStateList.lastIndexWhere((c) => c.char != emptyChar);

  String _getCompleteWord() {
    /// when this function is called, last char is in the end of word
    final lastChar = _findLastCharPosition();
    String result = '';
    for (int i = lastChar + 1 - wordLength; i < lastChar + 1; i++) {
      result += gameBoardStateList[i].char;
    }
    return result;
  }

  void _notifyTypingState(TypeState newTypeState) {
    typeState.value = const InitialState();
    typeState.value = newTypeState;
  }

  void _notifyWrongCharState(int position) {
    final tempChar = gameBoardStateList[position].char;
    gameBoardStateList[position] = WrongCharacterState(tempChar);
  }

  void _notifyToRightCharRightPlaceState(int position) {
    final tempChar = gameBoardStateList[position].char;
    gameBoardStateList[position] = RightCharacterRightPlaceState(tempChar);
  }

  void _notifyToRightCharWrongPlaceState(int position) {
    final tempChar = gameBoardStateList[position].char;
    gameBoardStateList[position] = RightCharacterWrongPlaceState(tempChar);
  }

  // testing -------------------------------------------------------------------

  get testFindLastEmptyChar => _findLastEmptyCharPosition();

  get testFindLastChar => _findLastCharPosition();

  get testGetCompleteWord => _getCompleteWord();

  get getTargetWord => targetWord.value;
}
