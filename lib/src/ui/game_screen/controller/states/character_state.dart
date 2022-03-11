import 'package:hive/hive.dart';
import 'package:wordle_game/src/ui/game_screen/controller/setup_wordboard.dart';
import 'package:wordle_game/src/utils/extension.dart';

part 'character_state.g.dart';


abstract class CharacterState {

  @HiveField(0)
  final String char;

  const CharacterState(this.char);
}

@HiveType(typeId: 2)
class InitialCharacterState extends CharacterState {
  const InitialCharacterState(String char) : super(char);
}

@HiveType(typeId: 3)
class RightCharacterRightPositionState extends CharacterState {
  const RightCharacterRightPositionState(String char) : super(char);
}

@HiveType(typeId: 4)
class RightCharacterWrongPositionState extends CharacterState {
  const RightCharacterWrongPositionState(String char) : super(char);
}

@HiveType(typeId: 5)
class WrongCharacterState extends CharacterState {
  const WrongCharacterState(String char) : super(char);
}

class CharStateAlias{
  static const STATE_NULL = -1;
  static const INITIAL = 0;
  static const WRONG_CHAR = 1;
  static const RIGHT_CHAR_WRONG_POSITION = 2;
  static const RIGHT_CHAR_RIGHT_POSITION = 3;

  static const PLACE_HOLDER_CHAR = '-';
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
        stringList.lastIndexWhere((c) => c != SetupWordBoard.SPACE_CHAR);

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
      lastCharPosition = stringList.lastIndexWhere((c) => c != SetupWordBoard.SPACE_CHAR);
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
      case CharStateAlias.WRONG_CHAR:
        return WrongCharacterState(this);
        break;
      case CharStateAlias.RIGHT_CHAR_RIGHT_POSITION:
        return RightCharacterRightPositionState(this);
        break;
      case CharStateAlias.RIGHT_CHAR_WRONG_POSITION:
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

  List<int> rs = List.filled(target.length, CharStateAlias.WRONG_CHAR);

  List<String> targetChars = target.split('');

  for (int i = 0; i < target.length; i++) {
    if (!target.contains(input[i])) {
      input = input.replaceCharAt(i, CharStateAlias.PLACE_HOLDER_CHAR);
    }
  }

  final size = target.length;

  for (int i = 0; i < size; i++) {
    if (!targetChars.contains(input[i])) continue;
    targetChars.remove(input[i]);

    if (input[i] == CharStateAlias.PLACE_HOLDER_CHAR) continue;
    if (target[i] == input[i]) {
      rs[i] = CharStateAlias.RIGHT_CHAR_RIGHT_POSITION;
      continue;
    }
    rs[i] = CharStateAlias.RIGHT_CHAR_WRONG_POSITION;
  }

  return rs;
}
