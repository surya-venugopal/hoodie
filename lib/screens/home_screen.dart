import 'package:flutter/material.dart';
import 'package:hoodie/screens/chat_people.dart';
import 'package:hoodie/screens/marketplace_fragment.dart';
import 'package:hoodie/screens/profile_fragment.dart';
import 'package:hoodie/screens/spotted_fragment.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_utils.dart';

class HomeScreen extends StatefulWidget {
  static const route = "HomeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;
  final List<Widget> _pages = [
    const ChatPeopleFragment(),
    const MarketplaceFragment(),
    const SpottedFragment(),
    const ProfileFragment(),
  ];

  PageController? _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: _selectedIndex);

    super.initState();
  }

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

  final _qrScanner = QrBarCodeScannerDialog();

  @override
  Widget build(BuildContext context) {
    // User? user = FirebaseAuth.instance.currentUser;
    // if (user == null) {
    //   Navigator.of(context).pushReplacementNamed(LoginScreen.route);
    // }

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
                      // if (_selectedIndex != 3)
                      Center(
                        heightFactor: 0.6,
                        child: FloatingActionButton(
                          backgroundColor: Theme.of(context).primaryColor,
                          elevation: 0.1,
                          onPressed: () {
                            _qrScanner.getScannedQrBarCode(
                              context: context,
                              onCode: (code) async {
                                if (code != null &&
                                    code.contains("hoodie-ar.web.app")) {
                                  code =
                                      code.substring(code.indexOf("code=") + 5);
                                  if (!await launchUrl(Uri.parse(code))) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Not a valid hoodie!"),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Not a valid hoodie!"),
                                    ),
                                  );
                                }
                              },
                            );
                          },
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
