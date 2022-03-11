import 'package:hive/hive.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';

part 'save_game_model.g.dart';

@HiveType(typeId: 0)
class SaveGameModel extends HiveObject {

  @HiveField(0)
  late String targetWord;

  @HiveField(1)
  late List<String> gameBoardStateList;

}