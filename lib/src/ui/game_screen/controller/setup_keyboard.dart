import 'package:get/get.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/type_state.dart';

class SetupKeyboard {
  RxList<CharacterState> keyboardCharacters;
  Rx<TypeState> typeState;
  Rx<GameState> gameState;

  SetupKeyboard(
      {required this.keyboardCharacters,
      required this.typeState,
      required this.gameState}) {
    _observe();
  }

  // private -------------------------------------------------------------------

  void _observe() {
    typeState.stream.listen((typeState) {
      if (typeState is EnterState) {
        for (var newCharacterState in typeState.wordStates) {
          final position = findPositionEqualTo(newCharacterState.char);

          if (canCharacterStateBeUpdated(
              keyboardCharacters[position], newCharacterState)) {
            continue;
          }

          keyboardCharacters[position] = newCharacterState;
        }
      }
    });

    gameState.stream.listen((gameState) {
      if (gameState is EndGameState) {
        resetKeyboard();
      }
    });
  }

  int findPositionEqualTo(String char) =>
      keyboardCharacters.indexWhere((state) => state.char == char);

  bool canCharacterStateBeUpdated(
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

  void resetKeyboard() {
    for (int i = 0; i < keyboardCharacters.length; i++) {
      final prevChar = keyboardCharacters[i].char;
      keyboardCharacters[i] = InitialCharacterState(prevChar);
    }
  }
}
