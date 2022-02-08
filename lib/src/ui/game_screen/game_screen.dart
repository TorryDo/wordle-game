import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/ui/game_screen/action_bar/action_bar.dart';
import 'package:wordle_game/src/ui/game_screen/ads/ads.dart';
import 'package:wordle_game/src/ui/game_screen/key_board/key_board.dart';
import 'package:wordle_game/src/ui/game_screen/word_board/word_grid_view.dart';
import 'package:wordle_game/src/ui/game_screen/word_list_controller.dart';
import 'package:wordle_game/src/utils/get_width_height.dart';
import 'package:wordle_game/src/utils/logger.dart';

import '../../utils/constants.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _logger = Logger()
      .setDebugEnabled(Constants.IS_DEBUG_ANABLED)
      .setTag((GameScreen).toString());

  WordListController? controller;

  @override
  void initState() {
    super.initState();
    Get.put(WordListController());
  }

  @override
  Widget build(BuildContext context) {
    return _page();
  }

  Widget _page() {
    var actionBarHeight = 70.0;

    var gridFlex = 5;
    var keyBoardFlex = 2;

    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black87,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: double.infinity,
                height: actionBarHeight,
                child: _actionBar()),
            Flexible(flex: gridFlex, fit: FlexFit.tight, child: _gridView()),
            Flexible(
                flex: keyBoardFlex, fit: FlexFit.tight, child: _keyBoard()),
            SizedBox(
                width: double.infinity, height: actionBarHeight, child: _ads()),
          ],
        ),
      ),
    );
  }

  Widget _actionBar() {
    return const ActionBar();
  }

  Widget _gridView() {
    var screenWidth = getWidth(context);
    var marginHorizontal = 40.0;
    var wordGridViewWidth = screenWidth - marginHorizontal * 2;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
          child: WordGridView(wordLength: 5, width: wordGridViewWidth)),
    );
  }

  Widget _keyBoard() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: KeyBoard(
          buttonColor: Colors.white10,
          onClick: (ascii) => _onClickFromCustomKeyboard(ascii),
        ));
  }

  Widget _ads() {
    return const Ads();
  }

  /* clicked on keyboard */
  void _onClickFromCustomKeyboard(int ascii) {
    _logger.d( "from keyboard - " + String.fromCharCode(ascii));

    controller ??= Get.find<WordListController>();

    controller?.type(ascii);

  }
}
