import 'package:flutter/material.dart';

class MyThemes{
  static final darkTheme = ThemeData(
    primarySwatch: Colors.red,
    textTheme: const TextTheme(
      bodyText1: TextStyle(),
      bodyText2: TextStyle(),
    ).apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
  );

  static final lightTheme = ThemeData(
    primarySwatch: Colors.blue,
  );
}