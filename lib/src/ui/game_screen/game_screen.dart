import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/ui/game_screen/controller/game_state.dart';
import 'package:wordle_game/src/ui/game_screen/controller/word_list_controller.dart';
import 'package:wordle_game/src/ui/game_screen/key_board/key_board.dart';
import 'package:wordle_game/src/ui/game_screen/top_bar/top_bar.dart';
import 'package:wordle_game/src/ui/game_screen/word_board/word_grid_view.dart';
import 'package:wordle_game/src/utils/get_width_height.dart';
import 'package:wordle_game/src/utils/logger.dart';

import '../../common/widget/ads/banner_ads.dart';
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

  WordListController? _wordListController;

  /// lifecycle ----------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    Get.put(WordListController());
    _wordListController ??= Get.find<WordListController>();
    _observe();
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
            Flexible(
                flex: gridFlex, fit: FlexFit.tight, child: _wordGridView()),
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
    return const TopBar();
  }

  Widget _wordGridView() {
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
          onClick: (ascii) => _onClickFromVirtualKeyboard(ascii),
        ));
  }

  Widget _ads() {
    return const BannerAds();
  }

  /// private func -------------------------------------------------------------

  void _observe() {
    // _wordListController?.typeState.stream.listen((event) {
    //   if (event is TypingState) {
    //     _logger.d(event.toString());
    //   } else if (event is TailOfWordState) {
    //     _logger.d(event.toString());
    //   } else if (event is EnterState) {
    //     _logger.d(event.toString());
    //   } else if (event is WordNotCompletedState) {
    //     _logger.d(event.toString());
    //   } else if (event is DeleteState) {
    //     _logger.d(event.toString());
    //   } else if (event is HeadOfWordState) {
    //     _logger.d(event.toString());
    //   }
    // });

    _wordListController?.gameState.stream.listen((gameState) {
      if (gameState is EndGameState) {
        if (gameState.hasWon) {
          Future.delayed(
              const Duration(seconds: 2), _wordListController?.resetTheGame);
        }
      }
    });
  }

  /* clicked on keyboard */
  void _onClickFromVirtualKeyboard(int ascii) {
    // _logger.d("from keyboard - " + String.fromCharCode(ascii));

    _wordListController ??= Get.find<WordListController>();

    _wordListController?.type(ascii);
  }
}
