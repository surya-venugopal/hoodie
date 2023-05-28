import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoodie/Models/user_management.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

class ConnectHoodieScreen extends StatefulWidget {
  static const route = "ConnectHoodieScreen";
  const ConnectHoodieScreen({super.key});

  @override
  State<ConnectHoodieScreen> createState() => _ConnectHoodieScreenState();
}

class _ConnectHoodieScreenState extends State<ConnectHoodieScreen> {
  final _qrScanner = QrBarCodeScannerDialog();

  String _msg = "Unlock the power of augmented reality by clicking this button";

  connect() {}

  // bool isInit = true;
  @override
  Widget build(BuildContext context) {
    // User? user = FirebaseAuth.instance.currentUser;
    // if (user == null) {
    //   Navigator.of(context).pushReplacementNamed(LoginScreen.route);
    // }
    // if (isInit) {
    //   Future.delayed(Duration.zero).then((value) {
    //     connect();
    //   });

    //   isInit = false;
    // }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(203, 194, 255, 45),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, top: 20),
                  child: Text(
                    "Activate Hoodie",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      _msg,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_msg != "Successfully connected")
                      InkWell(
                        onTap: () async {
                          _qrScanner.getScannedQrBarCode(
                            context: context,
                            onCode: (code) {
                              if (code != null) {
                                code =
                                    code.substring(code.indexOf("code=") + 5);
                                showDialog(
                                  context: context,
                                  builder: (c1) {
                                    return AlertDialog(
                                      title: const Text("Confirm"),
                                      content: Center(
                                        child: Text(
                                          "Are you you want to link this hoodie to ${UserProvider.name}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () async {
                                              var db =
                                                  FirebaseFirestore.instance;
                                              var doc = await db
                                                  .collection('hoodies')
                                                  .doc(code)
                                                  .get();
                                              if (doc.exists) {
                                                if (doc["uid"] == "") {
                                                  db
                                                      .collection("hoodies")
                                                      .doc(code)
                                                      .set({
                                                    "uid": UserProvider.uid,
                                                  });

                                                  setState(() {
                                                    _msg =
                                                        "Successfully connected";
                                                  });
                                                } else {
                                                  setState(() {
                                                    _msg =
                                                        "Ooops ... This hoodie is connected to another account!";
                                                  });
                                                }
                                              } else {
                                                setState(() {
                                                  _msg =
                                                      "This is not a valid code!";
                                                });
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Link"))
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.black),
                          alignment: Alignment.center,
                          child: Text(
                            _msg.startsWith("Unlock")
                                ? "Continue"
                                : "Try Again",
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 60,
            left: 30,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}
