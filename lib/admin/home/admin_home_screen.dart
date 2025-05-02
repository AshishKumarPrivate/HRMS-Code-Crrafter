import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/add_employee_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/employee_list_screen.dart';
import 'package:hrms_management_code_crafter/ui_helper/app_colors.dart';
import 'package:hrms_management_code_crafter/ui_helper/app_text_styles.dart';

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
                  text: "HRM &\n",
                  style: AppTextStyles.heading2(
                    context,
                    overrideStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextSpan(
                  text: "Payroll Management",
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
                  DashboardCard(
                    title: 'Expenses Management',
                    icon: Icons.calculate,
                    color: Colors.pinkAccent,
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
              const CustomListTile(
                title: 'NOC/Ex Certificate',
                icon: Icons.description_outlined,
                color: Colors.deepOrange,
                bgColor: Color(0xFFFFF1E6),
              ),
              const CustomListTile(
                title: 'Notice Board',
                icon: Icons.notifications_active_outlined,
                color: Colors.green,
                bgColor: Color(0xFFE6FAF0),
                hasNotification: true,
              ),
              const CustomListTile(
                title: 'Award',
                icon: Icons.emoji_events_outlined,
                color: Colors.deepPurple,
                bgColor: Color(0xFFF3E6FA),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
            height: double.infinity,
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
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
                      overrideStyle: TextStyle(fontSize: 14),
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
