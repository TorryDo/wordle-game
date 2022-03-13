import 'package:hive/hive.dart';
import 'package:wordle_game/src/data_source/local_db/key_value/get_data/key_value_accessor.dart';
import 'package:wordle_game/src/data_source/local_db/key_value/modal/save_game_model.dart';

class HiveKeyValueImpl implements KeyValueAccessor {

  Box<SaveGameModel>? _box;

  Box<SaveGameModel> get box{
    _box ??= (Hive.box<SaveGameModel>(KeyValueAccessor.DEFAULT_BOX_NAME));

    return _box!;
  }

  @override
  Future<SaveGameModel?> getPreviousGameData() async {
    SaveGameModel? saveGameModel;
    if(box.isNotEmpty){
      saveGameModel = box.getAt(0);
    }

    return saveGameModel;
  }

  @override
  void updateGameData(SaveGameModel gameModel) async {
    gameModel.save();
  }

  @override
  void createGameData(SaveGameModel gameModel) {
    if(box.isNotEmpty){
      box.putAt(0, gameModel);
    }else{
      box.add(gameModel);
    }
  }

  @override
  void deleteGameData() {
    box.deleteAt(0);
  }
}
