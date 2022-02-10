import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_db_impl.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_repository.dart';

main() {
  _validateIfWordExist();
}

void _validateIfWordExist() async {

  final repo = WordListRepository(
      wordListDatabase: WordListDataBaseImpl(
          futureDatabase: openDatabase('assets/raws/words_567.db')));

  test("validate word", () async {

    bool shouldTrue = await repo.findWord('hello');
    bool shouldFalse = await repo.findWord('sdfhd');

    expect(shouldTrue, true);
    expect(shouldFalse, false);
  });
}
