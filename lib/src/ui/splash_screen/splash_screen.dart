import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/ui/splash_screen/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashScreenController? _controller;

  // lifecycle -----------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _controller ??= Get.find<SplashScreenController>();
    _controller?.onInitState();
  }

  @override
  void dispose() {
    _controller?.onDisposeState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller?.onBuildState();
    return _outer();
  }

  // widgets -------------------------------------------------------------------

  Widget _outer() {
    return SafeArea(
      child: Image.asset(
        "assets/images/nature.jpg",
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.fill,
      ),
    );
  }

}
