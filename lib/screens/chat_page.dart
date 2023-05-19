import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  static const route = "ChatPage";
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    var messageId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: const Color(0xffE2DEFF),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ListTile(
            minLeadingWidth: 50,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: SizedBox(
              height: 50,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset("assets/test.png"),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    "Surya",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("messages")
                    .doc(messageId)
                    .collection("messages")
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text(
                      'No Data...',
                    );
                  } else {
                    var messages = snapshot.data!.docs;

                    return Container();
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
