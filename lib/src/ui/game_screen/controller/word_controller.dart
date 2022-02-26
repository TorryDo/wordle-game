import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:wordle_game/src/ui/game_screen/controller/word_list_controller.dart';
import 'package:wordle_game/src/utils/extension.dart';

import '../../../data_source/word_list/word_list_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/logger.dart';


class WordController extends GetxController {
  static const WRONG_CHAR = 0;
  static const RIGHT_CHAR_RIGHT_PLACE = 2;
  static const RIGHT_CHAR_WRONG_PLACE = 1;
  static const PLACE_HOLDER_CHAR = '-';

  final logger = Logger()
      .setDebugEnabled(Constants.IS_DEBUG_ANABLED)
      .setTag((WordListController).toString());

  final wordListRepository = GetIt.I.get<WordListRepository>();

  var wordLength = 0;

  RxString targetWord = RxString('');

  List<int> getCharactersStatusListInWord(String target, String input) {
    input = input.toLowerCase();

    List<int> rs = List.filled(target.length, WRONG_CHAR);

    List<String> targetChars = target.split('');

    for (int i = 0; i < target.length; i++) {
      if (!target.contains(input[i])) {
        input = input.replaceCharAt(i, PLACE_HOLDER_CHAR);
      }
    }

    final size = target.length;

    for (int i = 0; i < size; i++) {
      if (!targetChars.contains(input[i])) continue;
      targetChars.remove(input[i]);

      if (input[i] == PLACE_HOLDER_CHAR) continue;
      if (target[i] == input[i]) {
        rs[i] = RIGHT_CHAR_RIGHT_PLACE;
        continue;
      }
      rs[i] = RIGHT_CHAR_WRONG_PLACE;
    }

    return rs;
  }

  void setupTargetWord({Function(bool)? wordReady}) async {
    targetWord.value = await wordListRepository.getRandomWord();
    wordReady ?? (true);
  }

  bool isMatchedTargetWord(String word) {
    return word.toLowerCase() == targetWord.value;
  }

  void isExistWord(String word, Function(bool) result) async {
    bool b = await wordListRepository.isWordExist(word);
    result(b);
  }

  bool isEndOfWord(int wordLength, int position) => position == wordLength;

  bool isStartOfWord(int position) => position <= 0;
}
