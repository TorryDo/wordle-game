import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_db_impl.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_repository.dart';

void di() {
  GetIt.I.registerSingleton<WordListRepository>(WordListRepository(
      wordListDatabase: WordListDataBaseImpl(
          futureDatabase: openDatabase('assets/raws/words_567.db')
      )
  ));
}
