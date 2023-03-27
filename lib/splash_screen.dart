import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'Models/user_management.dart';

class SplashScreen extends StatefulWidget {
  static const route = "SplashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _phone = "";

  @override
  void initState() {
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) async {
      // Navigator.of(context).pushReplacementNamed(HomeScreen.route);
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // var u = (await LoginHelper.signInWithGoogle()).user;

      } else {
        UserProvider.phone = user.email.toString();
        UserProvider.uid = user.uid;
        Navigator.of(context).pushReplacementNamed(HomeScreen.route);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: PhoneFormField(
                defaultCountry: IsoCode.IN,
                autofocus: true,
                decoration: const InputDecoration(
                    labelText: 'Phone', border: OutlineInputBorder()),
                onChanged: (phone) {
                  if (phone != null && phone.isValid()) {
                    _phone = "+${phone.countryCode}${phone.nsn}";
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  ConfirmationResult confirmationResult =
                      await FirebaseAuth.instance.signInWithPhoneNumber(_phone);
                  showDialog(
                      context: context,
                      builder: (c1) {
                        TextEditingController otp = TextEditingController();
                        return AlertDialog(
                          title: const Text("OTP"),
                          content: Center(
                            child: TextField(
                              controller: otp,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter OTP',
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () async {
                                  var u = (await confirmationResult
                                          .confirm(otp.text))
                                      .user;
                                  if (u != null) {
                                    DocumentSnapshot doc =
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(u.uid)
                                            .get();
                                    if (!doc.exists) {
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(u.uid)
                                          .set({
                                        "name": u.phoneNumber,
                                        "currentSkin": "",
                                        "points": 0,
                                      });
                                    }

                                    UserProvider.phone = u.phoneNumber.toString();
                                    UserProvider.uid = u.uid;
                                    Navigator.of(context)
                                        .pushReplacementNamed(HomeScreen.route);
                                  } else {}
                                },
                                child: const Text("Login"))
                          ],
                        );
                      });
                },
                child: const Text("Login"))
          ],
        ),
      ),
    );
  }
}
