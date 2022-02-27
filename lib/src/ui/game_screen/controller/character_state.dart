abstract class CharacterState {
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

extension ConvertToCharacterStateList on List<String> {
  List<CharacterState> toCharacterStateList() {
    final mList = map((e) => InitialCharacterState(e));
    return mList.toList();
  }
}
