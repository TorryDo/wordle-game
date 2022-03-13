import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/common/interface/ui_notifier.dart';
import 'package:wordle_game/src/common/interface/widget_lifecycle.dart';
import 'package:wordle_game/src/ui/end_game_screen/end_game_screen_controller.dart';
import 'package:wordle_game/src/ui/game_screen/controller/game_observable_data.dart';
import 'package:wordle_game/src/ui/game_screen/controller/setup_keyboard.dart';
import 'package:wordle_game/src/ui/game_screen/controller/setup_save_game.dart';
import 'package:wordle_game/src/ui/game_screen/controller/setup_wordboard.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';
import 'package:wordle_game/src/ui/routes.dart';
import 'package:wordle_game/src/utils/constants.dart';
import 'package:wordle_game/src/utils/logger.dart';

class GameScreenController extends GameObservableData
    with WidgetLifecycle, UINotifierReceiver {
  //
  final _logger = Logger()
      .setDebugEnabled(Constants.IS_DEBUG_ANABLED)
      .setTag((GameScreenController).toString());

  Rx<AppLifecycleState?> appLifeCycleState = Rx(null);

  SetupWordBoard? setupWordBoard;
  SetupKeyboard? setupKeyboard;
  SetupSaveGame? setupSaveGame;

  GameScreenController() {
    setupWordBoard = SetupWordBoard(this);
    setupKeyboard = SetupKeyboard(this);
    setupSaveGame = SetupSaveGame(this);

    /// CAUTION: duplicated function
    _loadPreviousGameIfExist();
  }

  // lifecycle -----------------------------------------------------------------

  @override
  void onInitState() {
    _observe();
    /// CAUTION: duplicated function
    _loadPreviousGameIfExist();
  }

  @override
  void onBuildState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _navigateIfPreviousGameEnded();
    });
  }

  @override
  void onDispose() {
    _removeObserver();
  }

  // public --------------------------------------------------------------------

  void setupNewGame({
    int length = 5,
  }) {
    wordLength.value = length;
    var itemNumber = (wordLength.value + 1) * wordLength.value;
    setupKeyboard?.resetKeyboard();
    setupWordBoard?.initWordBoard(itemNumber, wordLength.value);
    setupWordBoard?.setupTargetWord();
    setupSaveGame?.deleteSaveGame();
    gameState.value = const PlayingGameState();
  }

  // private function ----------------------------------------------------------

  StreamSubscription? _gameStateListener;
  StreamSubscription? _appLifeCycleListener;

  void _observe() {
    /// observe gameState
    /// - navigate to endGameScreen if 'gameState' is 'EndGameState'
    _gameStateListener = gameState.stream.listen((gameState) {
      if (gameState is EndGameState) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          navigateToEndGameScreen(gameState.hasWon);
        });
      }
    });

    /// observe appLifecycle
    /// - save game data when app on in-active state
    _appLifeCycleListener = appLifeCycleState.stream.listen((appState) {
      if (appState == AppLifecycleState.inactive) {
        setupSaveGame?.save();

        _logger.d("save in on paused");
      }
    });
  }

  /// remove observer when the widget is disposed from the widget-tree
  void _removeObserver() {
    _gameStateListener?.cancel();
    _appLifeCycleListener?.cancel();
    _logger.d("removed observer");
  }

  /// if previous gameData exists, load Data? into GameObservableData's variable
  /// then check the condition
  void _loadPreviousGameIfExist() async {
    saveGameModel.value = await keyValueRepository.getLastGameData();
    if (saveGameModel.value != null) {
      setupSaveGame?.setupFromPreviousGameState();
    } else {
      setupNewGame();
    }
  }

  void navigateToEndGameScreen(bool won) {
    Get.toNamed(Routes.END_GAME_SCREEN, arguments: [
      {"hasWon": won},
      {"targetWord": targetWord.value},
    ])?.then((value) {
      _logger.d("receive in game screen controller, value = $value");
      if (value == EndGameScreenController.newGame) {
        setupNewGame();
      }
    });
  }

  void _navigateIfPreviousGameEnded() {
    var _gameState = gameState.value;
    if (_gameState is EndGameState) {
      navigateToEndGameScreen(_gameState.hasWon);
    }
  }
}
