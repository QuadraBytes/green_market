import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:green_market/components/constants.dart';
import 'package:green_market/screens/buyer_screen.dart';
import 'package:green_market/screens/community_screen.dart';
import 'package:green_market/screens/farmer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _currentIndex = 0;
  final PageController _page = PageController();
  // bool _isStudentMode = false;

  final List<Widget> _screens = [
    FarmerScreen(),
    BuyerScreen(),
    CommunityScreen(),
  ];

  // Future<void> _loadModeState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _isStudentMode = prefs.getBool('isStudentMode') ?? false;
  //   });
  // }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _page.jumpToPage(index);
    });
  }

  // void onModeChanged(bool isStudentMode) {
  //   _loadModeState();
  // }

  @override
  void initState() {
    super.initState();
    // _loadModeState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _page,
          onPageChanged: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          // children: _screens.map((screen) {
          //   if (screen is UserProfileScreen) {
          //     return UserProfileScreen(onModeChanged: onModeChanged);
          //   }
          //   return screen;
          // }).toList(),
          children: _screens,
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          child: BottomAppBar(
            color: kColor,
            notchMargin: 0,
            elevation: 0,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.person, "Farmer", 0),
                _buildNavItem(Icons.handshake_rounded, "Buyer", 1),
                _buildNavItem(Icons.groups_sharp, "Community", 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        navigateToPage(index);
      },
      child: Container(
        padding: EdgeInsets.zero,
        width: size.width * 0.18,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: size.height * 0.035,
                    color: Colors.white,
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.015,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 3,
            ),
            if (index == _currentIndex)
              Container(
                height: 3,
                width: size.width * 0.15,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }

  void navigateToPage(int page) {
    setState(() {
      _currentIndex = page;
      _page.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
}
