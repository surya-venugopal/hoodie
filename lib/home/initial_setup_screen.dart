import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

class InitialSetupScreen extends StatefulWidget {
  static const route = "InitialSetupScreen";
  const InitialSetupScreen({super.key});

  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  final _qrScanner = QrBarCodeScannerDialog();

  String _msg = "Start Setup";

  @override
  Widget build(BuildContext context) {
    var user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setup"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(_msg),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _qrScanner.getScannedQrBarCode(
                    context: context,
                    onCode: (code) {
                      showDialog(
                        context: context,
                        builder: (c1) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: Center(
                              child: Text(
                                  "Are you you want to link this hoodie to ${user.email}"),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () async {
                                    var snapshot = await FirebaseFirestore
                                        .instance
                                        .collection('users')
                                        .where("hoodie", isEqualTo: code)
                                        .get();

                                    if (snapshot.size == 0) {
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(user.uid)
                                          .set({
                                        "name": user.displayName,
                                        "hoodie": code,
                                        "current_skin": "",
                                      });
                                      Navigator.of(context).pop();
                                    } else {
                                      setState(() {
                                        _msg =
                                            "Ooops ... This hoodie is connected to another account!";
                                      });
                                    }
                                  },
                                  child: const Text("Link"))
                            ],
                          );
                        },
                      );
                    });
              },
              child: const Text("Click me"),
            ),
          ],
        ),
      ),
    );
  }
}
