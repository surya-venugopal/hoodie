import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hoodie/app_utils.dart';
import 'package:hoodie/screens/connect_hoodie_screen.dart';
import 'package:hoodie/screens/skin_info_screen.dart';
import 'package:provider/provider.dart';

import '../Models/skin_management.dart';
import '../Models/user_management.dart';
import '../widgets/my_widgets.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment>
    with AutomaticKeepAliveClientMixin<ProfileFragment> {
  late SkinsProvider skinProvider;

  SelectAction? selectedMenu;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    skinProvider = Provider.of<SkinsProvider>(context, listen: true);

    return ListView(
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
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    UserProvider.name,
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    UserProvider.userId,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
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
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            height: 40,
                            width: 230,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              color: Colors.black26,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "User Score",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                Container(
                                  width: 70,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.white),
                                      color: Colors.black38),
                                  child: FittedBox(
                                    child: Text(
                                      UserProvider.points.toString(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 40,
                            width: 230,
                            padding: const EdgeInsets.only(left: 10),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              color: Colors.black26,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Reward Points",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Container(
                                  width: 70,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.white),
                                      color: Colors.black38),
                                  child: const Text(
                                    "0",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      )
                    ],
                  )
                ],
              ),
              Positioned(
                right: 10,
                child: PopupMenuButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  initialValue: selectedMenu,
                  onSelected: (value) {
                    if (value == SelectAction.activateHoodie) {
                      Navigator.of(context)
                          .pushNamed(ConnectHoodieScreen.route);
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: SelectAction.activateHoodie,
                      child: Text(
                        'Activate Hoodie',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const PopupMenuItem(
                      value: SelectAction.logOut,
                      child: Text(
                        'Log out',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        MyWidgets.topic("Owned Skins"),
        const SizedBox(height: 15),
        Stack(
          children: [
            Container(
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(203, 194, 255, 45),
                  borderRadius: BorderRadius.circular(30)),
            ),
            Container(
              padding: const EdgeInsets.only(top: 30),
              child: CarouselSlider(
                options: CarouselOptions(
                  initialPage: skinProvider.mySkins.length,
                  autoPlayInterval: const Duration(seconds: 5),
                  enableInfiniteScroll: false,
                  viewportFraction: 0.6,
                  height: 250,
                  autoPlay: true,
                ),
                items: skinProvider.mySkins.map((skin) {
                  log("${skin.id} ${UserProvider.currentSkin}");
                  return InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(SkinInfoScreen.route, arguments: {
                        "skin": skin,
                        "hasBought": HasBought.yes,
                        "equipped": (skin.id == UserProvider.currentSkin)
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            skin.imageUrl,
                            fit: BoxFit.cover,
                            height: 250,
                            width: 220,
                          ),
                        ),
                        if (skin.id == UserProvider.currentSkin)
                          Positioned(
                            top: 5,
                            right: 15,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.black38),
                              child: const Text(
                                "Equipped",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 5,
                          child: Text(
                            skin.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

enum SelectAction {
  activateHoodie,
  logOut,
}
