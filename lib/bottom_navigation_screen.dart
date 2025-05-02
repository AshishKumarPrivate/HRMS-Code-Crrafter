import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import 'package:hrms_management_code_crafter/screen/home_screen.dart';
import 'package:hrms_management_code_crafter/screen/nav_profile/profile_screen.dart';

class UserBottomNavigationScreen extends StatefulWidget {
  const UserBottomNavigationScreen({super.key});

  @override
  State<UserBottomNavigationScreen> createState() =>
      _UserBottomNavigationScreenState();
}

class _UserBottomNavigationScreenState
    extends State<UserBottomNavigationScreen> {
  int _currentIndex = 0;
  DateTime? _lastBackPressed;

  final List<Widget> _screens = [
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];

  Future<bool> _onBackPressed() async {
    final now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Press back again to exit the app"),
          duration: Duration(seconds: 2),
        ),
      );
      return false; // Prevent pop
    }
    return true; // Allow pop (exit app)
  }

  @override
  Widget build(BuildContext context) {
    Color selectedColor = const Color(0xFF004658);
    Color unselectedColor = const Color(0xff575757);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        // if (!didPop) {
          final shouldExit = await _onBackPressed();
          if (shouldExit) {
            SystemNavigator.pop(); // Force exit
          }
        // }
      },
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            onTap: (index) => setState(() => _currentIndex = index),
            currentIndex: _currentIndex,
            selectedItemColor: selectedColor,
            unselectedItemColor: unselectedColor,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 10,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 14, // Text size jab selected
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              fontSize: 12, // Text size jab unselected
            ),
            selectedIconTheme: IconThemeData(
              size: 28, // 👈 Selected icon bada
            ),
            unselectedIconTheme: IconThemeData(
              size: 24, // 👈 Unselected icon chhota
            ),
            items:  [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                label: 'Notification',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time_outlined),
                label: 'Time Off',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
