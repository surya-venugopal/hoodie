import 'package:flutter/material.dart';
import 'package:hoodie/Models/skin_management.dart';
import 'package:hoodie/screens/home_screen.dart';
import 'package:hoodie/screens/connect_hoodie_screen.dart';
import 'package:hoodie/splash_screen.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider(
      create: (context) => SkinsProvider(),
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.blue,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: Colors.white,
                backgroundColor: Colors.blue,
                unselectedItemColor: Colors.white54),
            elevatedButtonTheme: const ElevatedButtonThemeData(
                style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
            ))),
        initialRoute: SplashScreen.route,
        routes: {
          HomeScreen.route: (context) => const HomeScreen(),
          SplashScreen.route: (context) => const SplashScreen(),
          ConnectHoodieScreen.route: (context) => const ConnectHoodieScreen(),
        },
      ),
    );
  }
}
