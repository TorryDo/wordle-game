import 'package:wordle_game/src/common/interface/widget_lifecycle.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/word_list_controller.dart';

class GameScreenController extends WordListController with WidgetLifecycle {
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
          Future.delayed(const Duration(seconds: 2), resetTheGame);
        }
      }
    });
  }
}
