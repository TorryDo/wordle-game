import 'package:wordle_game/src/ui/game_screen/controller/game_observable_data.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';

class SetupKeyboard {
  /// CONVENTION:
  /// - GreenState: RightCharRightPositionState
  /// - YellowState: RightCharWrongPositionState
  /// - BlackState: WrongCharacterState

  final GameObservableData liveData;

  SetupKeyboard(this.liveData) {
    _observe();
  }

  void _observe() {
    liveData.gameBoardStateList.stream.listen((_) {
      _updateKeyBoardButtonsState();
    });
  }

  // public --------------------------------------------------------------------

  void resetKeyboard() {
    for (int i = 0; i < liveData.keyboardStateList.length; i++) {
      final prevChar = liveData.keyboardStateList[i].char;
      liveData.keyboardStateList[i] = InitialCharacterState(prevChar);
    }
  }

  // private -------------------------------------------------------------------

  /// change button's color properly in keyboard
  ///
  /// first, get blackState List from gameBoard, then change button's color
  /// to black if button's character equals to blackState character
  ///
  /// second, repeat step 1 but yellowState instead of blackState
  ///
  /// third, repeat step 1 but greenState instead of blackState
  ///
  /// -> that way, i can make sure that greenState will have higher priority
  /// then yellowState, yellowState > blackState in priority
  void _updateKeyBoardButtonsState() {
    for (var blackState in _getBlackStateListFromGameBoard()) {
      int pos = _findButtonPositionEqualTo(blackState.char);
      liveData.keyboardStateList[pos] = WrongCharacterState(blackState.char);
    }
    for (var yellowState in _getYellowStateListFromGameBoard()) {
      int pos = _findButtonPositionEqualTo(yellowState.char);
      liveData.keyboardStateList[pos] =
          RightCharacterWrongPositionState(yellowState.char);
    }

    for (var greenState in _getGreenStateListFromGameBoard()) {
      int pos = _findButtonPositionEqualTo(greenState.char);
      liveData.keyboardStateList[pos] =
          RightCharacterRightPositionState(greenState.char);
    }
  }

  List<CharacterState> _getGreenStateListFromGameBoard() {
    return liveData.gameBoardStateList
        .whereType<RightCharacterRightPositionState>()
        .toList();
  }

  List<CharacterState> _getYellowStateListFromGameBoard() {
    return liveData.gameBoardStateList
        .whereType<RightCharacterWrongPositionState>()
        .toList();
  }

  List<CharacterState> _getBlackStateListFromGameBoard() {
    return liveData.gameBoardStateList
        .whereType<WrongCharacterState>()
        .toList();
  }

  /// find keyboard button position which equals to specific char
  ///
  /// the return-value will never returns -1,
  /// because 'keyboardCharacters' contains all characters in alphabet
  int _findButtonPositionEqualTo(String char) =>
      liveData.keyboardStateList.indexWhere((state) => state.char == char);
}
