import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/add_employee_screen.dart';
import '../bottom_navigation_screen.dart';
import '../ui_helper/app_text_styles.dart';
import '../ui_helper/common_widget/solid_rounded_button.dart';
import '../util/size_config.dart';
import 'auth/login_screen.dart';

class UserSelectionScreen extends StatelessWidget {
  const UserSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(
            top: 50,
            left: 15,
            right: 15,
            bottom: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            title: 'Attendance Management',
                            icon: Icons.badge_outlined,
                            color: Color(0xFFFFF2E3),
                          ),
                        ),
                        Expanded(
                          child: _InfoCard(
                            title: 'Employee Cost Savings',
                            icon: Icons.attach_money,
                            color: Color(0xFFE7F8EC),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 15,),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            title: 'Increase Your Workflow',
                            icon: Icons.bar_chart,
                            color: Color(0xFFEDEBFF),
                          ),
                        ),
                        Expanded(
                          child: _InfoCard(
                            title: 'Enhanced Data Accuracy',
                            icon: Icons.flash_on,
                            color: Color(0xFFF1F4F8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Reduce the workloads of HR management.',
                      style: AppTextStyles.heading1(
                        context,
                        overrideStyle: TextStyle(height: 1.5, fontSize: 22),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Help you to improve efficiency, accuracy, engagement, and cost savings for employers.',
                      style: AppTextStyles.bodyText3(
                        context,
                        overrideStyle: TextStyle(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  CustomButton(
                    text: "I'm an Employee",
                    textColor: Colors.black,
                    type: ButtonType.outlined,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: "I'm a HR",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEmployeeScreen(),
                        ),
                      );
                      // Navigate to Employee Flow
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;

  const _InfoCard({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Colors.black87),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.heading3(context)),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: AppTextStyles.heading3(context)
              ),
            ],
          ],
        ),
      ),
    );
  }
}
