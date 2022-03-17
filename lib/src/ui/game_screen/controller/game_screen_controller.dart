import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/common/interface/ui_notifier.dart';
import 'package:wordle_game/src/common/interface/widget_lifecycle.dart';
import 'package:wordle_game/src/ui/end_game_screen/end_game_screen.dart';
import 'package:wordle_game/src/ui/end_game_screen/end_game_screen_controller.dart';
import 'package:wordle_game/src/ui/game_screen/controller/observable_game_data.dart';
import 'package:wordle_game/src/ui/game_screen/controller/setup_keyboard.dart';
import 'package:wordle_game/src/ui/game_screen/controller/setup_save_game.dart';
import 'package:wordle_game/src/ui/game_screen/controller/setup_wordboard.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';
import 'package:wordle_game/src/ui/routes.dart';
import 'package:wordle_game/src/utils/logger.dart';

class GameScreenController extends ObservableGameData
    with WidgetLifecycle, UINotifierReceiver, Logger {
  //
  Rx<AppLifecycleState?> appLifeCycleState = Rx(null);

  SetupWordBoard? setupWordBoard;
  SetupKeyboard? setupKeyboard;
  SetupSaveGame? setupSaveGame;

  GameScreenController() {
    setupWordBoard = SetupWordBoard(this);
    setupKeyboard = SetupKeyboard(this);
    setupSaveGame = SetupSaveGame(this);

    _updatePreviousGameDataIfExist();
  }

  // lifecycle -----------------------------------------------------------------

  @override
  void onInitState() {
    _observe();
    _updateGameStateIfExist();
  }

  @override
  void onDisposeState() {
    _removeObserver();
  }

  // public --------------------------------------------------------------------

  void setupNewGame({
    int lengthInWord = 5,
  }) {
    wordLength.value = lengthInWord;
    var itemNumber = (wordLength.value + 1) * wordLength.value;
    setupKeyboard?.resetKeyboard();
    setupWordBoard?.initWordBoard(itemNumber, wordLength.value);
    setupWordBoard?.setupTargetWord();
    setupSaveGame?.delete();
    gameState.value = const PlayingGameState();
  }

  void navigateToEndGameScreen(bool won) {
    var _argumentSender = [
      {"hasWon": won},
      {"targetWord": targetWord.value},
    ];

    void _receiveAction(dynamic action) {
      if (action == EndGameScreenController.ACTION_NEW_GAME) {
        setupNewGame();
      }
    }

    Get.toNamed(
      Routes.END_GAME_SCREEN,
      arguments: _argumentSender,
    )?.then((action) {
      _receiveAction(action);
    });
  }

  // private function ----------------------------------------------------------

  StreamSubscription? _gameStateListener;
  StreamSubscription? _appLifeCycleListener;

  void _observe() {
    /// - navigate to endGameScreen if 'gameState' is 'EndGameState'
    _gameStateListener = gameState.stream.listen((gameState) {
      if (gameState is EndGameState) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          navigateToEndGameScreen(gameState.hasWon);
        });
      }
    });

    /// - save game data when app on in-active state
    _appLifeCycleListener = appLifeCycleState.stream.listen((appState) {
      if (appState == AppLifecycleState.inactive) {
        setupSaveGame?.save();
      }
    });
  }

  void _removeObserver() {
    _gameStateListener?.cancel();
    _appLifeCycleListener?.cancel();
  }

  // named  --------------------------------------------------------------------

  /// if previous gameData exists, load Data? into 'liveData'
  /// else, create new gameData and save it
  void _updatePreviousGameDataIfExist() async {
    saveGameModel.value = await keyValueRepository.getLastGameData();
    if (havePreviousGameData) {
      setupSaveGame?.updatePreviousGameData();
      d("update previous game data");
    } else {
      setupNewGame();
      d("create new game data");
    }
  }

  void _updateGameStateIfExist() {
    if (havePreviousGameData) {
      setupSaveGame?.updatePreviousGameState();
      d("update previous Game State");
    }
  }
}
