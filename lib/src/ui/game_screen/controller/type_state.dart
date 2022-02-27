import 'package:wordle_game/src/ui/game_screen/controller/character_state.dart';

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
  final List<CharacterState> wordStates;

  const EnterState({required this.wordStates});
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

class WordNotCompletedState extends TypeState{
  const WordNotCompletedState();
}

class WrongWordState extends TypeState{
  const WrongWordState();
}


