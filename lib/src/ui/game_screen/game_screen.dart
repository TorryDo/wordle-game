import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/common/class/my_toast.dart';
import 'package:wordle_game/src/common/interface/ui_notifier.dart';
import 'package:wordle_game/src/common/widget/ads/banner_ads.dart';
import 'package:wordle_game/src/ui/game_screen/controller/game_screen_controller.dart';
import 'package:wordle_game/src/ui/game_screen/key_board/key_board.dart';
import 'package:wordle_game/src/ui/game_screen/top_bar/top_bar.dart';
import 'package:wordle_game/src/ui/game_screen/word_board/word_board.dart';
import 'package:wordle_game/src/utils/get_width_height.dart';
import 'package:wordle_game/src/utils/res/tint.dart';

import '../../utils/logger.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with UINotifier, WidgetsBindingObserver, Logger {
  GameScreenController? _controller;

  final Color _backgroundColor = Colors.transparent;

  // lifecycle -----------------------------------------------------------------

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    _controller ??= Get.find<GameScreenController>();
    _controller?.onInitState();
    _controller?.registerUINotifier(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controller?.onBuildState();
    return _outer();
  }

  @override
  void dispose() {
    _controller?.onDisposeState();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _controller?.appLifeCycleState.value = state;
  }

  // widgets -------------------------------------------------------------------

  Widget _outer() {
    return SafeArea(
      child: Scaffold(
        body: Material(
          child: _blur(),
        ),
      ),
    );
  }

  Widget _blur() {
    return Stack(
      children: [
        Image.asset(
          "assets/images/nature.jpg",
          alignment: Alignment.center,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        ClipRRect(
          // Clip it cleanly.
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              color: Colors.black.withOpacity(0.55),
              alignment: Alignment.center,
            ),
          ),
        ),
        _page()
      ],
    );
  }

  Widget _page() {
    var actionBarHeight = 70.0;

    var gridFlex = 5;
    var keyBoardFlex = 2;

    return Container(
      width: double.infinity,
      height: double.infinity,
      // color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: double.infinity,
            height: actionBarHeight,
            child: _topBar(),
          ),
          Flexible(flex: gridFlex, fit: FlexFit.tight, child: _wordGridView()),
          Flexible(flex: keyBoardFlex, fit: FlexFit.tight, child: _keyBoard()),
          SizedBox(
              width: double.infinity, height: actionBarHeight, child: _ads()),
        ],
      ),
    );
  }

  Widget _topBar() {
    return TopBar(
      color: Tint.main_color_darker,
    );
  }

  Widget _wordGridView() {
    var screenWidth = getWidth(context);
    var marginHorizontal = 40.0;
    var wordGridViewWidth = screenWidth - marginHorizontal * 2;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
        child: WordBoard(
          wordLength: _controller?.wordLength.value ?? 5,
          width: wordGridViewWidth,
          backgroundColor: _backgroundColor,
        ),
      ),
    );
  }

  Widget _keyBoard() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: KeyBoard(
          buttonColor: Tint.button_color,
          onClick: (ascii) => _clickedFromKeyboard(ascii),
          backgroundColor: _backgroundColor,
        ));
  }

  Widget _ads() {
    return const BannerAds();
  }

  // named function ------------------------------------------------------------

  void _clickedFromKeyboard(int ascii) {
    _controller?.setupWordBoard?.type(ascii);
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
