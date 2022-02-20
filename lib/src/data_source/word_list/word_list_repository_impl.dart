import 'dart:developer';

import 'package:wordle_game/src/data_source/word_list/vocab.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_db.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_repository.dart';

class WordListRepositoryImpl extends WordListRepository {

  final WordListDatabase wordListDatabase;

  WordListRepositoryImpl(this.wordListDatabase);

  @override
  Future<bool> isWordExist(String word) async {
    Vocab? vocab = await wordListDatabase.findWord(word);

    log("<>" + vocab.toString());

    if (vocab != null) {
      return true;
    } else {
      return false;
    }

  }

  /// test ---------------------------------------------------------------------


}