abstract class WordState{
  const WordState();
}

class InitialWordState extends WordState{
  const InitialWordState();
}

class WrongWordState extends WordState{

  final Function(String wrongWord)? callback;

  const WrongWordState(this.callback);
}

class RightWordState extends WordState{

  final Function()? callback;

  const RightWordState({this.callback});
}