import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hoodie/screens/choose_avatar_screen.dart';
import 'package:phone_form_field/phone_form_field.dart';

import 'home_screen.dart';
import '../Models/user_management.dart';

class LoginScreen extends StatefulWidget {
  static const route = "LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // Navigator.of(context).pushReplacementNamed(HomeScreen.route);
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // var u = (await LoginHelper.signInWithGoogle()).user;

    } else {
      UserProvider.name = user.phoneNumber.toString();
      UserProvider.uid = user.uid;
      Navigator.of(context).pushReplacementNamed(HomeScreen.route);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Image.asset(
          "assets/images/login.png",
        ),
        const SizedBox(height: 50),
        const Text(
          "BECOME A MEMBER OF",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'Kiona',
              fontSize: 30,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'EXOTIC ',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const TextSpan(text: 'CIRCLE'),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (c1) {
                      ConfirmationResult? confirmationResult;
                      TextEditingController otpController =
                          TextEditingController();
                      String phone = "";
                      return AlertDialog(
                        title: const Text("Login with phone"),
                        content: Column(
                          children: [
                            SizedBox(
                              width: 300,
                              child: PhoneFormField(
                                defaultCountry: IsoCode.IN,
                                autofocus: true,
                                decoration: const InputDecoration(
                                  labelText: 'Phone',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (phoneNumber) {
                                  if (phoneNumber != null &&
                                      phoneNumber.isValid()) {
                                    phone =
                                        "+${phoneNumber.countryCode}${phoneNumber.nsn}";
                                  } else {
                                    phone = "";
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                if (phone != "") {
                                  confirmationResult = await FirebaseAuth
                                      .instance
                                      .signInWithPhoneNumber(phone);
                                }
                              },
                              child: const Text("Send OTP"),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: otpController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter OTP',
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () async {
                                if (otpController.text.isNotEmpty) {
                                  try {
                                    var u = (await confirmationResult!
                                            .confirm(otpController.text))
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
                                          "avatar": 1,
                                        });
                                      }

                                      UserProvider.name =
                                          u.phoneNumber.toString();
                                      UserProvider.uid = u.uid;
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              AvatarSelectionScreen.route);
                                    }
                                  } catch (e) {
                                    log(e.toString());
                                    otpController.text = "";
                                  }
                                }
                              },
                              child: const Text(
                                "Login",
                              ))
                        ],
                      );
                    });
              },
              child: Row(
                children: const [
                  Text(
                    "Get started",
                  ),
                  SizedBox(width: 15),
                  Icon(Icons.keyboard_double_arrow_right)
                ],
              ),
            ),
            const SizedBox(width: 40),
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ColoredBox(
                    color: const Color.fromARGB(255, 225, 225, 225),
                    child: IconButton(
                        iconSize: 30,
                        onPressed: () {},
                        icon: const Icon(Icons.map)))),
            const SizedBox(width: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ColoredBox(
                color: const Color.fromARGB(255, 225, 225, 225),
                child: IconButton(
                  iconSize: 30,
                  onPressed: () {},
                  icon: const Icon(Icons.location_city),
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
