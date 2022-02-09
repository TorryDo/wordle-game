class WordListRepository {

  Future<bool> findWord(String word){
    return Future.delayed(const Duration(milliseconds: 100), () {
      return true;
    });
  }
}
