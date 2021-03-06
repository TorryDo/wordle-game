import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:wordle_game/src/data_source/local_db/key_value/key_value_repository.dart';
import 'package:wordle_game/src/data_source/local_db/key_value/modal/save_game_model.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/type_state.dart';

class ObservableGameData extends GetxController {
  //

  final RxString targetWord = RxString('');
  final RxInt wordLength = RxInt(0);

  final Rx<GameState> gameState = Rx<GameState>(const PlayingGameState());

  final RxList<CharacterState> gameBoardStateList = RxList<CharacterState>();

  final RxList<CharacterState> keyboardStateList = RxList<CharacterState>([
    'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', // start: 0, end: 9
    'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', // start: 10, end: 18
    'Z', 'X', 'C', 'V', 'B', 'N', 'M' // start: 19, end: 25
  ].toInitialCharacterStateList());

  final Rx<TypeState> typeState = Rx<TypeState>(const InitialState());

  final KeyValueRepository keyValueRepository =
      GetIt.I.get<KeyValueRepository>();

  final Rx<SaveGameModel?> saveGameModel = Rx(null);

  // getter & setter -----------------------------------------------------------

  bool get havePreviousGameData => saveGameModel.value != null;
}
