import 'dart:developer';

import 'package:get/get.dart';
import 'package:wordle_game/src/ui/game_screen/character_state.dart';
import 'package:wordle_game/src/ui/game_screen/key_board/type_state.dart';
import 'package:wordle_game/src/ui/game_screen/word_board/word_list_controller_support.dart';
import 'package:wordle_game/src/ui/game_screen/word_board/word_state.dart';
import 'package:wordle_game/src/ui/game_screen/word_controller.dart';
import 'package:wordle_game/src/utils/extension.dart';

class WordListController extends WordController with WordListControllerSupport {
  static const String emptyChar = ' ';

  var _currentPositionInWord = 0;

  RxList<CharacterState> gameBoardStateList = RxList<CharacterState>();
  Rx<TypeState> typeState = Rx<TypeState>(const InitialState());

  WordListController() {
    /// check if previous game still be there

    log("setupTargetWord");
    super.setupTargetWord();
  }

  // func ----------------------------------------------------------------------

  void init(int itemNumber, int wordLength) {
    this.wordLength = wordLength;
    gameBoardStateList.value =
        List.filled(itemNumber, const InitialCharacterState(emptyChar));
  }

  // get callback from keyboard widget
  void type(int ascii) {
    /// 3 input types
    void _inputAtoZ() {
      if (!_isEndOfWord(wordLength, _currentPositionInWord)) {
        int lastEmptyChar = _findLastEmptyCharPosition();
        if (lastEmptyChar < 0) return;

        gameBoardStateList[lastEmptyChar] =
            InitialCharacterState(String.fromCharCode(ascii));

        typeState.value = TypingState(ascii: ascii);

        _currentPositionInWord++;
      } else {
        // when the cursor in the end, do nothing
        _updateTypingState(const TailOfWordState());
        return;
      }
    }

    void _inputDelete() {
      if (!_isStartOfWord(_currentPositionInWord)) {
        gameBoardStateList[_findLastCharPosition()] =
            const InitialCharacterState(emptyChar);
        _currentPositionInWord--;
        _updateTypingState(const DeleteState());
        return;
      } else {
        // when the cursor in the start of word, do nothing
        _updateTypingState(const HeadOfWordState());
        return;
      }
    }

    void _inputEnter() {
      if (_isEndOfWord(wordLength, _currentPositionInWord)) {
        // check if word exists in the words db file. if yes, reset currentPosition and find next char. if not, do nothing

        final tempInputCompletedWord = _getCompleteWord();

        _updateTypingState(EnterState(word: tempInputCompletedWord));

        if (super.isMatchedTargetWord(tempInputCompletedWord)) {
          /// YOU WIN THIS GAME

          (position) {
            _updateToRightCharRightPlaceState(position);
          }.loop(_currentPositionInWord, _currentPositionInWord - wordLength);

          super.updateWordState(const RightWordState());
          return;
        }

        super.isExistWord(tempInputCompletedWord, (isCorrect) {
          if (isCorrect) {
            final statusList = getCharactersStatusInWord(
                targetWord.value, tempInputCompletedWord);

            final tempLastChar = _findLastCharPosition();

            for (int i = 0; i < wordLength; i++) {
              if (statusList[i] ==
                  WordListControllerSupport.RIGHT_CHAR_RIGHT_PLACE) {
                _updateToRightCharRightPlaceState(
                    tempLastChar - wordLength + 1 + i);
              } else if (statusList[i] ==
                  WordListControllerSupport.WRONG_CHAR) {
                _updateToWrongCharState(tempLastChar - wordLength + 1 + i);
              } else if (statusList[i] ==
                  WordListControllerSupport.RIGHT_CHAR_WRONG_PLACE) {
                _updateToRightCharWrongPlaceState(
                    tempLastChar - wordLength + 1 + i);
              }
            }

            _currentPositionInWord = 0;
          }
        });
      } else {
        // meaning not a suitable word. Need to complete the word
        _updateTypingState(const WordNotCompletedState());
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
    }.repeat(_getGameBoardItemNumber);
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

  bool _isEndOfWord(int wordLength, int position) => position == wordLength;

  bool _isStartOfWord(int position) => position <= 0;

  void _updateTypingState(TypeState newTypeState) {
    typeState.value = const InitialState();
    typeState.value = newTypeState;
  }

  void _updateToWrongCharState(int position) {
    final tempChar = gameBoardStateList[position].char;
    gameBoardStateList[position] = WrongCharacterState(tempChar);
  }

  void _updateToRightCharRightPlaceState(int position) {
    final tempChar = gameBoardStateList[position].char;
    gameBoardStateList[position] = RightCharacterRightPlaceState(tempChar);
  }

  void _updateToRightCharWrongPlaceState(int position) {
    final tempChar = gameBoardStateList[position].char;
    gameBoardStateList[position] = RightCharacterWrongPlaceState(tempChar);
  }

  get _getGameBoardItemNumber => gameBoardStateList.length;

  // testing -------------------------------------------------------------------

  get testFindLastEmptyChar => _findLastEmptyCharPosition();

  get testFindLastChar => _findLastCharPosition();

  get testGetCompleteWord => _getCompleteWord();

  get getTargetWord => targetWord.value;
}
