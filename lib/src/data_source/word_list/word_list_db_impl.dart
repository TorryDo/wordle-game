import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/data_source/word_list/vocab.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_db.dart';

class WordListDataBaseImpl implements WordListDatabase {
  // List<String> _wordsDB = [];

  final ListNotifier<String> _wordsDbObs = ListNotifier();

  Random random = Random();

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

    String? output = _wordsDbObs.value
        .firstWhereOrNull((element) => element == wordInLowerCase);

    return output != null;
  }

  @override
  Future<String> getRandomWord() async {
    if (_wordsDbObs.value.isNotEmpty) {
      return _wordsDbObs.value[random.nextInt(_wordsDbObs.value.length)];
    }

    Completer completer = Completer();

    _wordsDbObs.observe((stringList) {
      completer.complete(stringList[random.nextInt(_wordsDbObs.value.length)]);
    });

    String str = await completer.future;

    dev.log(str);

    return str;
  }

  // private -------------------------------------------------------------------

  _loadFileToLocalList() async {
    if (_wordsDbObs.value.isNotEmpty) return;

    String loadedText = await rootBundle.loadString('assets/raws/words_5.txt');

    _wordsDbObs.setValue = loadedText.split('\r\n');
  }

  // test ----------------------------------------------------------------------

  get getWordsDB => _wordsDbObs.value;
}

class ListNotifier<T> {
  List<T> _list = [];

  Function(List<T>)? _job;

  bool _isCalledFirstTime = false;

  void listenFirstTimeCall() {
    if (_job != null) _job!(_list);
  }

  set setValue(List<T> list) {
    _list = list;

    if (!_isCalledFirstTime) listenFirstTimeCall();
    _isCalledFirstTime = true;

    _notify();
  }

  List<T> get value => _list;

  void _notify() {}

  void observe(Function(List<T>) func) {
    _job = func;
  }
}
