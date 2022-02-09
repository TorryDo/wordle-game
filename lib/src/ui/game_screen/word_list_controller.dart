import 'package:get/get.dart';
import 'package:wordle_game/src/ui/game_screen/key_board/type_state.dart';

/// be careful with "typeState.value = const InitialState();" in 'type' function
///

class WordListController extends GetxController {
  final String _defaultChar = ' ';
  var charList = [].obs;
  Rx<TypeState> typeState = Rx<TypeState>(const InitialState());

  var _wordLength = 0;
  var _currentPosition = 0;

  final FAKE_WORD = 'YOUNG';

  void initWordList(int itemNumber, int wordLength) {
    _wordLength = wordLength;
    charList.value = List.filled(itemNumber, _defaultChar);
  }

  void updateChar(String char, int index) {
    charList[index] = char;
  }

  void type(int ascii) {
    /** A - Z **/
    if (ascii >= 65 && ascii <= 90) {
      if (!_isEndOfWord(_wordLength, _currentPosition)) {
        int lastEmptyChar = _findLastEmptyChar();
        if (lastEmptyChar < 0) return;

        charList[lastEmptyChar] = String.fromCharCode(ascii);
        _currentPosition++;
        typeState.value = TypingState(ascii: ascii);
      } else {
        /** when the cursor in the end, do nothing */
        typeState.value = const InitialState();
        typeState.value = const TailOfWordState();
        return;
      }
      /** DEL **/
    } else if (ascii == 127) {
      if (!_isStartOfWord(_currentPosition)) {
        charList[_findLastChar()] = _defaultChar;
        _currentPosition--;
        typeState.value = const InitialState();
        typeState.value = const DeleteState();
        return;
      } else {
        /** when the cursor in the start of word, do nothing */
        typeState.value = const InitialState();
        typeState.value = const HeadOfWordState();
        return;
      }
      /** ENTER **/
    } else if (ascii == 10) {
      if (_isEndOfWord(_wordLength, _currentPosition)) {
        /** check if word exists in the words db file. if yes, reset currentPosition and find next char. if not, do nothing */
        typeState.value = const InitialState();
        typeState.value = EnterState(
            word: _getCompleteWord(),
            validateWord: (isExist) {
              if (isExist) {
                _currentPosition = 0;
              }
            });
      } else {
        /** meaning not a suitable word. Need to complete the word */
        typeState.value = const InitialState();
        typeState.value = const WordNotCompleteState();
        return;
      }
    }
  }

  void reset() {
    for (int i = 0; i < getItemNumber; i++) {
      charList[i] = _defaultChar;
    }
    _currentPosition = 0;
  }

  // private -------------------------------------------------------------------

  int _findLastEmptyChar() => charList.indexOf(_defaultChar);

  int _findLastChar() =>
      charList.lastIndexWhere((element) => element != _defaultChar);

  String _getCompleteWord() {
    /** when this function is called, last char is in the end of word */
    int lastChar = _findLastChar();
    String result = '';
    for (int i = lastChar + 1 - _wordLength; i < lastChar + 1; i++) {
      result += charList[i];
    }

    return result;
  }

  bool _isEndOfWord(int wordLength, int currentPosition) {
    if (currentPosition == wordLength) return true;

    return false;
  }

  bool _isStartOfWord(int currentPosition) {
    if (currentPosition <= 0) return true;

    return false;
  }

  // testing -------------------------------------------------------------------

  get getItemNumber => charList.length;

  get getCurrentPosition => _currentPosition;

  get testFindLastEmptyChar => _findLastEmptyChar();

  get testFindLastChar => _findLastChar();

  get testGetCompleteWord => _getCompleteWord();
}
