import 'package:flutter/material.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';

import '../../../common/provider/text_styles.dart';
import '../../../utils/res/dimens.dart';
import '../../../utils/res/tint.dart';

class KeyBoardButton extends StatefulWidget {
  final CharacterState characterState;
  final double? width;
  final double? height;
  final Color? color;
  final Function(int ascii)? onClick;

  const KeyBoardButton({
    Key? key,
    required this.characterState,
    this.width,
    this.height,
    this.color,
    this.onClick,
  }) : super(key: key);

  @override
  _KeyBoardButtonState createState() => _KeyBoardButtonState();
}

class _KeyBoardButtonState extends State<KeyBoardButton> {
  @override
  Widget build(BuildContext context) => _outer();

  Widget _outer() {
    var borderRadius = Dimens.BORDER_RADIUS_XS;
    if (widget.width != null) {
      borderRadius = widget.width! / 6;
    }

    return GestureDetector(
      onTap: _onClick,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        child: _inner(),
      ),
    );
  }

  Widget _inner() {
    return Center(
        child: Text(widget.characterState.char,
            style: TextStyle(
                color: _getTextColor(),
                fontSize: Dimens.text_size_normal,
                fontWeight: TextStyles.font_weight_medium)));
  }

  /// logic --------------------------------------------------------------------

  void _onClick() {
    if (widget.onClick == null) return;
    widget.onClick!(widget.characterState.char.codeUnitAt(0));
  }

  Color? _getBackgroundColor() {
    if (widget.characterState is RightCharacterRightPositionState) {
      return Tint.GREEN_CHAR;
    } else if (widget.characterState is RightCharacterWrongPositionState) {
      return Tint.YELLOW_CHAR;
    } else if (widget.characterState is WrongCharacterState) {
      return Colors.transparent;
    }
    return widget.color;
  }

  Color _getTextColor() {
    if (widget.characterState is RightCharacterWrongPositionState) {
      return Tint.TEXT_COLOR;
    }

    return Tint.TEXT_COLOR_LIGHT;
  }
}
