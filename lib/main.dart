import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:wordle_game/di.dart';
import 'package:wordle_game/src/common/provider/theme_provider.dart';
import 'package:wordle_game/src/ui/end_game_screen/end_game_screen.dart';
import 'package:wordle_game/src/ui/game_screen/game_screen.dart';
import 'package:wordle_game/src/ui/routes.dart';
import 'package:wordle_game/src/ui/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);

    return const MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return _navigator();
  }

  Widget _navigator() {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: const SplashScreen(),
      defaultTransition: Transition.fade,
      getPages: [
        GetPage(name: Routes.SPLASH_SCREEN, page: () => const SplashScreen()),
        GetPage(name: Routes.GAME_SCREEN, page: () => const GameScreen()),
        GetPage(
            name: Routes.END_GAME_SCREEN, page: () => const EndGameScreen()),
      ],
    );
  }
}
