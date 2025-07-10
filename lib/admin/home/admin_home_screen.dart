import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/screen/add_company_profile_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/add_employee_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/employee_list_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/leave_module/emp__leaves_request_list_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/policy/add_company_policy_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/policy/policy_list_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/salary_slip/Admin_all_emp_salary_slip_list_screen.dart';
import 'package:hrms_management_code_crafter/admin/home/attendance/attandance_sheet_list_screen.dart';
import 'package:hrms_management_code_crafter/admin/home/widget/admin_service_card_widget.dart';
import 'package:hrms_management_code_crafter/ui_helper/app_colors.dart';
import 'package:hrms_management_code_crafter/ui_helper/app_text_styles.dart';
import 'package:hrms_management_code_crafter/util/image_loader_util.dart';
import 'package:hrms_management_code_crafter/util/responsive_helper_util.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../screen/auth/controller/auth_provider.dart';
import '../../util/string_utils.dart';
import '../announcement/model/cmp_announcement_model.dart';
import '../announcement/widget/announcement_slider_widgets.dart';
import '../company_profile/controller/comp_profile_api_provider.dart';
import '../company_profile/screen/view_cmp_profile_screen.dart';
import '../announcement/widget/announcement_tab_widget.dart';

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
          content: const Text("Press back again to exit the app"),
          duration: const Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  List<Announcement> companyAnnouncements = [
    Announcement(
      id: '001',
      title: 'Important System Maintenance',
      description:
          'Our systems will undergo scheduled maintenance on 25th July from 10 PM to 1 AM IST. Services may be intermittently unavailable during this period. We apologize for any inconvenience.',
    ),
    Announcement(
      id: '002',
      title: 'New HR Policy Update',
      description:
          'Please review the updated HR policy document available on the employee portal. Key changes include revised leave application procedures and remote work guidelines. Effective 1st August.',
    ),
    Announcement(
      id: '003',
      title: 'Company Picnic Rescheduled',
      description:
          'Due to unforeseen weather conditions, the annual company picnic has been rescheduled to 15th August. Further details regarding the venue and activities will be shared soon.',
    ),
    Announcement(
      id: '004',
      title: 'Quarterly Town Hall Meeting',
      description:
          'Join us for our Q3 Town Hall meeting on 5th September at 2 PM in the main auditorium. We\'ll discuss recent achievements, upcoming goals, and open floor for Q&A.',
    ),
    Announcement(
      id: '005',
      title: 'Mandatory Fire Safety Drill',
      description:
          'A mandatory fire safety drill will be conducted on 10th August at 11 AM. Please follow all instructions from the safety team during the drill.',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    double childAspectRatio;

    if (screenWidth < 600) {
      crossAxisCount = 4; // Reduced number of items per row
      childAspectRatio = 0.8; // Adjust aspect ratio for better fit
    } else if (screenWidth < 900) {
      crossAxisCount = 4;
      childAspectRatio = 0.9;
    } else {
      crossAxisCount = 5;
      childAspectRatio = 1.0;
    }
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        final shouldExit = await _onBackPressed();
        if (shouldExit) {
          SystemNavigator.pop();
        }

      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          toolbarHeight: 70,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TopProfileHeader(empEmail: "c", empName: 'xx'),
              ),
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          actions: [

          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // announcement slider
              AnnouncementSliderWidget(),
              Container(color: AppColors.lightBlueColor,height: 10,),
              SizedBox(height: 20),
              Text(
                "Employee Management",
                textAlign: TextAlign.center,
                style: AppTextStyles.heading1(
                  context,
                  overrideStyle: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(context, 12),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEmployeeScreen(),
                          ),
                        );
                      },
                      child:AdminServiceCardWidget(
                        title: 'Add\nEmployee',
                        icon: Icons.person,
                        color: Colors.deepPurple,
                      )
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddCompanyPolicyScreen(),
                          ),
                        );
                      },
                      child: const AdminServiceCardWidget(
                        title: 'Add\nPolicy',
                        icon: Icons.calculate,
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    EmpSalarySlipListScreen(), // Corrected name based on import
                          ),
                        );
                      },
                      child: const AdminServiceCardWidget(
                        title: 'Payroll Management',
                        icon: Icons.monetization_on,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                  Expanded(
                    child: const AdminServiceCardWidget(
                      title: 'File Management',
                      icon: Icons.folder,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmployeeListScreen(),
                          ),
                        );
                      },
                      child: const AdminServiceCardWidget(
                        title: 'All\nEmployee',
                        icon: Icons.people_alt_outlined,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PolicyListScreen(),
                          ),
                        );
                      },
                      child: const AdminServiceCardWidget(
                        title: 'View\nPolicy',
                        icon: Icons.description_outlined,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    EmployeeLeaveRequestListScreen(), // Corrected name based on import
                          ),
                        );
                      },
                      child: const AdminServiceCardWidget(
                        title: 'Leave\nRequest',
                        icon: Icons.notifications_active_outlined,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    AttendanceSheetTableScreen(), // Corrected name based on import
                          ),
                        );
                      },
                      child: const AdminServiceCardWidget(
                        title: 'Attendance Sheet',
                        icon: Icons.calendar_month_outlined,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Container(color: AppColors.lightBlueColor,height: 10,),
              const SizedBox(height: 20),
              Text(
                "Company Profile Management",
                textAlign: TextAlign.center,
                style: AppTextStyles.heading1(
                  context,
                  overrideStyle: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(context, 12),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddCompanyProfileScreen(),
                          ),
                        );
                      },
                      child: const AdminServiceCardWidget(
                        title: 'Add\nProfile',
                        icon: Icons.person,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Spacing between cards
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => AddCompanyPolicyScreen(),
                        //   ),
                        // );
                      },
                      child: Visibility(
                        visible: false,
                        child: const AdminServiceCardWidget(
                          title: 'Add\nPolicy',
                          icon: Icons.calculate,
                          color: Colors.pinkAccent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Spacing between cards
                  Expanded(
                    child: InkWell(
                      onTap: () {

                      },
                      child: Visibility(
                        visible: false,
                        child: const AdminServiceCardWidget(
                          title: 'Payroll Management',
                          icon: Icons.monetization_on,
                          color: Colors.cyan,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Spacing between cards
                  Expanded(
                    child: Visibility(
                      visible: false,
                      child: AdminServiceCardWidget(
                        title: 'File Management',
                        icon: Icons.folder,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(color: AppColors.lightBlueColor,height: 10,),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => EmpBankDetailScreen()),
                  // );
                },
                child: GestureDetector(
                  onTap: () {
                    showLogoutBottomSheet(context);
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
        builder:
            (innerContext) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Drag Handle
                  Container(width: 100, height: 5, color: Colors.grey[400]),

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
                            style: AppTextStyles.bodyText1(
                              context,
                              overrideStyle: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Are you sure you would like to logout of your Account",
                            style: AppTextStyles.bodyText1(
                              context,
                              overrideStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
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
                            horizontal: 40,
                            vertical: 0,
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: AppTextStyles.heading1(
                            context,
                            overrideStyle: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      // Logout Button
                      ElevatedButton(
                        onPressed: () {
                          print("Logout button clicked");
                          // Use the correct context with Provider
                          Provider.of<AuthAPIProvider>(
                            innerContext,
                            listen: false,
                          ).logoutUser(innerContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 0,
                          ),
                        ),
                        child: Text(
                          "Logout",
                          style: AppTextStyles.heading1(
                            context,
                            overrideStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
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

class TopProfileHeader extends StatelessWidget {
  final String empName;
  final String empEmail;

  const TopProfileHeader({
    Key? key,
    required this.empName,
    required this.empEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final companyProfileProvider = context.watch<CompanyProfileApiProvider>();
    final overview = companyProfileProvider.compProfileDataModel?.data?.overviewData;

    final companyName = overview?.companyName ?? "Company Name";
    final companyEmail = overview?.companyOfficialEmail ?? "email@example.com";
    final logoUrl = overview?.logo?.secureUrl;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Profile section
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompanyProfileScreen(),
                  ),
                );
              },
              child: ClipOval(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: logoUrl != null && logoUrl.isNotEmpty
                      ? ImageLoaderUtil.cacheNetworkImage(
                    logoUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    color: Colors.white,
                    child: const Icon(Icons.business, color: AppColors.primary),
                  ),
                ),
              ),


            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringUtils.capitalizeEachWord(companyName),
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
                  Text(
                    companyEmail,
                    style: AppTextStyles.bodyText3(
                      context,
                      overrideStyle: TextStyle(
                        color: AppColors.white,
                        fontSize: ResponsiveHelper.fontSize(context, 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      ],
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

