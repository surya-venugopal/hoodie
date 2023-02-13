import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  static const route = "ProfileScreen";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.red,
                ),
                const SizedBox(height: 80),
                const Text(
                  "Surya",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      Card(
                        child: Image.network(
                            "https://firebasestorage.googleapis.com/v0/b/linen-hook-346309.appspot.com/o/head_wings.png?alt=media&token=d7ad070e-2288-4deb-a8a7-6d940204017b"),
                      ),
                      Card(
                        child: Image.network(
                            "https://firebasestorage.googleapis.com/v0/b/linen-hook-346309.appspot.com/o/wings.png?alt=media&token=3f64fe77-21b2-40fd-8480-1b08f3fc94bb"),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final uri = Uri.parse("https://www.snapchat.com/unlock/?type=SNAPCODE&uuid=0c9ed57047564f06b0f0c0d1cc36032b&metadata=01");
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    } else {
                      throw 'Could not launch wings';
                    }
                  },
                  child: const Text("View on snapchat"),
                )
              ],
            ),
            Positioned(
              top: 130,
              left: size.width / 2 - 70,
              child: const CircleAvatar(
                radius: 70,
                backgroundColor: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
