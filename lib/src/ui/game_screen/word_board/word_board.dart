import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/ui/game_screen/controller/game_screen_controller.dart';
import 'package:wordle_game/src/ui/game_screen/controller/states/character_state.dart';
import 'package:wordle_game/src/ui/game_screen/word_board/char_box.dart';
import 'package:wordle_game/src/utils/constants.dart';
import 'package:wordle_game/src/utils/logger.dart';

class WordBoard extends StatefulWidget {
  final int wordLength;
  final double width;
  final Color backgroundColor;

  const WordBoard(
      {Key? key,
      required this.wordLength,
      required this.width,
      this.backgroundColor = Colors.transparent})
      : super(key: key);

  @override
  _WordBoardState createState() => _WordBoardState();
}

class _WordBoardState extends State<WordBoard> with Logger {
  GameScreenController? _gameScreenController;

  // lifecycle -----------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _gameScreenController = Get.find<GameScreenController>();
  }

  @override
  Widget build(BuildContext context) {
    return _wordGridView(widget.wordLength, widget.width);
  }

  @override
  void dispose() {
    _gameScreenController = null;
    super.dispose();
  }

  // widgets -------------------------------------------------------------------

  Widget _wordGridView(int charNumber, double width) {
    double crossAxisSpacing = 0.0;
    double mainAxisSpacing = crossAxisSpacing;

    return Container(
      width: _wordBoardWidth,
      height: _wordBoardHeight,
      color: widget.backgroundColor,
      child: Obx(
        () => GridView.builder(
          itemCount: _gameBoardItemNumber,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: charNumber,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
          ),
          itemBuilder: (context, index) => _cell(context, index),
        ),
      ),
    );
  }

  Widget _cell(BuildContext context, int index) {
    return CharBox(
      index: index,
      characterState: _itemState(index),
      boxSize: charBoxSize,
      onClick: (index) {
        _onCharBoxClick(index);
      },
    );
  }

  // logic ---------------------------------------------------------------------

  void _onCharBoxClick(int index) {
    d("click on grid view at position = $index");
  }

  // shorten -------------------------------------------------------------------

  double? _charBoxSize;

  double get charBoxSize {
    _charBoxSize ??= widget.width / (widget.wordLength + 1);
    return _charBoxSize!;
  }

  double get _wordBoardHeight {
    return charBoxSize * (widget.wordLength + 3);
  }

  double get _wordBoardWidth {
    return double.infinity;
  }

  int get _gameBoardItemNumber {
    return _gameScreenController?.gameBoardStateList.length ?? 0;
  }

  CharacterState _itemState(int index) {
    return _gameScreenController?.gameBoardStateList[index] ??
        const InitialCharacterState(Const.SPACE_CHAR);
  }
}
