import 'package:wordle_game/src/ui/game_screen/controller/setup_wordboard.dart';
import 'package:wordle_game/src/utils/extension.dart';

abstract class CharacterState {
  static const WRONG_CHAR = 0;
  static const RIGHT_CHAR_RIGHT_PLACE = 2;
  static const RIGHT_CHAR_WRONG_PLACE = 1;
  static const PLACE_HOLDER_CHAR = '-';

  final String char;

  const CharacterState(this.char);
}

class InitialCharacterState extends CharacterState {
  const InitialCharacterState(String char) : super(char);
}

class RightCharacterRightPositionState extends CharacterState {
  const RightCharacterRightPositionState(String char) : super(char);
}

class RightCharacterWrongPositionState extends CharacterState {
  const RightCharacterWrongPositionState(String char) : super(char);
}

class WrongCharacterState extends CharacterState {
  const WrongCharacterState(String char) : super(char);
}

// related func  ---------------------------------------------------------------

extension ConvertToCharacterStateList on List<String> {
  List<CharacterState> toInitialCharacterStateList() {
    final mList = map((e) => InitialCharacterState(e));
    return mList.toList();
  }

  List<CharacterState> toStateListFrom({
    required String target,
  }) {
    var results = <CharacterState>[];
    var stringList = this;

    var lastCharPosition =
        stringList.lastIndexWhere((c) => c != SetupWordBoard.EMPTY_CHAR);

    // action -------------------------------

    while (stringList.isNotEmpty) {
      if (lastCharPosition >= target.length-1) {
        var input = stringList.sublist(0, target.length).toWord();
        var inputStatues = getCharactersStatusListInWord(target, input);

        for (int i = 0; i < target.length; i++) {
          results.add(input[i].toStateFrom(inputStatues[i]));
        }

        stringList.removeRange(0, target.length);
      } else {
        for (var remainedCharacter in stringList) {
          results.add(InitialCharacterState(remainedCharacter));
        }
        stringList.clear();
      }
      lastCharPosition = stringList.lastIndexWhere((c) => c != SetupWordBoard.EMPTY_CHAR);
    }

    return results;
  }
}

extension ConvertFromCharListToCharState on List<CharacterState> {
  List<String> toStringList() {
    List<String> result = [];
    for (var item in this) {
      result.add(item.char);
    }
    return result;
  }
}

extension ConvertIntToState on String {
  CharacterState toStateFrom(int intState) {
    switch (intState) {
      case CharacterState.WRONG_CHAR:
        return WrongCharacterState(this);
        break;
      case CharacterState.RIGHT_CHAR_RIGHT_PLACE:
        return RightCharacterRightPositionState(this);
        break;
      case CharacterState.RIGHT_CHAR_WRONG_PLACE:
        return RightCharacterWrongPositionState(this);
        break;
      default:
        return InitialCharacterState(this);
        break;
    }
  }
}

List<int> getCharactersStatusListInWord(String target, String input) {
  input = input.toLowerCase();

  List<int> rs = List.filled(target.length, CharacterState.WRONG_CHAR);

  List<String> targetChars = target.split('');

  for (int i = 0; i < target.length; i++) {
    if (!target.contains(input[i])) {
      input = input.replaceCharAt(i, CharacterState.PLACE_HOLDER_CHAR);
    }
  }

  final size = target.length;

  for (int i = 0; i < size; i++) {
    if (!targetChars.contains(input[i])) continue;
    targetChars.remove(input[i]);

    if (input[i] == CharacterState.PLACE_HOLDER_CHAR) continue;
    if (target[i] == input[i]) {
      rs[i] = CharacterState.RIGHT_CHAR_RIGHT_PLACE;
      continue;
    }
    rs[i] = CharacterState.RIGHT_CHAR_WRONG_PLACE;
  }

  return rs;
}
