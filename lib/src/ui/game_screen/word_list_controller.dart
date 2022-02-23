import 'package:get/get.dart';
import 'package:wordle_game/src/ui/game_screen/character_state.dart';
import 'package:wordle_game/src/ui/game_screen/key_board/type_state.dart';
import 'package:wordle_game/src/ui/game_screen/word_board/word_state.dart';
import 'package:wordle_game/src/ui/game_screen/word_controller.dart';
import 'package:wordle_game/src/utils/extension.dart';

/// be careful with "typeState.value = const InitialState();" in 'type' func

class WordListController extends WordController {
  static const String defaultChar = ' ';
  var _wordLength = 0;
  var _currentPosition = 0;

  var charList = [].obs;


  Rx<TypeState> typingState = Rx<TypeState>(const InitialState());

  WordListController() {
    /// check if previous game still be there
    super.updateRandomWord(wordReady: (p0) => null);
  }

  // func ----------------------------------------------------------------------

  void initWordList(int itemNumber, int wordLength) {
    _wordLength = wordLength;
    charList.value = List.filled(itemNumber, defaultChar);

  }

  void updateChar(String char, int index) => charList[index] = char;

  // type from keyboard
  void type(int ascii) {
    // A - Z
    if (ascii >= 65 && ascii <= 90) {
      if (!_isEndOfWord(_wordLength, _currentPosition)) {
        int lastEmptyChar = _findLastEmptyCharPosition();
        if (lastEmptyChar < 0) return;

        charList[lastEmptyChar] = String.fromCharCode(ascii);
        _currentPosition++;
        typingState.value = TypingState(ascii: ascii);
      } else {
        // when the cursor in the end, do nothing
        typingState.value = const InitialState();
        typingState.value = const TailOfWordState();
        return;
      }

      // DELETE
    } else if (ascii == 127) {
      if (!_isStartOfWord(_currentPosition)) {
        charList[_findLastCharPosition()] = defaultChar;
        _currentPosition--;
        // typeState.value = const InitialState();
        // typeState.value = const DeleteState();
        return;
      } else {
        // when the cursor in the start of word, do nothing
        typingState.value = const InitialState();
        typingState.value = const HeadOfWordState();
        return;
      }

      // ENTER
    } else if (ascii == 10) {
      if (_isEndOfWord(_wordLength, _currentPosition)) {
        // check if word exists in the words db file. if yes, reset currentPosition and find next char. if not, do nothing
        typingState.value = const InitialState();
        typingState.value = EnterState(word: _getCompleteWord());

        if (super.isMatchResultWord(_getCompleteWord())) {
          /// YOU WIN THIS GAME

          super.wordState.value = const InitialWordState();
          super.wordState.value = const RightWordState();
          return;
        }

        super.isExistWord(_getCompleteWord(), (isCorrect) {
          if (isCorrect) {
            _currentPosition = 0;
          }
        });
      } else {
        // meaning not a suitable word. Need to complete the word
        typingState.value = const InitialState();
        typingState.value = const WordNotCompleteState();
        return;
      }
    }
  }

  void resetCharList() {
    (i) {
      charList[i] = defaultChar;
    }.repeat(_getItemNumber);
    _currentPosition = 0;
  }

  // private -------------------------------------------------------------------

  int _findLastEmptyCharPosition() => charList.indexOf(defaultChar);

  int _findLastCharPosition() =>
      charList.lastIndexWhere((c) => c != defaultChar);

  String _getCompleteWord() {
    /// when this function is called, last char is in the end of word
    int lastChar = _findLastCharPosition();
    String result = '';
    for (int i = lastChar + 1 - _wordLength; i < lastChar + 1; i++) {
      result += charList[i];
    }
    return result;
  }

  bool _isEndOfWord(int wordLength, int position) => position == wordLength;

  bool _isStartOfWord(int position) => position <= 0;

  get _getItemNumber => charList.length;

  // testing -------------------------------------------------------------------

  get testFindLastEmptyChar => _findLastEmptyCharPosition();

  get testFindLastChar => _findLastCharPosition();

  get testGetCompleteWord => _getCompleteWord();
}
