import 'package:wordle_game/src/ui/game_screen/controller/game_observable_data.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/type_state.dart';

class SetupKeyboard {
  final GameObservableData liveData;

  SetupKeyboard(this.liveData);

  void updateStateBasedOnCharacters(EnterState enterState) {
    for (var newCharacterState in enterState.wordStates) {
      final position = _findPositionEqualTo(newCharacterState.char);

      if (_canCharacterStateBeUpdated(
          liveData.keyboardCharacters[position], newCharacterState)) {
        continue;
      }

      liveData.keyboardCharacters[position] = newCharacterState;
    }
  }

  void resetKeyboard() {
    for (int i = 0; i < liveData.keyboardCharacters.length; i++) {
      final prevChar = liveData.keyboardCharacters[i].char;
      liveData.keyboardCharacters[i] = InitialCharacterState(prevChar);
    }
  }

  // private -------------------------------------------------------------------

  int _findPositionEqualTo(String char) =>
      liveData.keyboardCharacters.indexWhere((state) => state.char == char);

  bool _canCharacterStateBeUpdated(
      CharacterState oldState, CharacterState newState) {
    if (oldState is RightCharacterRightPositionState) {
      return true;
    }
    if (oldState is RightCharacterWrongPositionState &&
        newState is WrongCharacterState) {
      return true;
    }
    return false;
  }
}
