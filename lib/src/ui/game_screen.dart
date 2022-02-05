import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wordle_game/src/utils/screen_details.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = getScreenWidth(context);

    double charBoxSize(double screenSize) => screenSize / 6;

    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black87,
        child: Center(
          child: charBox(charBoxSize(screenWidth), 'A'),
        ),
      ),
    );
  }

  charBox(double boxSize, String char,
      {Color backgroundColor = Colors.transparent,
      Color borderColor = Colors.deepOrangeAccent,
      double borderSize = 3,
      double borderRadius = 12.0,
      double fontSize = 40.0}) {
    return SizedBox(
      width: boxSize,
      height: boxSize,
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: borderSize),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        child: Center(
          child: Text(
            char,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
