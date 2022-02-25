import 'package:flutter/material.dart';
import 'package:wordle_game/src/provider/text_styles.dart';
import 'package:wordle_game/src/ui/game_screen/character_state.dart';
import 'package:wordle_game/src/ui/game_screen/word_list_controller.dart';

import '../../../utils/res/dimens.dart';

class KeyBoardButton extends StatefulWidget {
  final double? width;
  final double? height;
  final String keyboardCharacter;
  final Color? color;
  final Function(int ascii)? onClick;
  final CharacterState characterState;

  const KeyBoardButton(
      {Key? key,
      this.keyboardCharacter = '',
      this.width,
      this.height,
      this.color,
      this.onClick,
      this.characterState = const InitialCharacterState(WordListController.emptyChar)})
      : super(key: key);

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
            color: _backgroundBox(),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))
        ),
        child: _inner(),
      ),
    );
  }

  Widget _inner() {
    return Center(child: Text(widget.keyboardCharacter, style: TextStyles.SIZE_S));
  }

  /// logic --------------------------------------------------------------------

  void _onClick() {
    if (widget.onClick == null) return;
    widget.onClick!(widget.keyboardCharacter.codeUnitAt(0));
  }

  Color? _backgroundBox() {
    return widget.color;
  }
}
