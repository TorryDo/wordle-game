import 'package:wordle_game/src/ui/game_screen/controller/game_observable_data.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';

import '../../../data_source/local_db/key_value/modal/save_game_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/logger.dart';

class SetupSaveGame{

  final _logger = Logger()
      .setDebugEnabled(Constants.IS_DEBUG_ANABLED)
      .setTag((SetupSaveGame).toString());

  final GameObservableData liveData;

  SetupSaveGame(this.liveData);

  // -----------------------------------------------------------------------

  void setupFromPreviousGameState() async {
    // _logger.d(liveData.saveGameModel.value!.gameBoardStateList.toString());

    liveData.targetWord.value = liveData.saveGameModel.value!.targetWord;
    liveData.wordLength.value = liveData.saveGameModel.value!.targetWord.length;
    liveData.gameBoardStateList.value = liveData.saveGameModel.value!.gameBoardStateList
        .toStateListFrom(target: liveData.saveGameModel.value!.targetWord);

    // _logger.d(liveData.gameBoardStateList.toString());
  }

  void save(){
    if (liveData.saveGameModel.value == null) {
      var newSaveGameModel = SaveGameModel()
        ..targetWord = liveData.targetWord.value
        ..gameBoardStateList = liveData.gameBoardStateList.toStringList();

      liveData.keyValueRepository.createGameData(newSaveGameModel);
    } else {
      liveData.saveGameModel.value!
        ..targetWord = liveData.targetWord.value
        ..gameBoardStateList = liveData.gameBoardStateList.toStringList();

      liveData.saveGameModel.value!.save();
    }
  }

  void deleteSaveGame(){
    liveData.keyValueRepository.deleteGameData();
  }


}