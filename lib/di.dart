import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';
import 'package:wordle_game/src/ui/splash_screen/splash_screen_controller.dart';


Future di() async{
  await _initHive();
  _injectRepo();
  _injectGetXController();
}

/// priority: 1
Future _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SaveGameModelAdapter());
  Hive.registerAdapter(PlayingGameStateAdapter());
  Hive.registerAdapter(EndGameStateAdapter());
  Hive.registerAdapter(InitialCharacterStateAdapter());
  Hive.registerAdapter(RightCharacterRightPositionStateAdapter());
  Hive.registerAdapter(RightCharacterWrongPositionStateAdapter());
  Hive.registerAdapter(WrongCharacterStateAdapter());
  await Hive.openBox<SaveGameModel>(KeyValueAccessor.DEFAULT_BOX_NAME);

}

/// priority: 2
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

/// priority: 3
void _injectGetXController() {
  Get.put(SplashScreenController());
  Get.put(GameScreenController());
  Get.put(EndGameScreenController());
}
