import 'package:wordle_game/src/ui/game_screen/controller/game_observable_data.dart';

import '../../../data_source/local_db/key_value/modal/save_game_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/logger.dart';

class SetupSaveGame {
  final _logger = Logger()
      .setDebugEnabled(Constants.IS_DEBUG_ANABLED)
      .setTag((SetupSaveGame).toString());

  final GameObservableData liveData;

  SetupSaveGame(this.liveData);

  // -----------------------------------------------------------------------

  void setupFromPreviousGameState() async {
    liveData.targetWord.value = liveData.saveGameModel.value!.targetWord;
    liveData.wordLength.value = liveData.saveGameModel.value!.targetWord.length;
    liveData.gameBoardStateList.value =
        liveData.saveGameModel.value!.gameBoardStateList;
    liveData.gameState.value = liveData.saveGameModel.value!.gameState;

    checkIfPreviousGameEnded();
  }

  void save() {
    if (liveData.saveGameModel.value == null) {
      var newSaveGameModel = SaveGameModel()
        ..targetWord = liveData.targetWord.value
        ..gameState = liveData.gameState.value
        ..gameBoardStateList = liveData.gameBoardStateList;

      liveData.keyValueRepository.createGameData(newSaveGameModel);
    } else {
      liveData.saveGameModel.value!
        ..targetWord = liveData.targetWord.value
        ..gameState = liveData.gameState.value
        ..gameBoardStateList = liveData.gameBoardStateList;

      // liveData.keyValueRepository.updateGameData(liveData.saveGameModel.value!);
      liveData.saveGameModel.value!.save();
    }
  }

  void deleteSaveGame() {
    if (liveData.saveGameModel.value != null) {
      liveData.keyValueRepository.deleteGameData();
      liveData.saveGameModel.value = null;
    }
  }

  void checkIfPreviousGameEnded() {}
}
