import 'package:flutter/material.dart';
import 'package:hoodie/Models/spot_management.dart';
import 'package:hoodie/screens/chat_people.dart';
import 'package:hoodie/screens/marketplace_fragment.dart';
import 'package:hoodie/screens/profile_fragment.dart';
import 'package:hoodie/screens/spotted_fragment.dart';
import 'package:provider/provider.dart';

import '../Models/skin_management.dart';
import '../Models/user_management.dart';
import '../app_utils.dart';
import '../Models/favorite_provider.dart';

class HomeScreen extends StatefulWidget {
  static const route = "HomeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  final List<Widget> _pages = [
    const ChatPeopleFragment(),
    ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child: MarketplaceFragment(),
    ),
    ChangeNotifierProvider(
      create: (context) => SpotProvider(),
      child: const SpottedFragment(),
    ),
    const ProfileFragment(),
  ];

  PageController? _pageController;
  var isInit = true;

  @override
  void dispose() {
    _pageController!.dispose();

    super.dispose();
  }

  setBottomBarIndex(index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController!.jumpToPage(_selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    // User? user = FirebaseAuth.instance.currentUser;
    // if (user == null) {
    //   Navigator.of(context).pushReplacementNamed(LoginScreen.route);
    // }
    if (isInit) {
      var provider = Provider.of<SkinsProvider>(context, listen: false);
      UserProvider.getUser()
          .then((value) => provider.getUser())
          .then((value) =>
              provider.getMySkins().then((value) => provider.getSkins()))
          .then((value) =>
              _pageController = PageController(initialPage: _selectedIndex))
          .then((value) => setState(() {
                isInit = false;
              }));
    }
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _pageController == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _pages,
                  ),
            if (WidgetsBinding.instance.window.viewInsets.bottom == 0.0)
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: size.width,
                  height: 80,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CustomPaint(
                        size: Size(size.width, 80),
                        painter: BNBCustomPainter(),
                      ),
                      Center(
                        heightFactor: 0.6,
                        child: FloatingActionButton(
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 0.1,
                          onPressed: () {},
                          child: const Icon(Icons.camera),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.chat_rounded,
                                color: _selectedIndex == 0
                                    ? Colors.white
                                    : AppUtils.secondaryColor,
                              ),
                              onPressed: () {
                                setBottomBarIndex(0);
                              },
                              splashColor: Colors.white,
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: _selectedIndex == 1
                                      ? Colors.white
                                      : AppUtils.secondaryColor,
                                ),
                                onPressed: () {
                                  setBottomBarIndex(1);
                                }),
                            Container(
                              width: size.width * 0.20,
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.explore_outlined,
                                  color: _selectedIndex == 2
                                      ? Colors.white
                                      : AppUtils.secondaryColor,
                                ),
                                onPressed: () {
                                  setBottomBarIndex(2);
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.person_outline_rounded,
                                  color: _selectedIndex == 3
                                      ? Colors.white
                                      : AppUtils.secondaryColor,
                                ),
                                onPressed: () {
                                  setBottomBarIndex(3);
                                }),
                          ],
                        ),
                      ),
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
