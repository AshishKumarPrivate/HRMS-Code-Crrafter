
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/screen/home_screen.dart';
import 'package:hrms_management_code_crafter/screen/nav_profile/profile_screen.dart';

class UserBottomNavigationScreen extends StatefulWidget {
  const UserBottomNavigationScreen({super.key});

  @override
  State<UserBottomNavigationScreen> createState() => _UserBottomNavigationScreenState();
}

class _UserBottomNavigationScreenState extends State<UserBottomNavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
     HomeScreen(),
     HomeScreen(),
     HomeScreen(),
     ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.beach_access), label: 'Time Off'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
