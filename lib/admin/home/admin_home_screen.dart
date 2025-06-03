import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/add_employee_screen.dart';
 import 'package:hrms_management_code_crafter/admin/employee/screen/employee_list_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/leave_module/emp__leaves_request_list_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/policy/add_company_policy_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/policy/policy_list_screen.dart';
import 'package:hrms_management_code_crafter/admin/home/attendance/attandance_sheet_list_screen.dart';
import 'package:hrms_management_code_crafter/screen/nav_profile/screen/attandance_list_screen.dart';
import 'package:hrms_management_code_crafter/ui_helper/app_colors.dart';
import 'package:hrms_management_code_crafter/ui_helper/app_text_styles.dart';
import 'package:hrms_management_code_crafter/util/responsive_helper_util.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';
import 'package:provider/provider.dart';

import '../../screen/auth/controller/auth_provider.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  DateTime? lastBackPressedTime;
  DateTime? _lastBackPressed;

  Future<bool> _onBackPressed() async {
    final now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      // Show snackbar message to press again
      _lastBackPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Press back again to exit the app",),
          duration: const Duration(seconds: 2),
        ),
      );
      return false; // Prevent app from exiting
    }
    return true; // Allow app to exit
  }

  // Function to determine the greeting
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: AppColors.lightBgColor,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "HRMS",
                  style: AppTextStyles.heading2(
                    context,
                    overrideStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextSpan(
                  text: "",
                  style: AppTextStyles.heading2(
                    context,
                    overrideStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEmployeeScreen(),
                        ),
                      );
                    },
                    child: DashboardCard(
                      title: 'Add\nEmployee',
                      icon: Icons.person,
                      color: Colors.deepPurple,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCompanyPolicyScreen(),
                        ),
                      );
                    },
                    child: DashboardCard(
                      title: 'Add\nCompany Policy',
                      icon: Icons.calculate,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  DashboardCard(
                    title: 'Payroll Management',
                    icon: Icons.monetization_on,
                    color: Colors.cyan,
                  ),
                  DashboardCard(
                    title: 'File Management',
                    icon: Icons.folder,
                    color: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmployeeListScreen()),
                  );
                },
                child: const CustomListTile(
                  title: 'All Employees',
                  icon: Icons.people_alt_outlined,
                  color: Colors.lightBlue,
                  bgColor: Color(0xFFE6F0FA),
                ),
              ),
              InkWell(
                onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => EmpBankDetailScreen()),
                // );
              },
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PolicyListScreen(),
                      ),
                    );
                  },
                  child: const CustomListTile(
                    title: 'View Company Policy',
                    icon: Icons.description_outlined,
                    color: Colors.deepOrange,
                    bgColor: Color(0xFFFFF1E6),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmployeeLeaveRequestListScreen()),
                  );
                },
                child: const CustomListTile(
                  title: 'Leave Request',
                  icon: Icons.notifications_active_outlined,
                  color: Colors.green,
                  bgColor: Color(0xFFE6FAF0),
                  hasNotification: true,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AttendanceSheetTableScreen()),
                  );
                },
                child: const CustomListTile(
                  title: 'Attendance Sheet',
                  icon: Icons.calendar_month_outlined,
                  color: Colors.deepPurple,
                  bgColor: Color(0xFFF3E6FA),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => EmpBankDetailScreen()),
                  // );
                },
                child: GestureDetector(
                  onTap: () {
                    showLogoutBottomSheet(context );
                  },
                  child: const CustomListTile(
                    title: 'Logout',
                    icon: Icons.logout,
                    color: Colors.deepOrange,
                    bgColor: Color(0xFFFFF1E6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



void showLogoutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return Builder(
        builder: (innerContext) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Drag Handle
              Container(
                width: 100,
                height: 5,
                color: Colors.grey[400],
              ),

              /// Warning Icon & Message
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 50,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Sign out from Account",
                        style: AppTextStyles.bodyText1(context,
                            overrideStyle: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            )),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Are you sure you would like to logout of your Account",
                        style: AppTextStyles.bodyText1(context,
                            overrideStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            )),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              /// Cancel & Logout Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel Button
                  ElevatedButton(
                    onPressed: () => Navigator.pop(innerContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightBrown_color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 0),
                    ),
                    child: Text(
                      "Cancel",
                      style: AppTextStyles.heading1(context,
                          overrideStyle: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
                  ),

                  // Logout Button
                  ElevatedButton(
                    onPressed: () {
                      print("Logout button clicked");
                      // Use the correct context with Provider
                      Provider.of<AuthAPIProvider>(innerContext, listen: false)
                          .logoutUser(innerContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 0),
                    ),
                    child: Text(
                      "Logout",
                      style: AppTextStyles.heading1(context,
                          overrideStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left side colored bar
          Container(
            width: 6,
            // height: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
          ),

          // Space between bar and content
          const SizedBox(width: 8),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: color, size: 30),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading3(
                      context,
                      overrideStyle: TextStyle(fontSize: ResponsiveHelper.fontSize(context, 12)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final bool hasNotification;

  const CustomListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.hasNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: bgColor,
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: AppTextStyles.heading3(
            context,
            overrideStyle: TextStyle(fontSize: 14),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasNotification)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
