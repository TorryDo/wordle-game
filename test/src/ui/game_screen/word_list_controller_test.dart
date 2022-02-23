import 'package:flutter_test/flutter_test.dart';
import 'package:wordle_game/src/ui/game_screen/word_list_controller.dart';
import 'package:wordle_game/src/utils/extension.dart';

main() {
  _testStartAndEndLine();
}

void _testStartAndEndLine({int itemNumber = 30}) {

  var controller = WordListController();
  controller.initWordList(itemNumber, 5);

  test("find position without enter", () {
    controller.resetCharList();

    ((i) => controller.type(65)).repeat(5);

    print(controller.charList);

    expect(controller.testFindLastChar, 4);
    expect(controller.testFindLastEmptyChar, 5);

  });

  // test("find position after enter", () {
  //   controller.reset();
  //
  //   (() => controller.type(65)).repeat(5);
  //   /** I delayed 100ms in wordlist repository, for some reasons, the test didn't passed :(  */
  //   Future.delayed(const Duration(seconds: 1));
  //   controller.type(10);
  //   (() => controller.type(65)).repeat(2);
  //
  //   print(controller.charList);
  //
  //   expect(controller.testFindLastChar, 6);
  //   expect(controller.testFindLastEmptyChar, 7);
  //
  // });

  test("get complete word", (){
    controller.resetCharList();

    ((i) => controller.type(66)).repeat(5);

    print(controller.charList);

    expect(controller.testGetCompleteWord, 'BBBBB');
  });

}
