import 'package:hive/hive.dart';
import 'package:wordle_game/src/utils/extension.dart';

import '../../../../utils/constants.dart';

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

class CharStateAlias {
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

}

extension CharStateListExt on List<CharacterState> {
  List<String> toStringList() {
    List<String> result = [];
    for (var item in this) {
      result.add(item.char);
    }
    return result;
  }

  int get firstEmptyCharPosition {
    return indexWhere((c) => c.char == Const.SPACE_CHAR);
  }

  int get lastCharPosition {
    return lastIndexWhere((c) => c.char != Const.SPACE_CHAR);
  }

  int get initialCharStateHasCharPosition{
    int rs = lastCharPosition;
    if (rs < 0) return -1;
    if (this[rs] is InitialCharacterState) {
      return rs;
    }

    return -1;
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
