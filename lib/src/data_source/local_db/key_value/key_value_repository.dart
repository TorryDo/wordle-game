import 'package:wordle_game/src/data_source/local_db/key_value/modal/save_game_model.dart';

abstract class KeyValueRepository{

  Future<SaveGameModel?> getLastGameData();

  void updateGameData(SaveGameModel gameMode);

  void createGameData(SaveGameModel gameModel);

  void deleteGameData();


}