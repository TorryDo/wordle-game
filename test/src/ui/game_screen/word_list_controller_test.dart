import 'package:flutter_test/flutter_test.dart';
import 'package:wordle_game/src/ui/game_screen/word_list_controller.dart';
import 'package:wordle_game/src/utils/extension.dart';

main() {
  _testStartAndEndLine();
}

void _testStartAndEndLine({int itemNumber = 30}) {

  var controller = WordListController();
  controller.initWordList(itemNumber);

  void expectStartOfLine(bool expected) {
    expect(controller.isStartOfLine(itemNumber, controller.getCurrentPosition),
        expected);
  }

  void expectEndOfLine(bool expected) {
    expect(controller.isEndOfLine(itemNumber, controller.getCurrentPosition),
        expected);
  }

  test("at position 0", () {
    controller.reset();
    print(controller.charList);

    expectEndOfLine(false);
    expectStartOfLine(true);
  });

  test("at position 5", () {
    controller.reset();

    (() => controller.type(65)).repeat(5);

    print(controller.charList);

    expectStartOfLine(false);
    expectEndOfLine(true);
  });
}
