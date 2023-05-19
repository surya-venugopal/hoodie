import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hoodie/Models/skin_management.dart';
import 'package:hoodie/screens/chat_page.dart';
import 'package:hoodie/screens/choose_avatar_screen.dart';
import 'package:hoodie/screens/create_profile_screen.dart';
import 'package:hoodie/screens/home_screen.dart';
import 'package:hoodie/screens/connect_hoodie_screen.dart';
import 'package:hoodie/screens/login_screen.dart';
import 'package:hoodie/screens/skin_info_screen.dart';
import 'package:hoodie/Models/favorite_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: const Color(0xff6A5BC4),
      canvasColor: Colors.white,
      appBarTheme: const AppBarTheme(color: Color(0xff6A5BC4)),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          backgroundColor: Color(0xff6A5BC4),
          unselectedItemColor: Colors.white54),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff6A5BC4),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25)),
      ),
      fontFamily: 'Kiona',
      textTheme: const TextTheme(
        bodyText2: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        hintStyle:
            const TextStyle(color: Colors.black38, fontFamily: "Poppins"),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color(0xff6A5BC4),
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color(0xff6A5BC4),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color(0xff6A5BC4),
            width: 2.0,
          ),
        ),
      ),
    ),
    initialRoute: HomeScreen.route,
    routes: {
      ChatPage.route: (context) => const ChatPage(),
      CreateProfileScreen.route: (context) => const CreateProfileScreen(),
      HomeScreen.route: (context) => ChangeNotifierProvider(
            create: (_) => SkinsProvider(),
            child: const HomeScreen(),
          ),
      LoginScreen.route: (context) => const LoginScreen(),
      ConnectHoodieScreen.route: (context) => const ConnectHoodieScreen(),
      AvatarSelectionScreen.route: (context) => const AvatarSelectionScreen(),
      SkinInfoScreen.route: (context) => ChangeNotifierProvider(
            create: (_) => FavoriteProvider(),
            child: const SkinInfoScreen(),
          ),
    },
  ));
}
