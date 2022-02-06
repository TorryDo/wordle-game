import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wordle_game/src/ui/components/word_box/char_box.dart';
import 'package:wordle_game/src/ui/components/word_box/word_grid_view.dart';
import 'package:wordle_game/src/utils/get_width_height.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = getWidth(context);
    var marginHorizontal = 8.0;
    var wordGridViewHeight = screenWidth - marginHorizontal*2;

    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black87,
        child: Center(child: Padding(
          padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
          child: WordGridView(charNumber: 5, width: wordGridViewHeight),
        )),
      ),
    );
  }
}
