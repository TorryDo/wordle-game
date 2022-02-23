import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wordle_game/src/ui/game_screen/character_state.dart';
import 'package:wordle_game/src/ui/game_screen/word_list_controller.dart';
import 'package:wordle_game/src/utils/res/tint.dart';

class CharBox extends StatefulWidget {
  final int index;

  final double boxSize;
  final String character;
  final double borderSize;
  final Color borderColor;
  final double borderRadius;
  final double fontSize;
  final CharacterState characterState;

  final Function(int index)? onClick;

  const CharBox(
      {Key? key,
      required this.boxSize,
      required this.character,
      this.index = -1,
      this.borderSize = 2.0,
      this.borderColor = Tint.main_color,
      this.borderRadius = 7.0,
      this.fontSize = 40.0,
      this.characterState = const InitialCharacterState(WordListController.defaultChar),
      this.onClick})
      : super(key: key);

  @override
  _CharBoxState createState() => _CharBoxState();
}

class _CharBoxState extends State<CharBox> {
  @override
  Widget build(BuildContext context) => _charBox(widget.boxSize);

  Widget _charBox(
    double boxSize,
  ) {
    var fontWeight = FontWeight.w400;

    return Center(
      child: GestureDetector(
        onTap: () => _onClick(),
        child: SizedBox(
          width: boxSize.abs(),
          height: boxSize.abs(),
          child: Container(
            decoration: BoxDecoration(
                color: _getBackgroundColor(),
                border: Border.all(
                    color: widget.borderColor, width: _getBoxBorderSize()),
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.borderRadius))),
            child: Center(
              child: Text(
                widget.character,
                style: TextStyle(
                    fontSize: widget.fontSize, fontWeight: fontWeight),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// logic --------------------------------------------------------------------

  void _onClick() {
    if (widget.onClick != null) {
      widget.onClick!(widget.index);
    }
    log("widget.character = ${widget.character}");
  }

  double _getBoxBorderSize() {
    if (widget.characterState is InitialCharacterState) {
      return widget.borderSize;
    }
    return 0.0;
  }

  Color _getBackgroundColor() {
    if (widget.characterState is RightCharacterRightPlaceState) {
      return Tint.GREEN_CHAR;
    } else if (widget.characterState is RightCharacterWrongPlaceState) {
      return Tint.YELLOW_CHAR;
    }

    return Colors.transparent;
  }
}
