import 'package:wordle_game/src/data_source/word_list/word_list_db.dart';
import 'package:wordle_game/src/data_source/word_list/word_list_repository.dart';

class WordListRepositoryImpl extends WordListRepository {
  final WordListDatabase wordListDatabase;

  WordListRepositoryImpl(this.wordListDatabase);

  /// override -----------------------------------------------------------------

  @override
  Future<bool> isWordExist(String word) {
    return wordListDatabase.isWordExist(word);
  }

  @override
  Future<String> getRandomWord() {
    return wordListDatabase.getRandomWord();
  }

  /// test ---------------------------------------------------------------------

}
