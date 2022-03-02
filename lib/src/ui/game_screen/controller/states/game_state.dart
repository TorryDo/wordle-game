abstract class GameState {
  const GameState();
}

class InitialGameState extends GameState {
  const InitialGameState();
}

class ResumeGameState extends GameState {
  const ResumeGameState();
}

class PauseGameState extends GameState {
  const PauseGameState();
}

class EndGameState extends GameState {
  final bool hasWon;

  const EndGameState({required this.hasWon});
}

class ExitGameState extends GameState {
  const ExitGameState();
}

class ResetGameState extends GameState {
  const ResetGameState();
}