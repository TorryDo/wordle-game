import 'package:get_it/get_it.dart';
import 'package:wordle_game/src/ui/game_screen/word_board/word_state.dart';

import '../../data_source/word_list/word_list_repository.dart';

class WordController {

  final wordListRepository = GetIt.I.get<WordListRepository>();
  WordState wordState = const InitialWordState();

  void validateWord(
      {required String word, required Function(bool b) result}) async {
    bool b = await wordListRepository.isWordExist(word);
    result(b);
  }
}
