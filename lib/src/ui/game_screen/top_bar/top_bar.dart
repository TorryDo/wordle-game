import 'package:flutter/material.dart';
import 'package:wordle_game/src/utils/res/tint.dart';

class TopBar extends StatelessWidget {
  static const LEFT_ICON = 1;
  static const RIGHT_ICON = 2;
  static const MIDDLE_ICON = 3;

  final Function(int where)? onClick;

  final Color? color;

  final tsize = 50.0;

  const TopBar({Key? key, this.onClick, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _wrapper();
  }

  Widget _wrapper() {
    return Container(
      color: color,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(flex: 1, child: _leftIcon()),
        Flexible(flex: 4, child: _centerLogo()),
        Flexible(flex: 1, child: _rightIcon()),
      ]),
    );
  }

  Widget _leftIcon() {
    return GestureDetector(
      onTap: () => _onClick(where: LEFT_ICON),
      child: const Center(
          child: Icon(Icons.menu, color: Tint.THEME_COLOR_REVERSE)),
    );
  }

  Widget _centerLogo() {
    return GestureDetector(
      onTap: () => _onClick(where: MIDDLE_ICON),
      child: const Center(
        child: Icon(
          Icons.android,
          color: Tint.THEME_COLOR_REVERSE,
          size: 50,
        ),
      ),
    );
  }

  Widget _rightIcon() {
    return GestureDetector(
      onTap: () => _onClick(where: RIGHT_ICON),
      child: const Center(
          child: Icon(Icons.settings, color: Tint.THEME_COLOR_REVERSE)),
    );
  }

  // magic ---------------------------------------------------------------------

  void _onClick({
    required int where,
  }) {
    if (onClick != null) onClick!(where);
  }
}
