import 'package:wordle_game/src/utils/extension.dart';

class WordListControllerSupport{

  static const WRONG_CHAR = 0;
  static const RIGHT_CHAR_RIGHT_PLACE = 2;
  static const RIGHT_CHAR_WRONG_PLACE = 1;
  static const PLACE_HOLDER_CHAR = '-';


  List<int> getCharactersStatusInWord(String target, String input){

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

}