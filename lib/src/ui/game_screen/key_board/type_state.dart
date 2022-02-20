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
  final String word;
  final Function(bool isExist) isWordExist;

  const EnterState({required this.word, required this.isWordExist});
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

class WordNotCompleteState extends TypeState{
  const WordNotCompleteState();
}

