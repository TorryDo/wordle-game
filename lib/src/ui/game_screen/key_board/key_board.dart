import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/common/widget/svg_icon.dart';
import 'package:wordle_game/src/ui/game_screen/controller/game_screen_controller.dart';
import 'package:wordle_game/src/ui/game_screen/controller/game_screen_controller.dart';
import 'package:wordle_game/src/ui/game_screen/controller/word_list_controller.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/game_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/type_state.dart';
import 'package:wordle_game/src/ui/game_screen/key_board/key_board_button.dart';
import 'package:wordle_game/src/utils/get_width_height.dart';

import '../../../utils/constants.dart';
import '../../../utils/logger.dart';
import '../../../utils/res/dimens.dart';
import '../controller/word_list_controller.dart';

class KeyBoard extends StatefulWidget {
  final Color backgroundColor;
  final Color buttonColor;
  final Color? buttonBorderColor;
  final double? width;
  final double? height;
  final Function(int ascii)? onClick;

  const KeyBoard(
      {Key? key,
      this.backgroundColor = Colors.transparent,
      this.buttonColor = Colors.transparent,
      this.width,
      this.height,
      this.buttonBorderColor,
      this.onClick})
      : super(key: key);

  @override
  _KeyBoardState createState() => _KeyBoardState();
}

class _KeyBoardState extends State<KeyBoard> {
  final RxList<CharacterState> keyboardCharacters = RxList<CharacterState>([
    'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', // start: 0, end: 10
    'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', // start: 10, end: 19
    'Z', 'X', 'C', 'V', 'B', 'N', 'M' // start: 19, end: 26
  ].toCharacterStateList());

  final logger = Logger()
      .setDebugEnabled(Constants.IS_DEBUG_ANABLED)
      .setTag((KeyBoard).toString());

  late double _buttonWidth;
  late double _buttonHeight;

  late GameScreenController _gameViewModel;

  @override
  void initState() {
    _gameViewModel = Get.find<GameScreenController>();
    _observe();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _buttonWidth = (getWidth(context)) / 12;
    _buttonHeight = _buttonWidth * 1.55;
    return _keyboard();
  }

  Widget _keyboard() {
    var marginHorizontal = 20.0;
    var flex = 1;

    return Container(
      width: double.infinity,
      height: double.infinity,
      // color: widget.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(flex: flex, fit: FlexFit.tight, child: _line1()),
          Flexible(flex: flex, fit: FlexFit.tight, child: _line2()),
          Flexible(flex: flex, fit: FlexFit.tight, child: _line3())
        ],
      ),
    );
  }

  Widget _line1() {
    return Container(
      width: double.infinity,
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < 10; i++)
              KeyBoardButton(
                characterState: keyboardCharacters[i],
                width: _buttonWidth,
                height: _buttonHeight,
                color: widget.buttonColor,
                onClick: widget.onClick,
              )
          ],
        ),
      ),
    );
  }

  Widget _line2() {
    var marginHorizontal = 20.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
      width: double.infinity,
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 10; i < 19; i++)
              KeyBoardButton(
                characterState: keyboardCharacters[i],
                width: _buttonWidth,
                height: _buttonHeight,
                color: widget.buttonColor,
                onClick: widget.onClick,
              )
          ],
        ),
      ),
    );
  }

  Widget _line3() {
    var iconSize = Dimens.ICON_SIZE_L;

    var margin_between_icon_and_text = 0.0; // useless

    return Container(
      width: double.infinity,
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgIcon(
              uri: 'assets/icons/check.svg',
              width: iconSize,
              height: iconSize,
              backgroundColor: widget.buttonColor,
              color: Colors.white,
              onClick: () {
                if (widget.onClick == null) return;
                widget.onClick!(10);
              },
            ),
            SizedBox(height: margin_between_icon_and_text),
            // ------------------------------------------
            for (int i = 19; i < 26; i++)
              KeyBoardButton(
                characterState: keyboardCharacters[i],
                width: _buttonWidth,
                height: _buttonHeight,
                color: widget.buttonColor,
                onClick: widget.onClick,
              ),
            // -------------------------------------------

            SizedBox(height: margin_between_icon_and_text),
            SvgIcon(
                uri: 'assets/icons/back_space.svg',
                width: iconSize,
                height: iconSize,
                backgroundColor: widget.buttonColor,
                color: Colors.white,
                onClick: () {
                  if (widget.onClick == null) return;
                  widget.onClick!(127);
                })
          ],
        ),
      ),
    );
  }

  // private -------------------------------------------------------------------

  void _observe() {
    _gameViewModel.typeState.stream.listen((typeState) {
      if (typeState is EnterState) {
        for (var newCharacterState in typeState.wordStates) {
          final position = findPositionEqualTo(newCharacterState.char);

          if (canCharacterStateBeUpdated(
              keyboardCharacters[position], newCharacterState)) {
            continue;
          }

          keyboardCharacters[position] = newCharacterState;
        }
      }
    });

    _gameViewModel.gameState.stream.listen((gameState) {
      if (gameState is EndGameState) {
        resetKeyboard();
      }
    });
  }

  int findPositionEqualTo(String char) =>
      keyboardCharacters.indexWhere((state) => state.char == char);

  bool canCharacterStateBeUpdated(
      CharacterState oldState, CharacterState newState) {
    if (oldState is RightCharacterRightPositionState) {
      return true;
    }
    if (oldState is RightCharacterWrongPositionState &&
        newState is WrongCharacterState) {
      return true;
    }
    return false;
  }

  void resetKeyboard() {
    for (int i = 0; i < keyboardCharacters.length; i++) {
      final prevChar = keyboardCharacters[i].char;
      keyboardCharacters[i] = InitialCharacterState(prevChar);
    }
  }
}
