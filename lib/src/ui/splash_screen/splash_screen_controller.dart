import 'package:get/get.dart';
import 'package:wordle_game/src/common/interface/widget_lifecycle.dart';
import 'package:wordle_game/src/ui/routes.dart';

import '../../utils/logger.dart';

class SplashScreenController extends GetxController
    with WidgetLifecycle, Logger {

  // lifecycle -----------------------------------------------------------------

  @override
  void onInitState() {}

  @override
  void onBuildState() {
    _navigateToGameScreenAfter();
  }

  @override
  void onDispose() {}

  // private -------------------------------------------------------------------
  void _navigateToGameScreenAfter() async {
    int delayTime = 1500;
    // await _openHiveBox();
    Future.delayed(Duration(milliseconds: delayTime), () async {
      Get.offNamed(Routes.GAME_SCREEN);
    });
  }

}
