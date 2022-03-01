import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordle_game/src/ui/splash_screen/splash_screen_controller.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashScreenController? _splashScreenController;

  @override
  void initState() {
    super.initState();
    _splashScreenController ??= Get.find<SplashScreenController>();
    _splashScreenController?.onInitWidget();
  }

  @override
  Widget build(BuildContext context) {
    _splashScreenController?.onBuildWidget();
    return _screen();
  }

  Widget _screen(){
    return SafeArea(child: Container(color: Colors.blue));
  }

  Widget _linearProgress(){
    return LinearProgressIndicator();
  }

}
