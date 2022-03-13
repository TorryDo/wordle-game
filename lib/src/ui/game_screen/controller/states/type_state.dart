abstract class TypeState {
  const TypeState();
}

class InitialState extends TypeState {
  const InitialState();
}

class TypingState extends TypeState {
  final int ascii;

  const TypingState({required this.ascii});
}

class EnterState extends TypeState {
  const EnterState();
}

class DeleteState extends TypeState {
  const DeleteState();
}

class TailOfWordState extends TypeState {
  const TailOfWordState();
}

class HeadOfWordState extends TypeState {
  const HeadOfWordState();
}

class WordNotCompletedState extends TypeState {
  const WordNotCompletedState();
}

class WrongWordState extends TypeState {
  const WrongWordState();
}
