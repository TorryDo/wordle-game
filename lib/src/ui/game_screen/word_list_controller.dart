import 'package:get/get.dart';
import 'package:wordle_game/src/ui/game_screen/key_board/type_state.dart';
import 'package:wordle_game/src/ui/game_screen/word_board/word_state.dart';
import 'package:wordle_game/src/utils/extension.dart';

/// be careful with "typeState.value = const InitialState();" in 'type' func
///

class WordListController extends GetxController {

  var _wordLength = 0;
  var _currentPosition = 0;

  final String _defaultChar = ' ';
  var charList = [].obs;
  Rx<TypeState> typeState = Rx<TypeState>(const InitialState());
  Rx<WordState> wordState = Rx<WordState>(const InitialWordState());

  WordListController();

  void initWordList(int itemNumber, int wordLength) {
    _wordLength = wordLength;
    charList.value = List.filled(itemNumber, _defaultChar);
  }

  void updateChar(String char, int index) => charList[index] = char;

  /// type from keyboard
  void type(int ascii) {
    /// A - Z
    if (ascii >= 65 && ascii <= 90) {
      if (!_isEndOfWord(_wordLength, _currentPosition)) {
        int lastEmptyChar = _findLastEmptyChar();
        if (lastEmptyChar < 0) return;

        charList[lastEmptyChar] = String.fromCharCode(ascii);
        _currentPosition++;
        typeState.value = TypingState(ascii: ascii);
      } else {
        /// when the cursor in the end, do nothing
        typeState.value = const InitialState();
        typeState.value = const TailOfWordState();
        return;
      }

      /// DEL
    } else if (ascii == 127) {
      if (!_isStartOfWord(_currentPosition)) {
        charList[_findLastChar()] = _defaultChar;
        _currentPosition--;
        // typeState.value = const InitialState();
        // typeState.value = const DeleteState();
        return;
      } else {
        /// when the cursor in the start of word, do nothing
        typeState.value = const InitialState();
        typeState.value = const HeadOfWordState();
        return;
      }

      /// ENTER
    } else if (ascii == 10) {
      if (_isEndOfWord(_wordLength, _currentPosition)) {
        /// check if word exists in the words db file. if yes, reset currentPosition and find next char. if not, do nothing
        typeState.value = const InitialState();
        typeState.value = EnterState(
            word: _getCompleteWord(),
            validateWord: (isExist) {
              if (isExist) {
                _currentPosition = 0;
              }
            });
      } else {
        /// meaning not a suitable word. Need to complete the word
        typeState.value = const InitialState();
        typeState.value = const WordNotCompleteState();
        return;
      }
    }
  }

  void reset() {
    (i) {
      charList[i] = _defaultChar;
    }.repeat(_getItemNumber);
    _currentPosition = 0;
  }

  // private -------------------------------------------------------------------

  int _findLastEmptyChar() => charList.indexOf(_defaultChar);

  int _findLastChar() => charList.lastIndexWhere((c) => c != _defaultChar);

  String _getCompleteWord() {
    /// when this function is called, last char is in the end of word
    int lastChar = _findLastChar();
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

  get testFindLastEmptyChar => _findLastEmptyChar();

  get testFindLastChar => _findLastChar();

  get testGetCompleteWord => _getCompleteWord();
}
