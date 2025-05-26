
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/home/admin_home_screen.dart';
import 'package:provider/provider.dart';

import '../../../bottom_navigation_screen.dart';
import '../../../ui_helper/app_colors.dart';
import '../../firebase/FirebaseNotificationService.dart';
import '../../screen/user_selection_screen.dart';
import '../../util/responsive_helper_util.dart';
import '../../util/storage_util.dart';
import '../controller/network_provider_controller.dart';
import 'NoInternetScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }
  void _checkConnectivity() async {
    await Future.delayed(const Duration(seconds: 1));

    bool isConnected = Provider.of<NetworkProvider>(context, listen: false).isConnected;

    if (!isConnected) {
      _navigateTo(NoInternetScreen());
      return;
    }

    final isLoggedIn = StorageHelper().getBoolIsLoggedIn();
    final role =await StorageHelper().getUserRole();
    print("Role=> ${role}");
    if (isLoggedIn) {
      if (role == "Admin") {
        _navigateTo(const AdminHomeScreen());
      } else if (role == "employee") {
        _navigateTo(const UserBottomNavigationScreen());
      } else {
        _navigateTo(const UserSelectionScreen());
      }
    } else {
      _navigateTo(const UserSelectionScreen());
    }
  }

  void _navigateTo(Widget screen) {

    NotificationService.initialize(context); // Initialize FCM
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/code_crafter_logo.png",
                  width: ResponsiveHelper.containerWidth(context, 40),
                  height: ResponsiveHelper.containerWidth(context, 40),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}