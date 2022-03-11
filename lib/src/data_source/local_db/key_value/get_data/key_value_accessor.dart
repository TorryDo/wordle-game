import 'package:wordle_game/src/data_source/local_db/key_value/modal/save_game_model.dart';

abstract class KeyValueAccessor {

  static String DEFAULT_BOX_NAME = "savegamebox";

  Future<SaveGameModel?> getPreviousGameData();

  void updateGameData(SaveGameModel gameModel);

  void createGameData(SaveGameModel gameModel);

  void deleteGameData();
}
