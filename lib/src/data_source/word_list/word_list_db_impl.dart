import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/data_source/word_list/vocab.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_db.dart';

import '../../common/class/list_notifier.dart';

class WordListDataBaseImpl implements WordListDatabase {
  final ListNotifier<String> _wordCollection = ListNotifier();

  final Random random = Random();

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

    String? output = _wordCollection.value
        .firstWhereOrNull((element) => element == wordInLowerCase);

    return output != null;
  }

  /// kiểm tra function dưới sau.
  /// khi chưa thêm "if(completer.isCompleted) return;" thì báo lỗi badstate, future already completed
  @override
  Future<String> getRandomWord() async {
    if (_wordCollection.value.isNotEmpty) {
      String str =
          _wordCollection.value[random.nextInt(_wordCollection.value.length)];
      dev.log(str);
      return str;
    }

    Completer completer = Completer();

    _wordCollection.observe((stringList) {
      if(completer.isCompleted) return;
      completer.complete(
          stringList[random.nextInt(_wordCollection.value.length)]
      );

    });

    String str = (await completer.future).toString();

    dev.log(str);

    return str;
  }

  // private -------------------------------------------------------------------

  _loadFileToLocalList() async {
    if (_wordCollection.value.isNotEmpty) return;

    String loadedText = await rootBundle.loadString('assets/raws/words_5.txt');

    _wordCollection.value = loadedText.split('\r\n');
  }

  // test ----------------------------------------------------------------------

  get getWordsDB => _wordCollection.value;
}
