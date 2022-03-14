import 'package:hive/hive.dart';

part 'game_state.g.dart';

abstract class GameState {
  const GameState();
}

@HiveType(typeId: 6)
class PlayingGameState extends GameState {
  const PlayingGameState();
}

@HiveType(typeId: 7)
class EndGameState extends GameState {
  @HiveField(0)
  final bool hasWon;

  const EndGameState({
    required this.hasWon,
  });
}

class ExitGameState extends GameState {
  const ExitGameState();
}
