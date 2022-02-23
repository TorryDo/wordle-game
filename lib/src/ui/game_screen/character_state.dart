abstract class CharacterState{
  const CharacterState();
}

class InitialCharacterState extends CharacterState{

  final String char;

  const InitialCharacterState(this.char);
}

class RightCharacterRightPlaceState extends CharacterState{

  final String char;

  const RightCharacterRightPlaceState(this.char);
}

class RightCharacterWrongPlaceState extends CharacterState{

  final String char;

  const RightCharacterWrongPlaceState(this.char);
}

class WrongCharacterState extends CharacterState{

  final String char;

  const WrongCharacterState(this.char);
}