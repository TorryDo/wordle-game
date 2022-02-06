import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wordle_game/src/ui/components/word_box/char_box.dart';

class WordGridView extends StatefulWidget {
  const WordGridView(
      {Key? key,
      required this.charNumber,
      required this.width,
      this.backgroundColor = Colors.transparent})
      : super(key: key);

  final int charNumber;
  final double width;
  final Color backgroundColor;

  @override
  _WordGridViewState createState() => _WordGridViewState();
}

class _WordGridViewState extends State<WordGridView> {
  @override
  Widget build(BuildContext context) {

    var itemNumber = (widget.charNumber + 1) * widget.charNumber;
    wordSet = List.filled(itemNumber, 'X');

    return wordGridView(widget.charNumber,widget.width);
  }

  late List<String> wordSet;

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
                character: wordSet[index],
                onClick: (index) {
                  onCharBoxClick(index);
                },
              )),
    );
  }

  void onCharBoxClick(int index) {

    log("wordset key = $index , value = ${wordSet[index]}");

    setState(() {
      var tempList = wordSet;
      tempList[index] = 'O';
      wordSet = tempList;
    });

    log("wordset key = $index , value = ${wordSet[index]}");
  }
}
