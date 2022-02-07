import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wordle_game/src/ui/components/word_board/char_box.dart';

class WordGridView extends StatefulWidget {
  const WordGridView(
      {Key? key,
      required this.wordLength,
      required this.width,
      this.backgroundColor = Colors.transparent})
      : super(key: key);

  final int wordLength;
  final double width;
  final Color backgroundColor;

  @override
  _WordGridViewState createState() => _WordGridViewState();
}

class _WordGridViewState extends State<WordGridView> {

  @override
  void initState() {
    super.initState();

    var itemNumber = (widget.wordLength + 1) * widget.wordLength;
    charSet = List.filled(itemNumber, '-');

  }

  @override
  Widget build(BuildContext context) {

    return wordGridView(widget.wordLength, widget.width);
  }

  late List<String> charSet;

  Widget wordGridView(int charNumber, double width) {
    double charBoxSize = width / (charNumber + 1);
    double gridViewHeight = charBoxSize * (charNumber + 3);

    int columnNumber = charNumber + 1;
    int itemNumber = columnNumber * charNumber;

    double crossAxisSpacing = 0.0;
    double mainAxisSpacing = crossAxisSpacing;

    return Container(
      width: double.infinity,
      height: gridViewHeight,
      color: widget.backgroundColor,
      child: GridView.builder(
          itemCount: itemNumber,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: charNumber,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing),
          itemBuilder: (context, index) => CharBox(
                index: index,
                boxSize: charBoxSize,
                character: charSet[index],
                onClick: (index) {
                  _onCharBoxClick(index);
                },
              )),
    );
  }

  void _onCharBoxClick(int index) {
    log("word_grid_view, old value = ${charSet[index]}");

    setState(() {
      charSet[index] = 'B';
    });

    log("word_grid_view, new value = ${charSet[index]}");
  }
}
