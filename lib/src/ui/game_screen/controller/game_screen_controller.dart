import 'package:wordle_game/src/common/interface/widget_lifecycle.dart';
import 'package:wordle_game/src/ui/game_screen/controller/game_observable_data.dart';
import 'package:wordle_game/src/ui/game_screen/controller/setup_keyboard.dart';
import 'package:wordle_game/src/ui/game_screen/controller/setup_wordboard.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/type_state.dart';

import '../../../utils/constants.dart';
import '../../../utils/logger.dart';

class GameScreenController extends GameObservableData with WidgetLifecycle {
  final _logger = Logger()
      .setDebugEnabled(Constants.IS_DEBUG_ANABLED)
      .setTag((GameScreenController).toString());

  SetupKeyboard? setupKeyboard;
  SetupWordBoard? setupWordBoard;

  GameScreenController() {
    setupWordBoard = SetupWordBoard(this);
    setupKeyboard = SetupKeyboard(this);
  }

  // lifecycle -----------------------------------------------------------------

  @override
  void onInitState() {
    _observe();
  }

  @override
  void onBuildState() {}

  @override
  void onDispose() {}

  // private function ----------------------------------------------------------

  void _observe() {
    gameState.stream.listen((gameState) {
      if (gameState is EndGameState) {
        if (gameState.hasWon) {
          Future.delayed(const Duration(seconds: 2), () {
            _logger.d("you win, genius");
            setupWordBoard?.resetTheGame();
            setupKeyboard?.resetKeyboard();
          });
        } else {
          Future.delayed(const Duration(seconds: 2), () {
            _logger.d("you lose, fool");
            setupWordBoard?.resetTheGame();
            setupKeyboard?.resetKeyboard();
          });
        }
      }
    });

    typeState.stream.listen((typeState) {
      if (typeState is EnterState) {
        setupKeyboard?.updateStateBasedOnCharacters(typeState);
      }
    });
  }
}
