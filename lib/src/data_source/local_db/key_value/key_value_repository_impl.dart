import 'package:wordle_game/src/data_source/local_db/key_value/get_data/hive_key_value_impl.dart';
import 'package:wordle_game/src/data_source/local_db/key_value/get_data/key_value_accessor.dart';
import 'package:wordle_game/src/data_source/local_db/key_value/modal/save_game_model.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';

import 'key_value_repository.dart';

class KeyValueRepositoryIml implements KeyValueRepository {
  KeyValueAccessor? keyValueAccessor;

  KeyValueAccessor get accessor {
    keyValueAccessor ??= HiveKeyValueImpl();

    return keyValueAccessor!;
  }

  KeyValueRepositoryIml({required this.keyValueAccessor});

  // override ------------------------------------------------------------------

  @override
  Future<SaveGameModel?> getLastGameData() {
    return accessor.getPreviousGameData();
  }

  @override
  void updateGameData(SaveGameModel gameModel) {
    accessor.updateGameData(gameModel);
  }

  @override
  void createGameData(SaveGameModel gameModel) {
    accessor.createGameData(gameModel);
  }
}
