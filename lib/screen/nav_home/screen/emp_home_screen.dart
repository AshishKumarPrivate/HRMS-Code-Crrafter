import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/widgets/emp_attendance_chart_widget.dart';
import 'package:hrms_management_code_crafter/screen/emp_leave/screen/apply_emp_leave_screen.dart';
import 'package:hrms_management_code_crafter/util/date_formate_util.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';
import 'package:hrms_management_code_crafter/util/string_utils.dart';
import 'package:provider/provider.dart';
import '../../../admin/home/admin_home_screen.dart';
import '../../../firebase/FirebaseNotificationService.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/theme/theme_provider.dart';
import '../../nav_profile/screen/attandance_list_screen.dart';
import '../../nav_profile/screen/emp_my_all_leaves_list_screen.dart';
import '../../nav_profile/widget/cell_profile_list_tile.dart';
import '../widget/Info_card.dart';
import 'punch_in_out_screen.dart';
import '../widget/activity_tile.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  String? empName, empEmail, empPhone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserStorageData();
  }

  Future<void> loadUserStorageData() async {
    String? name = await StorageHelper().getEmpLoginName();
    String? email = await StorageHelper().getEmpLoginEmail();
    String? phone = await StorageHelper().getEmpLoginMobile();

    // NotificationService.initialize(context); // Initialize FCM

    setState(() {
      empName = name ?? "UserName";
      empEmail = email ?? "eg@gmail.com";
      empPhone = phone ?? "91xxxxxxxx";
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.lightBgColor,
        body: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.only(
            top: 50,
            left: 15,
            right: 15,
            bottom: 10,
          ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, ${StringUtils.capitalizeEachWord(empName.toString())} 🤟",
                            style: AppTextStyles.heading3(context),
                          ),
                          // const SizedBox(height: 4),
                          Text(
                            "Email: ${empEmail.toString()},",
                            // "Today: ${DateFormatter.formatToShortMonth(DateTime.now().toString())},",
                            style: AppTextStyles.bodyText3(
                              context,
                              overrideStyle: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      // Switch(
                      //   value: isDark,
                      //   onChanged: (val) => themeProvider.toggleTheme(val),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  PunchInOutScreen(),
                  const SizedBox(height: 20),
                  // Text(
                  //   "Today's Activity",
                  //   style: AppTextStyles.heading3(context),
                  // ),
                  // const SizedBox(height: 10),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     InfoCard(
                  //       title: 'Check In',
                  //       time: '08:30 am',
                  //       subtitle: 'On time',
                  //       points: '+150 pt',
                  //       icon: Icons.login,
                  //       color: Colors.green,
                  //     ),
                  //     InfoCard(
                  //       title: 'Check Out',
                  //       time: '05:10 pm',
                  //       subtitle: 'On time',
                  //       points: '+100 pt',
                  //       icon: Icons.logout,
                  //       color: Colors.pink,
                  //     ),
                  //   ],
                  // ),
                  // // const SizedBox(height: 12),
                  // // Row(
                  // //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // //   children: const [
                  // //     InfoCard(
                  // //       title: 'Start Overtime',
                  // //       time: '06:01 pm',
                  // //       subtitle: 'Project revision from...',
                  // //       points: '',
                  // //       icon: Icons.alarm,
                  // //       color: Colors.deepPurple,
                  // //     ),
                  // //     InfoCard(
                  // //       title: 'Finish Overtime',
                  // //       time: '11:10 pm',
                  // //       subtitle: '5h 00m',
                  // //       points: '+\$120.00',
                  // //       icon: Icons.nightlight_round,
                  // //       color: Colors.orange,
                  // //     ),
                  // //   ],
                  // // ),
                  // const SizedBox(height: 20),
                  // Text(
                  //   "Recent Activity",
                  //   style: AppTextStyles.heading3(context),
                  // ),
                  const SizedBox(height: 10),
                  // const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplyEmpLeaveScreen(),
                        ),
                      );
                    },
                    child: const CustomListTile(
                      title: 'Apply Leave',
                      icon: Icons.people_alt_outlined,
                      color: Colors.lightBlue,
                      bgColor: Color(0xFFE6F0FA),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceScreen(),
                        ),
                      );
                    },
                    child: CustomListTile(
                      title: "Attendance",
                      icon: Icons.people_alt_outlined,
                      color: Colors.lightBlue,
                      bgColor: Color(0xFFE6F0FA),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ProfileListTile(
                    title: "Leave",
                    subtitle: "Check your Leave Request Status",
                    leadingIcon: Icons.event_busy,
                    backgroundColor: Colors.white,
                    borderRadius: 16,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmployeeLeaveListScreen(),
                        ),
                      );
                    },
                    titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    // height: 300, // or use MediaQuery to size it dynamically
                    child: const AttendanceChartWidget(),
                  ),
                  // const ActivityTile(
                  //   title: 'Check In',
                  //   date: '23 Feb 2023',
                  //   time: '09:15 am',
                  //   status: 'Late',
                  //   points: '+5 pt',
                  //   color: Colors.green,
                  // ),
                  // const ActivityTile(
                  //   title: 'Check Out',
                  //   date: '23 Feb 2023',
                  //   time: '05:02 pm',
                  //   status: 'Ontime',
                  //   points: '+100 pt',
                  //   color: Colors.pink,
                  // ),
                  // const ActivityTile(
                  //   title: 'Overtime',
                  //   date: '22 Feb 2023',
                  //   time: '06:01 - 10:59 pm',
                  //   status: '5h 30m',
                  //   points: '+\$120.00',
                  //   color: Colors.deepPurple,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
