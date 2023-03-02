import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hoodie/home/initial_setup_screen.dart';

import 'firebase_options.dart';
import 'home/home_screen.dart';
import 'user management/login_helper.dart';

class SplashScreen extends StatefulWidget {
  static const route = "SplashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) async {
      // Navigator.of(context).pushReplacementNamed(HomeScreen.route);
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        await LoginHelper.signInWithGoogle();
      } else {
        final snapshot = await FirebaseDatabase.instance
            .ref()
            .child('users/${user.uid}')
            .get();
        if (snapshot.exists) {
          log(user.displayName.toString());
          Navigator.of(context).pushReplacementNamed(HomeScreen.route);
        } else {
          log(user.email.toString());
          Navigator.of(context)
              .pushReplacementNamed(InitialSetupScreen.route, arguments: user);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
