import 'package:flutter/material.dart';
import 'package:wordle_game/src/res/dimens.dart';
import 'package:wordle_game/src/res/tint.dart';

class TextStyles{

  static const font_weight_small= FontWeight.w300;
  static const font_weight_medium = FontWeight.w400;

  static const TextStyle SIZE_S = TextStyle(
      color: Tint.TEXT_COLOR_LIGHT,
      fontSize: Dimens.text_size_normal,
      fontWeight: font_weight_medium
  );

  static const TextStyle SIZE_M = TextStyle(
    color: Tint.TEXT_COLOR_LIGHT,
    fontSize: Dimens.text_size_medium,
    fontWeight: font_weight_medium
  );

}