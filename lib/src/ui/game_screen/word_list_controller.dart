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

  RxList<CharacterState> gameBoardStateList = RxList<CharacterState>();

  Rx<TypeState> typingState = Rx<TypeState>(const InitialState());

  WordListController() {
    /// check if previous game still be there
    super.setupTargetWord(wordReady: (p0) => null);
  }

  // func ----------------------------------------------------------------------

  void init(int itemNumber, int wordLength) {
    _wordLength = wordLength;
    gameBoardStateList.value =
        List.filled(itemNumber, const InitialCharacterState(defaultChar));
  }

  @Deprecated("unImplemented")
  void updateChar(String char, int index) {
    // charList[index] = char;
  }

  // get callback from keyboard widget
  void type(int ascii) {
    /// 3 types of input
    void _inputAtoZ() {
      if (!_isEndOfWord(_wordLength, _currentPosition)) {
        int lastEmptyChar = _findLastEmptyCharPosition();
        if (lastEmptyChar < 0) return;

        gameBoardStateList[lastEmptyChar] =
            InitialCharacterState(String.fromCharCode(ascii));
        _currentPosition++;
        typingState.value = TypingState(ascii: ascii);
      } else {
        // when the cursor in the end, do nothing
        typingState.value = const InitialState();
        typingState.value = const TailOfWordState();
        return;
      }
    }

    void _inputDelete() {
      if (!_isStartOfWord(_currentPosition)) {
        gameBoardStateList[_findLastCharPosition()] =
            const InitialCharacterState(defaultChar);
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
    }

    void _inputEnter() {
      if (_isEndOfWord(_wordLength, _currentPosition)) {
        // check if word exists in the words db file. if yes, reset currentPosition and find next char. if not, do nothing
        typingState.value = const InitialState();
        typingState.value = EnterState(word: _getCompleteWord());

        if (super.isMatchTargetWord(_getCompleteWord())) {
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

    if (ascii >= 65 && ascii <= 90) {
      _inputAtoZ();
    } else if (ascii == 127) {
      _inputDelete();
    } else if (ascii == 10) {
      _inputEnter();
    }
  }

  void reset() {
    (i) {
      gameBoardStateList[i] = const InitialCharacterState(defaultChar);
    }.repeat(_getItemNumber);
    _currentPosition = 0;
  }

  // private -------------------------------------------------------------------

  int _findLastEmptyCharPosition() =>
      gameBoardStateList.indexWhere((c) => c.char == defaultChar);

  // int _findLastEmptyCharPosition() => charList.indexOf(defaultChar);

  int _findLastCharPosition() =>
      gameBoardStateList.lastIndexWhere((c) => c.char != defaultChar);

  String _getCompleteWord() {
    /// when this function is called, last char is in the end of word
    int lastChar = _findLastCharPosition();
    String result = '';
    for (int i = lastChar + 1 - _wordLength; i < lastChar + 1; i++) {
      result += gameBoardStateList[i].char;
    }
    return result;
  }

  bool _isEndOfWord(int wordLength, int position) => position == wordLength;

  bool _isStartOfWord(int position) => position <= 0;

  get _getItemNumber => gameBoardStateList.length;

  // testing -------------------------------------------------------------------

  get testFindLastEmptyChar => _findLastEmptyCharPosition();

  get testFindLastChar => _findLastCharPosition();

  get testGetCompleteWord => _getCompleteWord();
}
