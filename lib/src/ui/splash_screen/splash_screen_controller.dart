import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wordle_game/src/common/interface/widget_lifecycle.dart';
import 'package:wordle_game/src/data_source/local_db/key_value/get_data/key_value_accessor.dart';
import 'package:wordle_game/src/data_source/local_db/key_value/modal/save_game_model.dart';
import 'package:wordle_game/src/ui/game_screen/game_screen.dart';
import 'package:wordle_game/src/ui/routes.dart';

import '../../common/class/my_toast.dart';
import '../../utils/constants.dart';
import '../../utils/logger.dart';

class SplashScreenController extends GetxController with WidgetLifecycle {
  final logger = Logger()
      .setDebugEnabled(Constants.IS_DEBUG_ANABLED)
      .setTag((SplashScreenController).toString());



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
  void _navigateToGameScreenAfter() {
    int delayTime = 1500;

    Future.delayed(Duration(milliseconds: delayTime), () async{
      Get.offNamed(Routes.GAME_SCREEN);
    });

  }

}
