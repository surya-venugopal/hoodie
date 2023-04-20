import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoodie/Models/user_management.dart';
import 'package:hoodie/screens/home_screen.dart';

import 'login_screen.dart';

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
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.of(context).pushReplacementNamed(LoginScreen.route);
    }
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
      appBar: AppBar(
        title: const Text('Choose an avatar'),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 3,
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
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(UserProvider.uid)
              .update({
            "avatar": (_selectedAvatarIndex + 1).toString(),
          });
          UserProvider.avatar = (_selectedAvatarIndex + 1).toString();
          Navigator.of(context).pushReplacementNamed(HomeScreen.route);
        },
        child: const Text("Confirm"),
      ),
    );
  }
}
