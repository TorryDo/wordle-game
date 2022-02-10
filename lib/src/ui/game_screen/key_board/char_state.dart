abstract class CharacterState{
  const CharacterState();
}

class InitialCharacterState extends CharacterState{
  const InitialCharacterState();
}

class RightCharacterRightPlaceState extends CharacterState{
  const RightCharacterRightPlaceState();
}

class RightCharacterWrongPlaceState extends CharacterState{
  const RightCharacterWrongPlaceState();
}

class WrongCharacterState extends CharacterState{
  const WrongCharacterState();
}