import 'package:wordle_game/src/common/interface/widget_lifecycle.dart';
import 'package:wordle_game/src/ui/game_screen/controller/game_observable_data.dart';
import 'package:wordle_game/src/ui/game_screen/controller/setup_game_board.dart';
import 'package:wordle_game/src/ui/game_screen/controller/setup_keyboard.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';

class GameScreenController extends GameObservableData with WidgetLifecycle {

  // GameObservableData gameObservableData = GameObservableData();

  SetupKeyboard? setupKeyboard;
  SetupGameBoard? setupGameBoard;

  GameScreenController() {
    setupKeyboard = SetupKeyboard(
        keyboardCharacters: keyboardCharacters,
        typeState: typeState,
        gameState: gameState);
    setupGameBoard = SetupGameBoard(
        targetWord: targetWord,
        gameState: gameState,
        gameBoardStateList: gameBoardStateList,
        typeState: typeState);
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
          Future.delayed(
              const Duration(seconds: 2), setupGameBoard?.resetTheGame);
        }
      }
    });
  }
}
