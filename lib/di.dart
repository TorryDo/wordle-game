import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:wordle_game/main_controller.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_db_impl.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_repository.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_repository_impl.dart';
import 'package:wordle_game/src/ui/game_screen/controller/game_screen_controller.dart';
import 'package:wordle_game/src/ui/splash_screen/splash_screen_controller.dart';

void di() {
  _injectRepo();
  _injectGetXController();
}

// must inject repo first
void _injectRepo() {
  GetIt.I.registerSingleton<WordListRepository>(
      WordListRepositoryImpl(WordListDataBaseImpl()));
}

void _injectGetXController() {
  Get.put(MainController());
  Get.put(SplashScreenController());
  Get.put(GameScreenController());
}
