abstract class CharacterState {
  final String char;

  const CharacterState(this.char);
}

class InitialCharacterState extends CharacterState {
  const InitialCharacterState(String char) : super(char);
}

class RightCharacterRightPlaceState extends CharacterState {
  const RightCharacterRightPlaceState(String char) : super(char);
}

class RightCharacterWrongPlaceState extends CharacterState {
  const RightCharacterWrongPlaceState(String char) : super(char);
}

class WrongCharacterState extends CharacterState {
  const WrongCharacterState(String char) : super(char);
}
