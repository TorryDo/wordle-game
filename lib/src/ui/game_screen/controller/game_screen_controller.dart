import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/common/class/my_toast.dart';
import 'package:wordle_game/src/common/interface/ui_notifier.dart';
import 'package:wordle_game/src/common/interface/widget_lifecycle.dart';
import 'package:wordle_game/src/ui/game_screen/controller/game_observable_data.dart';
import 'package:wordle_game/src/ui/game_screen/controller/setup_keyboard.dart';
import 'package:wordle_game/src/ui/game_screen/controller/setup_save_game.dart';
import 'package:wordle_game/src/ui/game_screen/controller/setup_wordboard.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/type_state.dart';
import 'package:wordle_game/src/ui/routes.dart';
import 'package:wordle_game/src/utils/constants.dart';
import 'package:wordle_game/src/utils/logger.dart';

class GameScreenController extends GameObservableData
    with WidgetLifecycle, UINotifierReceiver {
  final _logger = Logger()
      .setDebugEnabled(Constants.IS_DEBUG_ANABLED)
      .setTag((GameScreenController).toString());

  Rx<AppLifecycleState?> lastLifecycleState = Rx(null);

  SetupWordBoard? setupWordBoard;
  SetupKeyboard? setupKeyboard;
  SetupSaveGame? setupSaveGame;

  GameScreenController() {
    setupSaveGame = SetupSaveGame(this);
    setupWordBoard = SetupWordBoard(this);
    setupKeyboard = SetupKeyboard(this);

    loadPreviousGameIfExist();
  }

// private function ----------------------------------------------------------

  void _observe() {
    gameState.stream.listen((gameState) {
      if (gameState is EndGameState) {
        Future.delayed(const Duration(seconds: 2), () {
          _navigateToEndGameScreen(gameState.hasWon);
        });
      }
    });

    // typeState.stream.listen((typeState) {
    //   _logger.d(typeState.toString());
    //   if (typeState is EnterState) {
    //     setupKeyboard?.updateStateBasedOnCharacters(typeState);
    //   }
    // });

    // gameBoardStateList.stream.listen((event) {
    //
    // });

    lastLifecycleState.stream.listen((appState) {
      if (appState == AppLifecycleState.inactive) {
        _logger.d(appState.toString());

        setupSaveGame?.save();

        _logger.d("save in on paused");
      }
    });

    // gameBoardStateList.stream.listen((charList) {
    //   _logger.d(charList.toString());
    // });
  }

  void loadPreviousGameIfExist() async {
    saveGameModel.value = await keyValueRepository.getLastGameData();
    if (saveGameModel.value != null) {
      setupSaveGame?.setupFromPreviousGameState();
    } else {
      setupNewGame();
    }
  }

  void _navigateToEndGameScreen(bool won) async {
    var fakeInputWord = "input";
    var targetWord = await setupWordBoard?.wordListRepository.getTargetWord();

    _logger.d("$fakeInputWord $targetWord");

    Get.toNamed(Routes.END_GAME_SCREEN, arguments: [
      // {"hasWon": won},
      {"first": fakeInputWord},
      {"second": targetWord}
    ]);
  }

  void setupNewGame({
    int length = 5,
  }) {
    wordLength.value = length;
    var itemNumber = (wordLength.value + 1) * wordLength.value;
    setupWordBoard?.initWordBoard(itemNumber, wordLength.value);
    setupWordBoard?.setupTargetWord();
    if (saveGameModel.value != null) setupSaveGame?.deleteSaveGame();
  }

  void resetTheGame() {
    setupWordBoard?.resetWordBoard();
    setupKeyboard?.resetKeyboard();
    setupSaveGame?.deleteSaveGame();
  }

  // lifecycle -----------------------------------------------------------------

  @override
  void onInitState() {
    _observe();
  }

  @override
  void onDispose() {
    MyToast.makeText("onDispose");
  }
}
