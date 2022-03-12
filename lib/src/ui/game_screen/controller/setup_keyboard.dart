import 'package:wordle_game/src/ui/game_screen/controller/game_observable_data.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';

class SetupKeyboard {
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
    for (int i = 0; i < liveData.keyboardCharacters.length; i++) {
      final prevChar = liveData.keyboardCharacters[i].char;
      liveData.keyboardCharacters[i] = InitialCharacterState(prevChar);
    }
  }

  // private -------------------------------------------------------------------

  void _updateKeyBoardButtonsState() {
    for (var blackState in _getBlackStateListFromGameBoard()) {
      int pos = _findPositionEqualTo(blackState.char);
      liveData.keyboardCharacters[pos] = WrongCharacterState(blackState.char);
    }
    for (var yellowState in _getYellowStateListFromGameBoard()) {
      int pos = _findPositionEqualTo(yellowState.char);
      liveData.keyboardCharacters[pos] =
          RightCharacterWrongPositionState(yellowState.char);
    }

    for (var greenState in _getGreenStateListFromGameBoard()) {
      int pos = _findPositionEqualTo(greenState.char);
      liveData.keyboardCharacters[pos] =
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

  int _findPositionEqualTo(String char) =>
      liveData.keyboardCharacters.indexWhere((state) => state.char == char);
}
