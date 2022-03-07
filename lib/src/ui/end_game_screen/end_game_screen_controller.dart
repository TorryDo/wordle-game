import 'package:get/get.dart';
import 'package:wordle_game/src/common/interface/ui_notifier.dart';
import 'package:wordle_game/src/common/interface/widget_lifecycle.dart';
import 'package:wordle_game/src/ui/routes.dart';

import '../../utils/constants.dart';
import '../../utils/logger.dart';

class EndGameScreenController extends GetxController
    with WidgetLifecycle, UINotifierReceiver {

  final logger = Logger()
      .setDebugEnabled(Constants.IS_DEBUG_ANABLED)
      .setTag((EndGameScreenController).toString());

  dynamic argumentData = Get.arguments;

  @override
  void onInit() {
    // logger.d(argumentData);
    super.onInit();
  }

  // lifecycle -----------------------------------------------------------------
  @override
  void onInitState() {

  }
  @override
  void onBuildState() {
  }
  @override
  void onDispose() {
  }

  // onClick -------------------------------------------------------------------

  void navigateBackToGameScreen(){
    // Get.offAllNamed(Routes.GAME_SCREEN);
    Get.back();
  }

}
