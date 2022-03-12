import 'package:flutter_test/flutter_test.dart';
import 'package:wordle_game/src/ui/game_screen/controller/setup_wordboard.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';

void main() {
  _textExt();
}

var _target = "hello";
var _stringList1 = [
  'a',
  'b',
  'c',
  'e',
  SetupWordBoard.SPACE_CHAR,
  SetupWordBoard.SPACE_CHAR,
  SetupWordBoard.SPACE_CHAR,
  SetupWordBoard.SPACE_CHAR,
  SetupWordBoard.SPACE_CHAR,
  SetupWordBoard.SPACE_CHAR
];
var _stringList2 = ['a', 'b', 'c', 'l', 'e', 'h'];
var _stringList3 = ['a', 'b', 'c', 'l', 'e', 'h', 'a', 'b', 'c', 'l', 'e', 'h'];

var _stringList1Result = [
  const InitialCharacterState('a'),
  const InitialCharacterState('b'),
  const InitialCharacterState('c'),
  const InitialCharacterState('e'),
  const InitialCharacterState(SetupWordBoard.SPACE_CHAR),
  const InitialCharacterState(SetupWordBoard.SPACE_CHAR),
  const InitialCharacterState(SetupWordBoard.SPACE_CHAR),
  const InitialCharacterState(SetupWordBoard.SPACE_CHAR),
  const InitialCharacterState(SetupWordBoard.SPACE_CHAR),
  const InitialCharacterState(SetupWordBoard.SPACE_CHAR),
];

var _stringList2Result = [
  const WrongCharacterState('a'),
  const WrongCharacterState('b'),
  const WrongCharacterState('c'),
  const RightCharacterRightPositionState('l'),
  const RightCharacterWrongPositionState('c'),
  const InitialCharacterState('l'),
];

void _textExt() {
  // var actual1 = _stringList1.toStateListFrom(target: _target);
  var matcher1 = _stringList1Result;

  // for(var item1 in actual1){
  //   print(item1.char);
  // }
  // for(var item in matcher1){
  //   print(item.char);
  // }

  // var actual2 = _stringList2.toStateListFrom(target: _target);
  // var matcher2 = _stringList2Result;

  test('test extension', () {
    // expect(actual1, matcher1);
    // expect(listEquals(actual2, matcher2), true);
  });
}
