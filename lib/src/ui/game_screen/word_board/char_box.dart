import 'dart:developer';

import 'package:flutter/material.dart';

class CharBox extends StatefulWidget {

  final int index;

  final double boxSize;
  final String character;
  final double borderSize;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final double fontSize;

  final Function(int index)? onClick;

  const CharBox({
    Key? key,
    required this.boxSize,
    required this.character,
    this.index = -1,
    this.borderSize = 2.5,
    this.backgroundColor = Colors.transparent,
    this.borderColor = Colors.deepOrangeAccent,
    this.borderRadius = 7.0,
    this.fontSize = 40.0,
    this.onClick
    }) : super(key: key);

  @override
  _CharBoxState createState() => _CharBoxState();
}

class _CharBoxState extends State<CharBox> {

  @override
  Widget build(BuildContext context) {
    return _charBox(widget.boxSize);
  }

  Widget _charBox(
    double boxSize,
  ) {
    var fontWeight = FontWeight.w400;

    return Center(
      child: GestureDetector(
        child: SizedBox(
          width: boxSize,
          height: boxSize,
          child: Container(
            decoration: BoxDecoration(
                color: widget.backgroundColor,
                border: Border.all(
                    color: widget.borderColor, width: widget.borderSize),
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
        onTap: () => _onClick(),
      ),
    );
  }

  void _onClick() {
    if (widget.onClick != null) {
      widget.onClick!(widget.index);
    }

    log("widget.character = ${widget.character}");
  }
}