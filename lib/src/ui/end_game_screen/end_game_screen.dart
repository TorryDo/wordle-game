import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/common/interface/ui_notifier.dart';
import 'package:wordle_game/src/ui/end_game_screen/end_game_screen_controller.dart';

class EndGameScreen extends StatefulWidget {
  const EndGameScreen({Key? key}) : super(key: key);

  @override
  _EndGameScreenState createState() => _EndGameScreenState();
}

class _EndGameScreenState extends State<EndGameScreen> with UINotifier {
  EndGameScreenController? _controller;

  @override
  void initState() {
    super.initState();

    _controller ??= Get.find<EndGameScreenController>();
    _controller?.onInitState();
    _controller?.registerUINotifier(this);
  }

  @override
  Widget build(BuildContext context) {
    _controller?.onBuildState();
    return _wrapper();
  }

  Widget _wrapper() {
    return SafeArea(
      child: Material(
        child: _wallpaper(),
      ),
    );
  }

  Widget _wallpaper() {
    var img = Image.asset(
      "assets/images/demon.jpg",
      alignment: Alignment.center,
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.fill,
    );
    if (_controller!.hasWon) {
      img = Image.asset(
        "assets/images/girl_tree.png",
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.fill,
      );
    }
    return Stack(
      children: [
        img,
        ClipRRect(
          // Clip it cleanly.
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.grey.withOpacity(0.1),
              alignment: Alignment.center,
            ),
          ),
        ),
        _resultPage()
      ],
    );
  }

  Widget _resultPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 250,
            height: 70.0,
            child: ElevatedButton(
                onPressed: _controller?.navigateBackToGameScreen,
                child: Text(
                  _getTitle(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
          Container(
              width: 300,
              height: 200.0,
              child: Center(
                child: Text(
                  "answer is: ${_controller?.targetWord}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  String _getTitle() {
    if (_controller == null) return "null";
    if (_controller!.hasWon) {
      return "You Won, Genius!";
    }
    return "You Lose, Idiot!";
  }
}
