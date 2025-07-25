import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';import 'package:hrms_management_code_crafter/screen/nav_home/controller/punch_in_out_provider.dart';
import 'package:hrms_management_code_crafter/util/date_formate_util.dart';
import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';
import 'package:hrms_management_code_crafter/util/string_utils.dart';
import 'package:provider/provider.dart';

import '../../../admin/employee/screen/work_module/update_employee_work_details_screen.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../util/responsive_helper_util.dart';
import '../../auth/controller/auth_provider.dart';

class EmployeeSingleProfileDetailScreen extends StatefulWidget {
  // final String employeeId;
  //
  // const EmployeeSingleProfileDetailScreen({Key? key, required this.employeeId})
  //   : super(key: key);

  @override
  State<EmployeeSingleProfileDetailScreen> createState() =>
      _EmployeeSingleProfileDetailScreenState();
}

class _EmployeeSingleProfileDetailScreenState
    extends State<EmployeeSingleProfileDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PunchInOutProvider>(
        context,
        listen: false,
      ).empSingleProfile(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBgColor,
      body: Stack(
        children: [
          // Curved header
          ClipPath(
            clipper: TopWaveClipper(),
            child: Container(height: 350, color: AppColors.primary),
          ),
          SafeArea(
            child: Consumer<PunchInOutProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return loadingIndicator();
                }
                if (provider.errorMessage.isNotEmpty) {
                  return Center(child: Text(provider.errorMessage, style: AppTextStyles.heading2(
                    context,
                    overrideStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.fontSize(context, 12),
                    ),
                  ),));
                }
                final employee = provider.empSingleProfileDetailModel?.data;

                if (employee?.workId?.sId != null) {
                  StorageHelper().setEmpLoginWorkId(employee!.workId!.sId!);
                }

                if (employee == null) {
                  return  Center(
                    child: Text('No employee details found.', style: AppTextStyles.heading2(
                      context,
                      overrideStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => provider.empSingleProfile(context),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Header section
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            children: [
                              // SizedBox(height: 15,),
                              Container(
                                padding: const EdgeInsets.all(
                                  4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  // 👈 rotate colors
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.pink,
                                  backgroundImage: (employee.employeeImage!.secureUrl != null &&
                                      employee.employeeImage!.secureUrl!.isNotEmpty)
                                      ? NetworkImage(employee.employeeImage!.secureUrl!)
                                      : null, // fallback tab null
                                  child: (employee.employeeImage!.secureUrl == null ||
                                      employee.employeeImage!.secureUrl!.isEmpty)
                                      ? Icon(Icons.person, size: 45, color: Colors.grey)
                                      : null, // agar image hai toh child null
                                ),
                              ),

                              const SizedBox(height: 10),
                              Text(
                                employee.name ?? 'N/A',
                                style: AppTextStyles.heading3(
                                  context,
                                  overrideStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                              Text(
                                employee.email ?? 'N/A',
                                style: AppTextStyles.bodyText3(
                                  context,
                                  overrideStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Card with info icons
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _InfoItem(
                                icon: Icons.phone_android,
                                title: "Phone",
                                value: employee.mobile ?? 'N/A',
                              ),
                              _InfoItem(
                                icon: Icons.person_outline,
                                title: "Profile",
                                value:
                                    StringUtils.capitalizeFirstLetter(
                                      employee.role!.toString(),
                                    ) ??
                                    'N/A',
                              ),
                              _InfoItem(
                                icon: Icons.group,
                                title: "DOB",
                                value:
                                    "${DateFormatter.formatCustomDdMmYyyy(employee.dob)}",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Details section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _ProfileField(
                                label: "User Id",
                                value: employee.sId ?? 'N/A',
                              ),
                              _ProfileField(
                                label: "Work Email",
                                value: employee.workEmail ?? 'N/A',
                              ),

                              _ProfileField(
                                label: "State",
                                value: employee.state ?? 'N/A',
                              ),
                              _ProfileField(
                                label: "City",
                                value: employee.city ?? 'N/A',
                              ),
                              _ProfileField(
                                label: "Address",
                                value: employee.address ?? 'N/A',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        if(employee.workId != null )

                           Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                            //   child: Text(
                            //     "Work Details",
                            //     style: AppTextStyles.heading2(
                            //       context,
                            //       overrideStyle: TextStyle(
                            //         fontSize: ResponsiveHelper.fontSize(
                            //           context,
                            //           14,
                            //         ),
                            //         color: AppColors.primary
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0.0,vertical: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Work Details",
                                          style: AppTextStyles.heading2(
                                            context,
                                            overrideStyle: TextStyle(
                                                fontSize: ResponsiveHelper.fontSize(
                                                  context,
                                                  14,
                                                ),
                                                color: AppColors.primary
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                    UpdateEmployeeWorkDetailsScreen(
                                                      workDetail: null,
                                                      isEmployeeLogin: true,
                                                      workId:employee .workId! .sId ,
                                                      companyName:  employee .workId! .company,
                                                      department:employee .workId! .department ,
                                                      shiftInformation:employee .workId! .shiftInformation ,
                                                      jobPosition:employee .workId! .jobPosition ,
                                                      reportingManger:employee .workId! .reportingManager ,
                                                      salary:employee .workId! .salary ,
                                                      joiningDate:employee .workId! .joiningDate ,
                                                      workLocation:employee .workId! .workLocation ,
                                                      workType:employee .workId! .workType ,
                                                    ),
                                              ),
                                            );

                                          },
                                          child: const Icon(
                                            Icons.edit,
                                            color: AppColors.primary,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _ProfileField(
                                    label: "Company",
                                    value: employee.workId!.company ?? 'N/A',
                                  ),
                                  _ProfileField(
                                    label: "Department",
                                    value: employee.workId!.department ?? 'N/A',
                                  ),

                                  _ProfileField(
                                    label: "Position",
                                    value: employee.workId!.jobPosition ?? 'N/A',
                                  ),
                                  _ProfileField(
                                    label: "Salary",
                                    value: "₹ ${employee.workId!.salary ?? "N/A"}/-" ?? 'N/A',
                                  ),
                                  _ProfileField(
                                    label: "Work Location",
                                    value: employee.workId!.workLocation ?? 'N/A',
                                  ),
                                  _ProfileField(
                                    label: "Work Shift",
                                    value: employee.workId!.shiftInformation ?? 'N/A',
                                  ),
                                  _ProfileField(
                                    label: "Reporting To",
                                    value: employee.workId!.reportingManager ?? 'N/A',
                                  ),
                                  _ProfileField(
                                    label: "Work Type",
                                    value: employee.workId!.workType ?? 'N/A',
                                  ),
                                  _ProfileField(
                                    label: "Joining Date",
                                    value: "${DateFormatter.formatToShortMonth(employee.workId!.joiningDate)}" ?? 'N/A',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        if(employee.bankId != null )
                           Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                              child: Text(
                                "Bank Details",
                                style: AppTextStyles.heading2(
                                  context,
                                  overrideStyle: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(
                                        context,
                                        14,
                                      ),
                                      color: AppColors.primary
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _ProfileField(
                                    label: "Name",
                                    value: employee.bankId!.bankName ?? 'N/A',
                                  ),
                                  _ProfileField(
                                    label: "Account No",
                                    value: employee.bankId!.accountNumber ?? 'N/A',
                                  ),

                                  _ProfileField(
                                    label: "IFSC Code",
                                    value: employee.bankId!.ifscCode ?? 'N/A',
                                  ),
                                  _ProfileField(
                                    label: "Branch Name",
                                    value: "${employee.bankId!.branch ?? "N/A"}" ?? 'N/A',
                                  ),
                                  _ProfileField(
                                    label: "Bank Code",
                                    value: employee.bankId!.bankCode ?? 'N/A',
                                  ),
                                  _ProfileField(
                                    label: "Bank Address",
                                    value: employee.bankId!.bankAddress ?? 'N/A',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Update button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomButton(
                            text: "Logout",
                            textColor: Colors.red,
                            type: ButtonType.outlined,
                            borderColor: Colors.red,
                            onPressed: () {
                              showLogoutBottomSheet(context);
                            },
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// **Red Warning Icon**
            Container(width: 100, height: 5, color: Colors.grey[400]),

            Container(
              width: double.infinity,
              // color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 10),

                    /// **Sign Out Text**
                    Text(
                      "Sign out from Account",
                      style: AppTextStyles.bodyText1(
                        context,
                        overrideStyle: new TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// **Confirmation Message**
                    Text(
                      "Are you sure you would like to Logout of your Account",
                      textAlign: TextAlign.start,
                      style: AppTextStyles.bodyText1(
                        context,
                        overrideStyle: new TextStyle(
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

            /// **Cancel & Logout Buttons**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// **Cancel Button**
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightBrown_color,
                    // Light background
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
                      overrideStyle: new TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                /// **Logout Button**
                ElevatedButton(
                  onPressed: () async {
                    Provider.of<AuthAPIProvider>(
                      context,
                      listen: false,
                    ).logoutUser(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Orange button
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
                      overrideStyle: new TextStyle(
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
      );
    },
  );
}

// ClipPath for the curved wave
class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color:AppColors.primary),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: AppTextStyles.heading2(
            context,
            overrideStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.fontSize(context, 9),
            ),
          ),
        ),
        Text(value, style: AppTextStyles.heading1(
          context,
          overrideStyle: TextStyle(
            fontSize: ResponsiveHelper.fontSize(context, 12),
          ),
        ),),
      ],
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.heading3(
                context,
                overrideStyle: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.bodyText3(
                context,
                overrideStyle: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
