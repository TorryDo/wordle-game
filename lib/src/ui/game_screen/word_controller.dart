import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:wordle_game/src/ui/game_screen/word_board/word_state.dart';

import '../../data_source/word_list/word_list_repository.dart';

class WordController extends GetxController{
  var wordLength = 0;

  var targetWord = ''.obs;


  final wordListRepository = GetIt.I.get<WordListRepository>();

  Rx<WordState> wordState = Rx<WordState>(const InitialWordState());

  void setupTargetWord({Function(bool)? wordReady}) async {
    targetWord.value = await wordListRepository.getRandomWord();
    wordReady??(true);
  }

  bool isMatchedTargetWord(String word){
    return word == targetWord.value;
  }

  void isExistWord(String word, Function(bool) result) async {
    bool b = await wordListRepository.isWordExist(word);
    result(b);
  }

  void updateWordState(WordState newWordState){
    wordState.value = const InitialWordState();
    wordState.value = newWordState;
  }


}