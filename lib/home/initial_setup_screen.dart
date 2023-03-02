import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

import 'home_screen.dart';

class InitialSetupScreen extends StatefulWidget {
  static const route = "InitialSetupScreen";
  const InitialSetupScreen({super.key});

  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  final _qrScanner = QrBarCodeScannerDialog();

  String? code;

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
            const Text("Start Setup"),
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
                                    DatabaseReference ref = FirebaseDatabase
                                        .instance
                                        .ref("users/${user.uid}");

                                    await ref.set({
                                      "name": user.displayName,
                                      "hoodie": code,
                                      "current_skin": "",
                                    });

                                    Navigator.of(context)
                                        .pushReplacementNamed(HomeScreen.route);
                                  },
                                  child: const Text("Link"))
                            ],
                          );
                        },
                      );
                      setState(() {
                        this.code = code;
                      });
                    });
              },
              child: Text(code ?? "Click me"),
            ),
          ],
        ),
      ),
    );
  }
}
