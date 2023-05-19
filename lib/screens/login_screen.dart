import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hoodie/screens/create_profile_screen.dart';
import 'package:hoodie/widgets/my_widgets.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:pinput/pinput.dart';

import '../app_utils.dart';
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

  String phone = "";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/images/login.png",
              ),
              const SizedBox(height: 30),
              const Text(
                "Log in",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Phone Number",
                  style: TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PhoneFormField(
                  defaultCountry: IsoCode.IN,
                  validator: (phoneNumber) {
                    if (phoneNumber != null && phoneNumber.isValid()) {
                      return null;
                    } else {
                      return "Enter valid phone number";
                    }
                  },
                  decoration: const InputDecoration(),
                  onChanged: (phoneNumber) {
                    if (phoneNumber != null && phoneNumber.isValid()) {
                      phone = "+${phoneNumber.countryCode}${phoneNumber.nsn}";
                    } else {
                      phone = "";
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 2,
                    width: 100,
                    color: Colors.black12,
                  ),
                  const SizedBox(width: 30),
                  const Text("OR"),
                  const SizedBox(width: 30),
                  Container(
                    height: 2,
                    width: 100,
                    color: Colors.black12,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ColoredBox(
                      color: const Color.fromARGB(255, 225, 225, 225),
                      child: IconButton(
                        iconSize: 30,
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(HomeScreen.route);
                        },
                        icon: const Icon(Icons.map),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ColoredBox(
                      color: const Color.fromARGB(255, 225, 225, 225),
                      child: IconButton(
                        iconSize: 30,
                        onPressed: () {
                          AppUtils.dump();
                        },
                        icon: const Icon(Icons.location_city),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MyWidgets.slideButton(() async {
                  ConfirmationResult? confirmationResult;
                    if (_formKey.currentState!.validate()) {
                    confirmationResult = await FirebaseAuth.instance
                        .signInWithPhoneNumber(phone);
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (c1) {
                          TextEditingController otpController =
                              TextEditingController();
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            title: const Text(
                              "OTP",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            content: SizedBox(
                              height: 130,
                              child: Column(
                                children: [
                                  Pinput(
                                    length: 6,
                                    defaultPinTheme: PinTheme(
                                      width: 40,
                                      height: 40,
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    focusedPinTheme: PinTheme(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    pinputAutovalidateMode:
                                        PinputAutovalidateMode.onSubmit,
                                    showCursor: true,
                                    controller: otpController,
                                    autofocus: true,
                                  ),
                                  const SizedBox(height: 40),
                                  InkWell(
                                    onTap: () async {
                                      if (otpController.text.isNotEmpty) {
                                        try {
                                          var u = (await confirmationResult!
                                                  .confirm(otpController.text))
                                              .user;
                                          if (u != null) {
                                            UserProvider.uid = u.uid;
                                            DocumentSnapshot doc =
                                                await FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(u.uid)
                                                    .get();
                                            if (!doc.exists) {
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      CreateProfileScreen
                                                          .route);
                                            } else {
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      HomeScreen.route);
                                            }
                                          }
                                        } catch (e) {
                                          otpController.text = "";
                                        }
                                      }
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.black),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Continue",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }, "Log in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
