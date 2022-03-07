import 'package:flutter/material.dart';
import 'package:wordle_game/src/utils/res/tint.dart';

class TopBar extends StatelessWidget {
  final tsize = 50.0;

  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _wrapper();
  }

  Widget _wrapper() {
    return Container(
      color: Colors.blueGrey.withAlpha(10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(flex: 1, child: _leftIcon()),
        Flexible(flex: 4, child: _centerLogo()),
        Flexible(flex: 1, child: _rightIcon()),
      ]),
    );
  }

  Widget _leftIcon() {
    return const Center(
        child: Icon(Icons.menu, color: Tint.THEME_COLOR_REVERSE));
  }

  Widget _centerLogo() {
    return const Center(
      child: Icon(
        Icons.android,
        color: Tint.THEME_COLOR_REVERSE,
        size: 50,
      ),
    );
  }

  Widget _rightIcon() {
    return const Center(
        child: Icon(Icons.settings, color: Tint.THEME_COLOR_REVERSE));
  }
}
