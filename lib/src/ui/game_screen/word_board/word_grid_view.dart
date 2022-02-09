import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/ui/game_screen/word_board/char_box.dart';
import 'package:wordle_game/src/ui/game_screen/word_list_controller.dart';
import 'package:wordle_game/src/utils/constants.dart';
import 'package:wordle_game/src/utils/logger.dart';

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
  // late List<String> charSet;

  late WordListController _wordListController;

  final _logger = Logger()
      .setDebugEnabled(Constants.IS_DEBUG_ANABLED)
      .setTag((WordGridView).toString());

  @override
  void initState() {
    super.initState();

    var itemNumber = (widget.wordLength + 1) * widget.wordLength;

    _wordListController = Get.find<WordListController>();

    _wordListController.initWordList(itemNumber, widget.wordLength);
  }

  @override
  Widget build(BuildContext context) {
    return _wordGridView(widget.wordLength, widget.width);
  }

  Widget _wordGridView(int charNumber, double width) {
    double charBoxSize = width / (charNumber + 1);
    double gridViewHeight = charBoxSize * (charNumber + 3);

    double crossAxisSpacing = 0.0;
    double mainAxisSpacing = crossAxisSpacing;

    return Container(
      width: double.infinity,
      height: gridViewHeight,
      color: widget.backgroundColor,
      child: Obx(
        () => GridView.builder(
            itemCount: _wordListController.charList.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: charNumber,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: mainAxisSpacing),
            itemBuilder: (context, index) => CharBox(
                  index: index,
                  boxSize: charBoxSize,
                  character: _wordListController.charList[index],
                  onClick: (index) {
                    _onCharBoxClick(index);
                  },
                )),
      ),
    );
  }

  void _onCharBoxClick(int index) {

    _logger.d("click on grid view at position = $index");

  }
}
