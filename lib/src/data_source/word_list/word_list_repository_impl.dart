import 'package:wordle_game/src/data_source/word_list/word_list_db.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_repository.dart';

class WordListRepositoryImpl extends WordListRepository {
  final WordListDatabase wordListDatabase;

  WordListRepositoryImpl(this.wordListDatabase);

  /// impl ---------------------------------------------------------------------

  @override
  Future<bool> isWordExist(String word) async {
    final b = await wordListDatabase.isWordExist(word);
    return b;
  }

  @override
  Future<String> getRandomWord() async {
    return "hello";
  }

  /// test ---------------------------------------------------------------------

}
