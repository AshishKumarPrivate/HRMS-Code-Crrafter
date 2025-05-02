import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/employee/controller/employee_api_provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/employee_detail_screen.dart';
import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:provider/provider.dart';

import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/common_widget/default_common_app_bar.dart';
import '../../../util/responsive_helper_util.dart';
import '../model/employee_list_model.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch employee list when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeApiProvider>(
        context,
        listen: false,
      ).getEmployeeList();
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
        activityName: "All Employee",
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<EmployeeApiProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return loadingIndicator();
          }
          if (provider.errorMessage.isNotEmpty) {
            return Center(child: Text(provider.errorMessage));
          }
          if (provider.filteredEmployees.isEmpty) {
            return const Center(child: Text('No employees found.'));
          }
          return RefreshIndicator(
            onRefresh: () => provider.refreshEmployeeList(),
            child: ListView.builder(
              itemCount: provider.filteredEmployees.length,
              itemBuilder: (context, index) {
                final employee = provider.filteredEmployees[index];
                return EmployeeListItem(employeData: employee, index: index,);
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

   EmployeeListItem({
    Key? key,
    required this.employeData,
    required this.index,
  }) : super(key: key);

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
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () async {
            print("Employee Detail ID: ${employeData.sId}", );
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => EmployeeDetailScreen(employeeId:  employeData.sId.toString()),
            //   ),
            // );
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmployeeDetailScreen(employeeId: employeData.sId.toString()),
              ),
            );

            // Only refresh if coming back to this screen (i.e., user didn't get redirected to AdminHome)
            // if (result == true) {
            //   Provider.of<EmployeeApiProvider>(context, listen: false).getEmployeeList();
            // }

          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 👤 Circular Image Placeholder
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: avatarBgColors[index % avatarBgColors.length],
                      // 👈 rotate colors
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: avatarBgColors[index %
                              avatarBgColors.length]
                          .withOpacity(0.6),
                      child: Icon(
                        Icons.person,
                        size: 28,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Employee Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${employeData.name}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              "Email: ",
                              style: AppTextStyles.bodyText1(
                                context,
                                overrideStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    12,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${employeData.email}",
                                style: AppTextStyles.bodyText1(
                                  context,
                                  overrideStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    fontSize: ResponsiveHelper.fontSize(
                                      context,
                                      12,
                                    ),
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              "Phone No:",
                              style: AppTextStyles.bodyText1(
                                context,
                                overrideStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "${employeData.mobile}",
                                style: AppTextStyles.bodyText1(
                                  context,
                                  overrideStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    fontSize: ResponsiveHelper.fontSize(
                                      context,
                                      12,
                                    ),
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
