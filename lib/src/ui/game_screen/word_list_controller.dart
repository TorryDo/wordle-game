import 'package:get/get.dart';

class WordListController extends GetxController {
  var charList = [].obs;

  var _itemNumber = 0;
  var _currentPosition = 0;


  final _defaultValue = ' ';

  void initWordList(int itemNumber) {
    _itemNumber = itemNumber;
    charList.value = List.filled(itemNumber, _defaultValue);
  }

  void updateChar(String char, int index) {
    charList[index] = char;
  }

  void type(int ascii) {
    /* A - Z */
    if (ascii >= 65 && ascii <= 90) {
      if (!isEndOfLine(charList.length, _currentPosition)) {
        charList[_currentPosition] = String.fromCharCode(ascii);
      } else {
        /* when current position not in the end of line */
        return;
      }
      /* DEL */
    } else if (ascii == 127) {
      if (!isStartOfLine(charList.length, _currentPosition)) {
        charList[_currentPosition] = _defaultValue;
        _currentPosition--;
        return;
      } else {
        /* when currentPosition is in the head of line */

        return;
      }
      /* ENTER */
    } else if (ascii == 10) {
      if (isEndOfLine(charList.length, _currentPosition)) {
        /* check if word exists in the words database*/
      } else {
        /* meaning not a suitable word. Need to complete the word */
        return;
      }
    }

    _currentPosition++;
  }

  void reset() {
    for (int i = 0; i < getItemNumber; i++) {
      charList[i] = _defaultValue;
    }
    _itemNumber = 0;
    _currentPosition = 0;
  }

  // -----------------------------

  bool isEndOfLine(int listSize, int currentPosition) {
    if (currentPosition == 0) return false;

    if (listSize % currentPosition == 0 && currentPosition % 5 == 0)
      return true;

    return false;
  }

  bool isStartOfLine(int listSize, int currentPosition) {
    if (currentPosition == 0) return true;

    if (listSize % currentPosition == 0 && currentPosition % 5 != 0)
      return true;

    return false;
  }

  // testing ----------------

  get getItemNumber {
    return _itemNumber;
  }

  get getCurrentPosition {
    return _currentPosition;
  }
}
