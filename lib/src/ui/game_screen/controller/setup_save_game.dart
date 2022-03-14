import 'package:wordle_game/src/ui/game_screen/controller/game_observable_data.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';

import '../../../data_source/local_db/key_value/modal/save_game_model.dart';
import '../../../utils/logger.dart';

class SetupSaveGame with Logger {
  final GameObservableData liveData;

  SetupSaveGame(this.liveData);

  // body ----------------------------------------------------------------------

  void updatePreviousGameData() async {
    updatePreviousTargetWord();
    updatePreviousWordLength();
    updatePreviousGameBoard();
    updatePreviousGameState();
  }

  void save() {
    if (liveData.saveGameModel.value == null) {
      _createGameData();
    } else {
      _saveGameData();
    }
  }

  void delete() {
    if (liveData.saveGameModel.value != null) {
      liveData.keyValueRepository.deleteGameData();
      liveData.saveGameModel.value = null;
    }
  }

  // for short -----------------------------------------------------------------

  void updatePreviousTargetWord() {
    liveData.targetWord.value = liveData.saveGameModel.value!.targetWord;
  }

  void updatePreviousWordLength() {
    liveData.wordLength.value = liveData.saveGameModel.value!.targetWord.length;
  }

  void updatePreviousGameBoard() {
    liveData.gameBoardStateList.value =
        liveData.saveGameModel.value!.gameBoardStateList;
  }

  void updatePreviousGameState() {
    liveData.gameState.value = const PlayingGameState();
    liveData.gameState.value = liveData.saveGameModel.value!.gameState;
  }

  void _createGameData() {
    var newSaveGameModel = SaveGameModel()
      ..targetWord = liveData.targetWord.value
      ..gameState = liveData.gameState.value
      ..gameBoardStateList = liveData.gameBoardStateList;

    liveData.keyValueRepository.createGameData(newSaveGameModel);
  }

  void _saveGameData() {
    liveData.saveGameModel.value!
      ..targetWord = liveData.targetWord.value
      ..gameState = liveData.gameState.value
      ..gameBoardStateList = liveData.gameBoardStateList;

    // liveData.keyValueRepository.updateGameData(liveData.saveGameModel.value!);
    liveData.saveGameModel.value!.save();

    d("game saved, targetWord = ${liveData.targetWord.value.toString()}");
  }
}
