import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/common/widget/svg_icon.dart';
import 'package:wordle_game/src/ui/game_screen/controller/game_screen_controller.dart';
import 'package:wordle_game/src/ui/game_screen/key_board/key_board_button.dart';
import 'package:wordle_game/src/utils/get_width_height.dart';

import '../../../utils/res/dimens.dart';

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
  late double _buttonWidth;
  late double _buttonHeight;

  late GameScreenController _gameScreenController;

  @override
  void initState() {
    _gameScreenController = Get.find<GameScreenController>();
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
                characterState: _gameScreenController.keyboardCharacters[i],
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
                characterState: _gameScreenController.keyboardCharacters[i],
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
                characterState: _gameScreenController.keyboardCharacters[i],
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
}
