import 'package:get/get.dart';
import 'package:wordle_game/src/common/interface/ui_notifier.dart';
import 'package:wordle_game/src/common/interface/widget_lifecycle.dart';

import '../../utils/constants.dart';
import '../../utils/logger.dart';

class EndGameScreenController extends GetxController
    with WidgetLifecycle, UINotifierReceiver {

  static const newGame = 1;

  final _logger = Logger()
      .setDebugEnabled(Constants.IS_DEBUG_ANABLED)
      .setTag((EndGameScreenController).toString());

  dynamic argumentData;
  bool get hasWon => argumentData[0]["hasWon"] as bool;
  String get targetWord => argumentData[1]["targetWord"] as String;
  

  // lifecycle -----------------------------------------------------------------
  @override
  void onInitState() {
    argumentData = Get.arguments;
    _logger.d("argument = ${argumentData.toString()}");
  }

  // func -- -------------------------------------------------------------------

  void navigateBackToGameScreen(){
    Get.back(result: newGame);
  }

}
