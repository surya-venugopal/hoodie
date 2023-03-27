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

  String _msg = "Start Setup";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connect Your Hoodie"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_msg),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _qrScanner.getScannedQrBarCode(
                    context: context,
                    onCode: (code) {
                      if (code != null) {
                        code = code.substring(code.indexOf("code=")+5);
                        showDialog(
                          context: context,
                          builder: (c1) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: Center(
                                child: Text(
                                  "Are you you want to link this hoodie to ${UserProvider.phone}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      var db = FirebaseFirestore.instance;
                                      var doc = await db
                                          .collection('hoodies')
                                          .doc(code)
                                          .get();
                                      if (doc.exists) {
                                        if (doc["uid"] == "") {
                                          db.runTransaction(
                                              (transaction) async {
                                            transaction.set(
                                                db
                                                    .collection("users")
                                                    .doc(UserProvider.uid)
                                                    .collection("hoodies")
                                                    .doc(code),
                                                {
                                                  "hoodie": code,
                                                });
                                            transaction.set(
                                                db
                                                    .collection("hoodies")
                                                    .doc(code),
                                                {
                                                  "uid": UserProvider.uid,
                                                });
                                          });

                                          setState(() {
                                            _msg = "Successfully connected";
                                          });
                                        } else {
                                          setState(() {
                                            _msg =
                                                "Ooops ... This hoodie is connected to another account!";
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          _msg = "This is not a valid hoodie!";
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