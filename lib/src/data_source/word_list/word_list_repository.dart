class WordListRepository {


  Future<bool> doesWordExist(){
    return Future.delayed(const Duration(milliseconds: 1500), () {
      return true;
    });
  }
}
