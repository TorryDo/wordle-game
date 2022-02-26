import 'package:flutter_test/flutter_test.dart';
import 'package:wordle_game/src/ui/game_screen/controller/word_controller.dart';

void main(){
  checkFunc();
}

void checkFunc(){
  final wordController = WordController();

  test("check func", (){
    expect(wordController.isMatchedTargetWord("arena"), true);
    expect(wordController.isMatchedTargetWord("print"), false);
  });
}