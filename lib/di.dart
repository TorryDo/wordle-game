import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wordle_game/src/data_source/local_db/key_value/get_data/hive_key_value_impl.dart';
import 'package:wordle_game/src/data_source/local_db/key_value/get_data/key_value_accessor.dart';
import 'package:wordle_game/src/data_source/local_db/key_value/key_value_repository.dart';
import 'package:wordle_game/src/data_source/local_db/key_value/key_value_repository_impl.dart';
import 'package:wordle_game/src/data_source/local_db/key_value/modal/save_game_model.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_db_impl.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_repository.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_repository_impl.dart';
import 'package:wordle_game/src/ui/end_game_screen/end_game_screen_controller.dart';
import 'package:wordle_game/src/ui/game_screen/controller/game_screen_controller.dart';
import 'package:wordle_game/src/ui/splash_screen/splash_screen_controller.dart';

void di() {
  _injectRepo();
  _injectGetXController();
}



// must inject repo first
void _injectRepo() {
  GetIt.I.registerSingleton<WordListRepository>(
    WordListRepositoryImpl(
      wordListDatabase: WordListDataBaseImpl(),
    ),
  );
  GetIt.I.registerSingleton<KeyValueRepository>(
    KeyValueRepositoryIml(
      keyValueAccessor: HiveKeyValueImpl(),
    ),
  );
}

void _injectGetXController() {
  Get.put(SplashScreenController());
  Get.put(GameScreenController());
  Get.put(EndGameScreenController());
}
