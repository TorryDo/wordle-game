import 'package:flutter_test/flutter_test.dart';
import 'package:wordle_game/src/ui/game_screen/controller/word_list_controller.dart';
import 'package:wordle_game/src/utils/extension.dart';

main() {
  _testStartAndEndLine();
}

void _testStartAndEndLine({int itemNumber = 30}) {

  var controller = WordListController();
  controller.setupTheGame(itemNumber, 5);

  test("find position without enter", () {
    controller.resetTheGame();

    ((i) => controller.type(65)).repeat(5);

    print(controller.gameBoardStateList);

    expect(controller.testFindLastChar, 4);
    expect(controller.testFindLastEmptyChar, 5);

  });


  test("get complete word", (){
    controller.resetTheGame();

    ((i) => controller.type(66)).repeat(5);

    print(controller.gameBoardStateList);

    expect(controller.testGetCompleteWord, 'BBBBB');
  });

}
