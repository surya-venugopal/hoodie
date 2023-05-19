import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoodie/Models/user_management.dart';

class AvatarSelectionScreen extends StatefulWidget {
  static const route = "AvatarSelectionScreen";
  const AvatarSelectionScreen({super.key});

  @override
  State<AvatarSelectionScreen> createState() => _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends State<AvatarSelectionScreen> {
  int _selectedAvatarIndex = 0;

  final List<String> _avatars = [
    'assets/avatars/avatar1.svg',
    'assets/avatars/avatar2.svg',
    'assets/avatars/avatar3.svg',
    'assets/avatars/avatar4.svg',
    'assets/avatars/avatar5.svg',
    'assets/avatars/avatar6.svg',
  ];

  void _onAvatarSelected(int index) {
    setState(() {
      _selectedAvatarIndex = index;
    });
  }

  Widget _buildAvatar(int index) {
    // User? user = FirebaseAuth.instance.currentUser;
    // if (user == null) {
    //   Navigator.of(context).pushReplacementNamed(LoginScreen.route);
    // }
    return GestureDetector(
      onTap: () => _onAvatarSelected(index),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          _avatars[index],
          fit: BoxFit.contain,
          color: _selectedAvatarIndex == index ? Colors.yellow : null,
          colorBlendMode: BlendMode.color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10, top: 20),
              child: Text(
                "Choose Avatar",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 1,
                padding: const EdgeInsets.all(8.0),
                children: List.generate(
                  _avatars.length,
                  (index) => _buildAvatar(index),
                ),
              ),
            ),
            const SizedBox(height: 50),
            InkWell(
              onTap: () async {

                Navigator.of(context).pop((_selectedAvatarIndex + 1).toString());
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
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
  }
}
