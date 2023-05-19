import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoodie/Models/user_management.dart';
import 'package:hoodie/screens/choose_avatar_screen.dart';
import 'package:hoodie/screens/home_screen.dart';
import 'package:hoodie/widgets/my_widgets.dart';

class CreateProfileScreen extends StatefulWidget {
  static const route = "CreateProfileScreen";
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var userIdController = TextEditingController();
  var referrelController = TextEditingController();
  var avatar = "1";
  @override
  void dispose() {
    nameController.dispose();
    userIdController.dispose();
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
                    userIdController.text.isEmpty
                        ? ""
                        : "@${userIdController.text}",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 40),
                  InkWell(
                    onTap: () async {
                      final result = await Navigator.of(context)
                          .pushNamed(AvatarSelectionScreen.route);
                      setState(() {
                        avatar = result.toString();

                UserProvider.avatar = avatar;
                      });
                    },
                    child: Container(
                      width: 130,
                      height: 130,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black38,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              "assets/avatars/avatar$avatar.svg",
                              height: 130,
                              fit: BoxFit.contain,
                            ),
                            Positioned(
                              right: 5,
                              top: 5,
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.black45),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            MyWidgets.topic("Create profile"),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Name",
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name field is required";
                        }
                        return null;
                      },
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
                      controller: userIdController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name field is required";
                        }
                        return null;
                      },
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
                      decoration: const InputDecoration(
                          hintText: "enter referrel code"),
                    ),
                    const SizedBox(height: 40),
                    MyWidgets.slideButton(() async {
                      if (_formKey.currentState!.validate()) {
                        await UserProvider.setuser(
                          avatar: avatar,
                          name: nameController.text,
                          userId: userIdController.text,
                          referrel: referrelController.text,
                        ).then((value) {
                          UserProvider.name = nameController.text;
                          Navigator.of(context)
                              .pushReplacementNamed(HomeScreen.route);
                        });
                      }
                    }, "Continue"),
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
