import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/widgets/emp_attendance_chart_widget.dart';
import 'package:hrms_management_code_crafter/screen/emp_leave/screen/apply_emp_leave_screen.dart';
import 'package:hrms_management_code_crafter/screen/nav_home/controller/punch_in_out_provider.dart';
import 'package:hrms_management_code_crafter/screen/nav_home/screen/emp_documents_screen.dart';
import 'package:hrms_management_code_crafter/screen/nav_home/screen/salary_slip_emp_side_screen.dart';
import 'package:provider/provider.dart';
import '../../../admin/employee/screen/emp_document_module/add_employee_documents_screen.dart';
import '../../../admin/home/admin_home_screen.dart';
import '../../../firebase/FirebaseNotificationService.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../util/responsive_helper_util.dart';
import '../../../util/storage_util.dart';
import '../../nav_profile/screen/attandance_calender_view_screen.dart';
import '../../nav_profile/screen/attandance_list_screen.dart';
import '../../nav_profile/screen/emp_my_all_leaves_list_screen.dart';
import '../../nav_profile/widget/cell_profile_list_tile.dart';
import 'punch_in_out_screen.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  String? empLoginId;

  @override
  void initState() {
    super.initState();
    loadUserStorageData();
    NotificationService.initialize(context); // Initialize FCM
    // **Call the checkInStatus method here**
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<PunchInOutProvider>(context, listen: false).checkInStatus(context);
    // });
  }

  Future<void> loadUserStorageData() async {
    empLoginId = await StorageHelper().getEmpLoginId();
    setState(() {}); // Call setState to re-render after empLoginId is loaded
  }


  @override
  Widget build(BuildContext context) {
    // Calculate responsive crossAxisCount and childAspectRatio
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    double childAspectRatio;

    if (screenWidth < 600) { // Small screens (phones)
      crossAxisCount = 4; // Reduced number of items per row
      childAspectRatio = 0.8; // Adjust aspect ratio for better fit
    } else if (screenWidth < 900) { // Medium screens (tablets)
      crossAxisCount = 4;
      childAspectRatio = 0.9;
    } else { // Large screens (desktops/large tablets)
      crossAxisCount = 5;
      childAspectRatio = 1.0;
    }

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.lightBgColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 0,
              left: 0,
              right: 0,
              bottom: 10,
            ),
            child: Container(
              color: AppColors.lightBlueColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 20),
                  PunchInOutScreen(),
                  // const SizedBox(height: 10),
                  Container(color: AppColors.lightBlueColor,height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child:  Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Management",
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.heading2(
                                context,
                                overrideStyle: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(context, 14),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            GridView.count(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              crossAxisCount: crossAxisCount, // 4 items per row as per screenshot
                              crossAxisSpacing: 10, // Spacing between columns
                              mainAxisSpacing: 10, // Spacing between rows
                              shrinkWrap: true, // Important for GridView inside SingleChildScrollView
                              physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                              childAspectRatio: childAspectRatio,
                              children: [
                                ManagementGridItem(
                                  title: 'Attendance Calendar', // Use full text
                                  icon: Icons.calendar_month_outlined,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CalendarAttendanceScreen(
                                          employeeId: empLoginId.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                ManagementGridItem(
                                  title: 'My Leave Requests',
                                  icon: Icons.cake_outlined,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EmployeeLeaveListScreen(),
                                      ),
                                    );
                                  },
                                ),
                                ManagementGridItem(
                                  title: 'Apply For Leave',
                                  icon: Icons.description_outlined,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ApplyEmpLeaveScreen(),
                                      ),
                                    );
                                  },
                                ),
                                ManagementGridItem(
                                  title: 'Salary Slip',
                                  icon: Icons.money_outlined,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SalarySlipEmpSideScreen(),
                                      ),
                                    );
                                  },
                                ),
                                ManagementGridItem(
                                  title: 'Attendance List View',
                                  icon: Icons.calendar_month_outlined,
                                  onTap: () {
                                    // Handle Salary Slip tap
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AttendanceScreen(
                                          employeeId: empLoginId.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                ManagementGridItem(
                                  title: 'Your\nDocuments',
                                  icon: Icons.people_alt_outlined,
                                  onTap: () {
                                    // Handle My Team tap
                                    print("clik ");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EmpDocumentsScreen(empId: empLoginId.toString(),),
                                      ),
                                    );
                                    // AddEmpDocumentUploadWidget(empId: empLoginId.toString(),);
                                  },
                                ),
                                ManagementGridItem(
                                  title: 'Suggestions',
                                  icon: Icons.message_outlined,
                                  onTap: () {
                                    // Handle Suggestions tap
                                  },
                                ),
                                ManagementGridItem(
                                  title: 'Helpdesk',
                                  icon: Icons.headset_mic_outlined,
                                  onTap: () {
                                    // Handle Helpdesk tap
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(color: AppColors.lightBlueColor,height: 10,),
                  Container(
                    // width: double.infinity,
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


class ManagementGridItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const ManagementGridItem({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightBlueColor, // Light grey background
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              icon,
              color: AppColors.primary, // Darker icon color
              size: ResponsiveHelper.fontSize(context, 24),
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.heading3(
                context,
                overrideStyle: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(context, 10),
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}