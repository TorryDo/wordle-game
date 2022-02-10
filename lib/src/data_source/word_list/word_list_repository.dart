import 'package:wordle_game/src/data_source/word_list/vocab.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_db.dart';

class WordListRepository {

  final WordListDatabase wordListDatabase;

  const WordListRepository({required this.wordListDatabase});

  Future<bool> findWord(String word) async {
    // bool b = await Future.delayed(const Duration(milliseconds: 100), () {
    //   return true;
    // });
    Vocab? vocab = await wordListDatabase.findWord(word);

    if(vocab != null) return true;

    return false;
  }
}
