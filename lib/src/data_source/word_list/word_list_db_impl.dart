import 'package:flutter/services.dart';
import 'package:wordle_game/src/data_source/word_list/vocab.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_db.dart';

class WordListDataBaseImpl implements WordListDatabase {

  List<String> _wordsDB = [];

  WordListDataBaseImpl() {
    _loadFileToLocalList();
  }

  @override
  Future<Vocab?> findWord(String word) async {
    String w = _wordsDB.firstWhere((element) => element == word.toLowerCase());

    return Vocab(title: w);
  }

  _loadFileToLocalList() async {
    // if (_wordsDB.isNotEmpty) return;

    String loadedText = await rootBundle.loadString('assets/raws/words_5.txt');

    _wordsDB = loadedText.split('\r');

  }

  /// test ---------------------------------------------------------------------

  get getWordsDB => _wordsDB;

}
