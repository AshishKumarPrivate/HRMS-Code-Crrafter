import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/employee/controller/employee_api_provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/employee_detail_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/salary_slip/model/payroll_salary_slip_list_admin_side_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/salary_slip/salary_detail_screen.dart';
import 'package:hrms_management_code_crafter/screen/nav_profile/screen/attandance_list_screen.dart';
import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/app_text_styles.dart';
import '../../../../ui_helper/common_widget/default_common_app_bar.dart';
import '../../../../util/responsive_helper_util.dart';
import '../../../../util/string_utils.dart';
import 'controller/admin_emp_salary_slip_api_provider.dart';

class EmpSalarySlipListScreen extends StatefulWidget {
  const EmpSalarySlipListScreen({super.key});

  @override
  State<EmpSalarySlipListScreen> createState() =>
      _EmpSalarySlipListScreenState();
}

class _EmpSalarySlipListScreenState extends State<EmpSalarySlipListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch employee list when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminEmpSalarySlipApiProvider>(
        context,
        listen: false,
      ).getAllSalarySlipList();
    });
  }

  final List<Color> avatarBgColors = [
    Colors.blue.shade50,
    Colors.green.shade50,
    Colors.pink.shade50,
    Colors.orange.shade50,
    Colors.purple.shade50,
    Colors.teal.shade50,
    Colors.amber.shade50,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBgColor,
      appBar: DefaultCommonAppBar(
        activityName: "All Employee Salary Slip",
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<AdminEmpSalarySlipApiProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return loadingIndicator();
          }
          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                provider.errorMessage,
                style: AppTextStyles.heading2(
                  context,
                  overrideStyle: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(context, 12),
                  ),
                ),
              ),
            );
          }
          final salaryList = provider.empSalarySlipListModel?.data;
          if (salaryList == null || salaryList.isEmpty) {
            return Center(
              child: Text(
                'No Data Found.',
                style: AppTextStyles.heading2(
                  context,
                  overrideStyle: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(context, 12),
                  ),
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => provider.refreshEmployeeList(),
            child: ListView.builder(
              itemCount: salaryList.length,
              itemBuilder: (context, index) {
                final employeesSalarySlips = salaryList[index];
                return EmployeeListItem(
                  employeData: employeesSalarySlips,
                  index: index,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class EmployeeListItem extends StatelessWidget {
  final Data employeData;
  final int index;

  EmployeeListItem({Key? key, required this.employeData, required this.index})
    : super(key: key);

  final List<Color> avatarBgColors = [
    Colors.blue.shade50,
    Colors.green.shade50,
    Colors.pink.shade50,
    Colors.orange.shade50,
    Colors.purple.shade50,
    Colors.teal.shade50,
    Colors.amber.shade50,
  ];

  @override
  Widget build(BuildContext context) {
    final bgColor = avatarBgColors[index % avatarBgColors.length];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CtcDetailScreen(employeData: employeData),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 Avatar
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, size: 40, color: Colors.grey),
              ),
              const SizedBox(width: 12),

              // 📝 Employee Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 👤 Name
                    Text(
                      StringUtils.capitalizeEachWord(
                        employeData.employeeName ?? "N/A",
                      ),
                      // employeData.employeeName ?? "N/A",
                      style: AppTextStyles.heading1(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // 📧 Email
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Email: ",
                          style: AppTextStyles.heading2(
                            context,
                            overrideStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            employeData.email ?? "N/A",
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyText1(
                              context,
                              overrideStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // 🗓️ Month and Salary
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
