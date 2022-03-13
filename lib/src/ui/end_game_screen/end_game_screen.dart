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
      child: Container(
        color: Colors.blueGrey.withAlpha(50),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: _controller?.navigateBackToGameScreen,
                child: Text(_getTitle())),
            ElevatedButton(
                onPressed: () {},
                child: Text("answer is: ${_controller?.targetWord}"))
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    if(_controller == null) return "null";
    if(_controller!.hasWon){
      return "You Won, Genius!";
    }
    return "You Lose, Idiot!";
  }
}
