import 'package:get/get.dart';
import 'package:wordle_game/src/common/interface/widget_lifecycle.dart';
import 'package:wordle_game/src/ui/game_screen/game_screen.dart';

import '../../utils/constants.dart';
import '../../utils/logger.dart';

class SplashScreenController extends GetxController with WidgetLifecycle{

  final logger = Logger()
      .setDebugEnabled(Constants.IS_DEBUG_ANABLED)
      .setTag((SplashScreenController).toString());

  void _navigateToGameScreenAfter() async {

    int delayTime = 1500;

    await Future.delayed(Duration(milliseconds: delayTime), () {});
    Get.to(() => const GameScreen());
  }

  // lifecycle -----------------------------------------------------------------

  @override
  void onInitState() {
    logger.d("onInitWidget");
  }

  @override
  void onBuildState() {
    _navigateToGameScreenAfter();
    logger.d("onBuildWidget");
  }

  @override
  void onDidChangeDependencies() {
    logger.d("onPauseWidget");
  }

  @override
  void onDispose() {
    logger.d("onResumeWidget");
  }


}