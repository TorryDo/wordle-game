import 'package:hive/hive.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';

abstract class GameState {
  const GameState();
}

class InitialGameState extends GameState {
  const InitialGameState();
}

class EndGameState extends GameState {
  final bool hasWon;

  const EndGameState({
    required this.hasWon,
  });
}

class ExitGameState extends GameState {
  const ExitGameState();
}

// class SaveGameState extends GameState {
//   final String targetWord;
//   final List<CharacterState> gameBoardStateList;
//
//   const SaveGameState({
//     required this.gameBoardStateList,
//     required this.targetWord,
//   });
// }

@Deprecated("unImplemented")
class ResetGameState extends GameState {
  const ResetGameState();
}
