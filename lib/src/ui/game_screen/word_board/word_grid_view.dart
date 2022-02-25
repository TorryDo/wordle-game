import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/ui/game_screen/word_board/char_box.dart';
import 'package:wordle_game/src/ui/game_screen/word_list_controller.dart';
import 'package:wordle_game/src/utils/constants.dart';
import 'package:wordle_game/src/utils/logger.dart';

class WordGridView extends StatefulWidget {

  final int wordLength;
  final double width;
  final Color backgroundColor;

  const WordGridView(
      {Key? key,
      required this.wordLength,
      required this.width,
      this.backgroundColor = Colors.transparent
      }) : super(key: key);

  @override
  _WordGridViewState createState() => _WordGridViewState();
}

class _WordGridViewState extends State<WordGridView> {

  late WordListController _wordListController;

  final _logger = Logger()
      .setDebugEnabled(Constants.IS_DEBUG_ANABLED)
      .setTag((WordGridView).toString());

  @override
  void initState() {
    super.initState();

    var itemNumber = (widget.wordLength + 1) * widget.wordLength;

    _wordListController = Get.find<WordListController>();

    _wordListController.init(itemNumber, widget.wordLength);
  }

  @override
  Widget build(BuildContext context) => _wordGridView(widget.wordLength, widget.width);


  Widget _wordGridView(int charNumber, double width) {
    double charBoxSize = width / (charNumber + 1);
    double gridViewHeight = charBoxSize * (charNumber + 3);

    double crossAxisSpacing = 0.0;
    double mainAxisSpacing = crossAxisSpacing;

    return Container(
      width: double.infinity,
      height: gridViewHeight.abs(),
      color: widget.backgroundColor,
      child: Obx(
        () => GridView.builder(
            itemCount: _wordListController.gameBoardStateList.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: charNumber,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: mainAxisSpacing),
            itemBuilder: (context, index) => CharBox(
                  index: index,
                  characterState: _wordListController.gameBoardStateList[index],
                  boxSize: charBoxSize,
                  onClick: (index) {
                    _onCharBoxClick(index);
                    log(_wordListController.gameBoardStateList.toString());
                    // log(_wordListController.getTargetWord);
                  },
                )),
      ),
    );
  }

  // logic ---------------------------------------------------------------------

  void _onCharBoxClick(int index) {
    _logger.d("click on grid view at position = $index");
  }
}
