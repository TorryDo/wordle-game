abstract class WordListRepository {
  Future<bool> isWordExist(String word);

  Future<String> getRandomWord();

  Future<String> getTargetWord();

}
