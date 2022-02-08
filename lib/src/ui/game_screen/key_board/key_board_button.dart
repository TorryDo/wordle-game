import 'package:flutter/material.dart';
import 'package:wordle_game/src/provider/text_styles.dart';
import 'package:wordle_game/src/res/dimens.dart';

class KeyBoardButton extends StatefulWidget {
  final double? width;
  final double? height;
  final String character;
  final Color? color;
  final Function(int ascii)? onClick;

  const KeyBoardButton(
      {Key? key,
      this.character = '',
      this.width,
      this.height,
      this.color,
      this.onClick})
      : super(key: key);

  @override
  _KeyBoardButtonState createState() => _KeyBoardButtonState();
}

class _KeyBoardButtonState extends State<KeyBoardButton> {
  @override
  Widget build(BuildContext context) {
    return _outer();
  }

  Widget _outer() {
    var borderRadius = Dimens.BORDER_RADIUS_XS;
    if(widget.width != null){
      borderRadius = widget.width! / 6;
    }

    return GestureDetector(
      onTap: _onClick,
      child: Container(
        width: widget.width,
        height: widget.height,
        child: _inner(),
        decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
      ),
    );
  }

  Widget _inner() {
    return Center(child: Text(widget.character, style: TextStyles.SIZE_S));
  }

  void _onClick() {
    if(widget.onClick == null) return;
    widget.onClick!(widget.character.codeUnitAt(0));
  }
}
