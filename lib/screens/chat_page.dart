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
    return Scaffold(
      backgroundColor: const Color(0xffE2DEFF),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ListTile(
            minLeadingWidth: 50,
            leading: IconButton(
              onPressed: () {},
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
            ),
          )
        ],
      ),
    );
  }
}
