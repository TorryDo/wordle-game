import 'package:get/get.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/type_state.dart';

class GameObservableData extends GetxController {
  final RxString targetWord = RxString('');

  final Rx<GameState> gameState = Rx<GameState>(const InitialGameState());

  final RxList<CharacterState> gameBoardStateList = RxList<CharacterState>();

  final RxList<CharacterState> keyboardCharacters = RxList<CharacterState>([
    'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', // start: 0, end: 10
    'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', // start: 10, end: 19
    'Z', 'X', 'C', 'V', 'B', 'N', 'M' // start: 19, end: 26
  ].toCharacterStateList());

  final Rx<TypeState> typeState = Rx<TypeState>(const InitialState());
}
