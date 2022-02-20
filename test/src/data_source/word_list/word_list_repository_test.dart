import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:wordle_game/src/data_source/word_list/vocab.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_db_impl.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_repository_impl.dart';

main() {
  // WidgetsFlutterBinding.ensureInitialized();
  _validateIfWordExist();
}

void _validateIfWordExist() async {

  // var repo = WordListRepositoryImpl(WordListDataBaseImpl());

  var repo = WordListDataBaseImpl();

  test("test repo", () async{
    Vocab? vocab = await repo.findWord("hello");

    log(vocab.toString());

    expect(false, true);

  });

}
