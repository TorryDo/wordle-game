import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:wordle_game/src/data_source/word_list/vocab.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_db.dart';

class WordListDataBaseImpl implements WordListDatabase {
  List<String> _wordsDB = [];

  WordListDataBaseImpl() {
    _loadFileToLocalList();
  }

  @Deprecated("unImplementation")
  @override
  Future<Vocab?> findWord(String word) async {
    return null;
  }

  @override
  Future<bool> isWordExist(String word) async {

    final wordInLowerCase = word.toLowerCase();

    String? output =
        _wordsDB.firstWhereOrNull((element) => element == wordInLowerCase);

    return output != null;
  }

  _loadFileToLocalList() async {
    if (_wordsDB.isNotEmpty) return;

    String loadedText = await rootBundle.loadString('assets/raws/words_5.txt');

    _wordsDB = loadedText.split('\r\n');
    // for(int i =0; i<_wordsDB.length; i++){
    //   _wordsDB[i].replaceAll(' ', '');
    // }

    // log(_wordsDB[0] +'-' + _wordsDB[1] + '-' + _wordsDB[2]);
  }

  /// test ---------------------------------------------------------------------

  get getWordsDB => _wordsDB;
}
