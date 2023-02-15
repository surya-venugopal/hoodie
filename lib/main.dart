import 'package:flutter/material.dart';
import 'package:hoodie/home/home_screen.dart';
import 'package:hoodie/home/profile_fragment.dart';
import 'package:hoodie/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SplashScreen.route,
      routes: {
        HomeScreen.route: (context) => const HomeScreen(),
        SplashScreen.route: (context) => const SplashScreen(),
      },
    );
  }
}
