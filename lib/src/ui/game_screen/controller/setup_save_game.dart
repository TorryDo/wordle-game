import 'package:wordle_game/src/ui/game_screen/controller/observable_game_data.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';

import '../../../data_source/local_db/key_value/modal/save_game_model.dart';
import '../../../utils/logger.dart';

class SetupSaveGame with Logger {
  /// the 'liveData' is required for all function below work properly
  ///
  /// some of the functions below will update some Rx<Data> inside 'liveData'
  final ObservableGameData liveData;

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
      _addNewGameData();
    } else {
      _saveGameData();
    }

    d("game saved, targetWord = ${liveData.targetWord.value.toString()}");
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

  // private -------------------------------------------------------------------

  void _addNewGameData() {
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
  }
}
