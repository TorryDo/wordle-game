import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_it/get_it.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/type_state.dart';
import 'package:wordle_game/src/utils/extension.dart';

import '../../../data_source/word_list/word_list_repository.dart';

class SetupGameBoard {
  static const WRONG_CHAR = 0;
  static const RIGHT_CHAR_RIGHT_PLACE = 2;
  static const RIGHT_CHAR_WRONG_PLACE = 1;
  static const PLACE_HOLDER_CHAR = '-';

  RxString targetWord;
  Rx<GameState> gameState;
  RxList<CharacterState> gameBoardStateList;
  Rx<TypeState> typeState;

  final wordListRepository = GetIt.I.get<WordListRepository>();

  var wordLength = 0;

  SetupGameBoard(
      {required this.targetWord,
      required this.gameState,
      required this.gameBoardStateList,
      required this.typeState}) {
    /// check if previous game still be there

    setupTargetWord();
  }

  static const String emptyChar = ' ';
  var _currentPositionInWord = 0;

  // func ----------------------------------------------------------------------

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

    /*
     * check if word exists in the words db file.
     * if yes, reset currentPosition and find next char. if not, do nothing
     *
     */
    void _inputEnter() {
      if (isEndOfWord(wordLength, _currentPositionInWord)) {
        final tempInputCompletedWord = _getCompleteWord();

        isExistWord(tempInputCompletedWord, (isCorrect) {
          if (isCorrect) {
            final statusList = getCharactersStatusListInWord(
                targetWord.value, tempInputCompletedWord);

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
                wordStates: gameBoardStateList.sublist(
                    _findLastCharPosition() - wordLength + 1,
                    _findLastCharPosition() + 1)));

            if (isMatchedTargetWord(tempInputCompletedWord)) {
              /// YOU WIN THIS GAME

              gameState.value = const InitialGameState();
              gameState.value = const EndGameState(hasWon: true);
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
      gameBoardStateList[i] = const InitialCharacterState(emptyChar);
    }.repeat(gameBoardStateList.length);
    _currentPositionInWord = 0;
    setupTargetWord();
  }

  // -----------
  List<int> getCharactersStatusListInWord(String target, String input) {
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

  void setupTargetWord({Function(bool)? wordReady}) async {
    targetWord.value = await wordListRepository.getRandomWord();
    wordReady ?? (true);
  }

  bool isMatchedTargetWord(String word) {
    return word.toLowerCase() == targetWord.value;
  }

  void isExistWord(String word, Function(bool) result) async {
    bool b = await wordListRepository.isWordExist(word);
    result(b);
  }

  bool isEndOfWord(int wordLength, int position) => position == wordLength;

  bool isStartOfWord(int position) => position <= 0;

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
    gameBoardStateList[position] = RightCharacterRightPositionState(tempChar);
  }

  void _notifyToRightCharWrongPlaceState(int position) {
    final tempChar = gameBoardStateList[position].char;
    gameBoardStateList[position] = RightCharacterWrongPositionState(tempChar);
  }
}
