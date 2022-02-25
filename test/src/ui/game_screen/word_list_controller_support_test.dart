import 'package:flutter_test/flutter_test.dart';
import 'package:wordle_game/src/ui/game_screen/word_board/word_list_controller_support.dart';

void main(){
  _testFun();
}

void _testFun(){
  String target = "arena";
  String input = "ALIAS";

  final controllerSupport = WordListControllerSupport();

  final expectedThis = controllerSupport.getCharactersStatusInWord(target, input);

  test("description", (){
    expect(expectedThis, [2, 0, 0, 1, 0]);
  });

}