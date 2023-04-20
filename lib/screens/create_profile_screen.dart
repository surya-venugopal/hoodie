import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoodie/widgets/my_widgets.dart';

class CreateProfileScreen extends StatefulWidget {
  static const route = "CreateProfileScreen";
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  var nameController = TextEditingController();
  var uidController = TextEditingController();
  var referrelController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    uidController.dispose();
    referrelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: const DecorationImage(
                  image: AssetImage("assets/images/profile_background.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nameController.text,
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    uidController.text.isEmpty ? "" : "@${uidController.text}",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: 130,
                    height: 130,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black38,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: SvgPicture.asset(
                        "assets/avatars/avatar1.svg",
                        height: 130,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            MyWidgets.topic("Create profile"),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Name",
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          hintText: "enter your full name"),
                      onChanged: (name) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "User ID",
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: uidController,
                      decoration:
                          const InputDecoration(hintText: "enter your user id"),
                      style: const TextStyle(fontFamily: "Poppins"),
                      onChanged: (name) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Referrel",
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: referrelController,
                    ),
                    const SizedBox(height: 40),
                    MyWidgets.slideButton(() async {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
