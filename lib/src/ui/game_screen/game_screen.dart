import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/common/class/my_toast.dart';
import 'package:wordle_game/src/common/interface/ui_notifier.dart';
import 'package:wordle_game/src/common/widget/ads/banner_ads.dart';
import 'package:wordle_game/src/ui/game_screen/controller/game_screen_controller.dart';
import 'package:wordle_game/src/ui/game_screen/key_board/key_board.dart';
import 'package:wordle_game/src/ui/game_screen/top_bar/top_bar.dart';
import 'package:wordle_game/src/ui/game_screen/word_board/word_grid_view.dart';
import 'package:wordle_game/src/utils/get_width_height.dart';

import '../../utils/constants.dart';
import '../../utils/logger.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with UINotifier, WidgetsBindingObserver {
  GameScreenController? _gameScreenController;

  final _logger = Logger()
      .setDebugEnabled(Constants.IS_DEBUG_ANABLED)
      .setTag((GameScreen).toString());

  // lifecycle -----------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _gameScreenController ??= Get.find<GameScreenController>();
    _gameScreenController?.onInitState();
    _gameScreenController?.registerUINotifier(this);
  }

  @override
  Widget build(BuildContext context) {
    _gameScreenController?.onBuildState();
    return _safeAreaPage();
  }

  @override
  void dispose() {
    _gameScreenController?.onDispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _gameScreenController?.lastLifecycleState.value = state;
  }

  // widgets -------------------------------------------------------------------

  Widget _safeAreaPage() => SafeArea(child: Scaffold(body: _page()));

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
              child: _topBar(),
            ),
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

  Widget _topBar() {
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
        child: WordGridView(
          wordLength: _gameScreenController?.wordLength.value ?? 5,
          width: wordGridViewWidth,
        ),
      ),
    );
  }

  Widget _keyBoard() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: KeyBoard(
          buttonColor: Colors.white10,
          onClick: (ascii) => _clickedFromKeyboard(ascii),
        ));
  }

  Widget _ads() {
    return const BannerAds();
  }

  // named function ------------------------------------------------------------

  void _clickedFromKeyboard(int ascii) {
    _gameScreenController?.setupWordBoard?.type(ascii);
    // _logger.d("type: ${String.fromCharCode(ascii)}");
  }

  // ui notifier ---------------------------------------------------------------
  @override
  void showSnackBar({String? label, String? content}) {
    final snackBar = SnackBar(
      content: Text(content ?? 'Yay! A SnackBar!'),
      action: SnackBarAction(
        label: label ?? 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void showToast({String? message}) {
    MyToast.makeText(message ?? "null");
  }
}
