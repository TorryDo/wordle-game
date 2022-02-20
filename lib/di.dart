import 'package:get_it/get_it.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_db_impl.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_repository.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_repository_impl.dart';

void di() {
  GetIt.I.registerSingleton<WordListRepository>(
      WordListRepositoryImpl(WordListDataBaseImpl())
  );
}
