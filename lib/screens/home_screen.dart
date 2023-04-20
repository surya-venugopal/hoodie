import 'package:flutter/material.dart';
import 'package:hoodie/Models/spot_management.dart';
import 'package:hoodie/screens/marketplace_fragment.dart';
import 'package:hoodie/screens/profile_fragment.dart';
import 'package:hoodie/screens/spotted_fragment.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const route = "HomeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _pages = [
      MarketplaceFragment(),
      const ProfileFragment(),
      ChangeNotifierProvider(
        create: (context) => SpotProvider(),
        child: const SpottedFragment(),
      ),
    ];

    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // User? user = FirebaseAuth.instance.currentUser;
    // if (user == null) {
    //   Navigator.of(context).pushReplacementNamed(LoginScreen.route);
    // }
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
            _pageController.jumpToPage(_selectedIndex);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: "Spotted",
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
