import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/employee/controller/employee_api_provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/bank_module/add_employee_bank_detail_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/bank_module/employee_bank_detail_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/update_employee_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/work_module/add_employee_work_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/work_module/employee_work_detail_screen.dart';
import 'package:hrms_management_code_crafter/util/date_formate_util.dart';
import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';
import 'package:hrms_management_code_crafter/util/string_utils.dart';
import 'package:provider/provider.dart';

import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/common_widget/default_common_app_bar.dart';
import '../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../util/responsive_helper_util.dart';
import '../model/employee_list_model.dart';
import 'emp_document_module/add_employee_documents_screen.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final String employeeId;

  const EmployeeDetailScreen({Key? key, required this.employeeId})
    : super(key: key);

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, dynamic>> _tabs = [
    {"name": "Personal Information", "icon": Icons.person},
    // {"name": "Address Details", "icon": Icons.home_outlined},
    {"name": "Work Details", "icon": Icons.work_history_outlined},
    {"name": "Bank Details", "icon": Icons.account_balance},
    {"name": "Add Documents", "icon": Icons.file_download_outlined},
  ];

  @override
  void initState() {
    print("EmployeeiddforFilter${widget.employeeId}");
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployeeApiProvider>(
        context,
        listen: false,
      ).getEmployeeDetail(widget.employeeId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        activityName: "Profile",
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: AppColors.primary,
            child: TabBar(
              tabAlignment: TabAlignment.start,
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.white.withOpacity(0.7),
              indicatorColor: AppColors.white,
              indicatorWeight: 4.0,
              labelStyle: AppTextStyles.heading1(
                context,
                overrideStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              unselectedLabelStyle: AppTextStyles.heading1(
                context,
                overrideStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              tabs:
                  _tabs
                      .map((tab) => Row(children: [Tab(text: tab["name"])]))
                      .toList(),
            ),
          ),
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(_tabs.length, (index) {
                // Return different widgets based on the tab name
                // Use a single if-else if-else or switch statement
                switch (index) {
                  case 0: // Personal Information
                    return Stack(
                      children: [
                        // Curved header
                        ClipPath(
                          clipper: TopWaveClipper(),
                          child: Container(
                            height: 30,
                            color: Colors.transparent,
                          ),
                        ),
                        SafeArea(
                          child: Consumer<EmployeeApiProvider>(
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: ResponsiveHelper.fontSize(
                                          context,
                                          12,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              final employee =  provider.employeeListDetailModel?.data;
                              if (employee != null) {
                                StorageHelper().saveEmployeeData(employee);
                                StorageHelper().setEmpLoginWorkId(employee!.workId!.sId!);

                              }

                              if (employee == null) {
                                return Center(
                                  child: Text(
                                    'No employee details found.',
                                    style: AppTextStyles.heading2(
                                      context,
                                      overrideStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: ResponsiveHelper.fontSize(
                                          context,
                                          12,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return RefreshIndicator(
                                onRefresh:
                                    () => provider.getEmployeeDetail(
                                      widget.employeeId,
                                    ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            0,
                                          ),
                                          // boxShadow: [
                                          //   BoxShadow(
                                          //     color: Colors.black12,
                                          //     blurRadius: 10,
                                          //     offset: Offset(0, 4),
                                          //   ),
                                          // ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              // Header section
                                              SizedBox(width: 10),
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      avatarBgColors[index %
                                                          avatarBgColors
                                                              .length],
                                                  // 👈 rotate colors
                                                  shape: BoxShape.circle,
                                                ),
                                                child: CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor: Colors.white,
                                                  backgroundImage:
                                                      (employee
                                                                      .employeeImage!
                                                                      .secureUrl !=
                                                                  null &&
                                                              employee
                                                                  .employeeImage!
                                                                  .secureUrl!
                                                                  .isNotEmpty)
                                                          ? NetworkImage(
                                                            employee
                                                                .employeeImage!
                                                                .secureUrl!,
                                                          )
                                                          : null,
                                                  // fallback tab null
                                                  child:
                                                      (employee
                                                                      .employeeImage!
                                                                      .secureUrl ==
                                                                  null ||
                                                              employee
                                                                  .employeeImage!
                                                                  .secureUrl!
                                                                  .isEmpty)
                                                          ? Icon(
                                                            Icons.person,
                                                            size: 45,
                                                            color: Colors.grey,
                                                          )
                                                          : null, // agar image hai toh child null
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      employee.name ?? 'N/A',
                                                      style:
                                                          AppTextStyles.heading3(
                                                            context,
                                                            overrideStyle:
                                                                TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                          ),
                                                    ),
                                                    Text(
                                                      employee.email ?? 'N/A',
                                                      style:
                                                          AppTextStyles.bodyText3(
                                                            context,
                                                            overrideStyle:
                                                                TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                  fontSize: 14,
                                                                ),
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // Card with info icons
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Text(
                                              "Personal Details",
                                              style: AppTextStyles.heading3(
                                                context,
                                                overrideStyle: TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            _ProfileField(
                                              label: "Phone",
                                              value:
                                                  (employee.mobile != null &&
                                                          employee.mobile!
                                                              .trim()
                                                              .isNotEmpty)
                                                      ? employee.mobile!
                                                      : "-",
                                            ),

                                            _ProfileField(
                                              label: "Gender",
                                              value:
                                                  (employee.gender != null &&
                                                          employee.gender!
                                                              .trim()
                                                              .isNotEmpty)
                                                      ? StringUtils.capitalizeFirstLetter(
                                                        employee.gender!
                                                            .toString(),
                                                      )
                                                      : "-",
                                            ),

                                            _ProfileField(
                                              label: "Date of Birth",
                                              value:
                                                  (employee.dob != null &&
                                                          employee.dob!
                                                              .trim()
                                                              .isNotEmpty)
                                                      ? DateFormatter.formatCustomDdMmYyyy(
                                                        employee.dob.toString(),
                                                      )
                                                      : "-",
                                            ),

                                            _ProfileField(
                                              label: "Marital Status",
                                              value:
                                                  (employee.maritalStatus !=
                                                              null &&
                                                          employee
                                                              .maritalStatus!
                                                              .trim()
                                                              .isNotEmpty)
                                                      ? StringUtils.capitalizeFirstLetter(
                                                        employee.maritalStatus!
                                                            .toString(),
                                                      )
                                                      : "-",
                                            ),

                                            _ProfileField(
                                              label: "Qualification",
                                              value:
                                                  (employee.qualification !=
                                                              null &&
                                                          employee
                                                              .qualification!
                                                              .trim()
                                                              .isNotEmpty)
                                                      ? StringUtils.toUpperCase(
                                                        employee.qualification!
                                                            .toString(),
                                                      )
                                                      : "-",
                                            ),

                                            _ProfileField(
                                              label: "State",
                                              value:
                                                  (employee.state != null &&
                                                          employee.state!
                                                              .trim()
                                                              .isNotEmpty)
                                                      ? StringUtils.capitalizeFirstLetter(
                                                        employee.state!
                                                            .toString(),
                                                      )
                                                      : "-",
                                            ),

                                            _ProfileField(
                                              label: "City",
                                              value:
                                                  (employee.city != null &&
                                                          employee.city!
                                                              .trim()
                                                              .isNotEmpty)
                                                      ? StringUtils.capitalizeFirstLetter(
                                                        employee.city!
                                                            .toString(),
                                                      )
                                                      : "-",
                                            ),

                                            _ProfileField(
                                              label: "Address",
                                              value:
                                                  (employee.address != null &&
                                                          employee.address
                                                              .toString()
                                                              .trim()
                                                              .isNotEmpty)
                                                      ? StringUtils.capitalizeEachWord(
                                                        employee.address
                                                            .toString(),
                                                      )
                                                      : "-",
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // Details section
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Text(
                                              "Official Details",
                                              style: AppTextStyles.heading3(
                                                context,
                                                overrideStyle: TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            _ProfileField(
                                              label: "User Id",
                                              value: employee.empId ?? 'N/A',
                                            ),
                                            _ProfileField(
                                              label: "Work Email",
                                              value:
                                                  employee.workEmail ?? 'N/A',
                                            ),

                                            // _ProfileField(
                                            //   label: "Experience",
                                            //   value: "${employee.experience} yrs" ?? 'N/A',
                                            // ),
                                            _ProfileField(
                                              label: "Role",
                                              value:
                                                  (employee.role != null &&
                                                          employee.role
                                                              .toString()
                                                              .trim()
                                                              .isNotEmpty)
                                                      ? StringUtils.capitalizeFirstLetter(
                                                        employee.role
                                                            .toString(),
                                                      )
                                                      : "-",
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // const SizedBox(height: 20),
                                      // Details section
                                      if (employee.workId?.company != null)
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 10),
                                              Text(
                                                "Your Company Details",
                                                style: AppTextStyles.heading3(
                                                  context,
                                                  overrideStyle: TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              _ProfileField(
                                                label: "Name",
                                                value:
                                                    (employee.workId?.company !=
                                                                null &&
                                                            employee
                                                                .workId!
                                                                .company
                                                                .toString()
                                                                .trim()
                                                                .isNotEmpty)
                                                        ? StringUtils.capitalizeFirstLetter(
                                                          employee
                                                              .workId!
                                                              .company!
                                                              .toString()
                                                              .trim(),
                                                        )
                                                        : "-",
                                              ),

                                              _ProfileField(
                                                label: "Department",
                                                value:
                                                    (employee.workId?.department !=
                                                                null &&
                                                            employee
                                                                .workId!
                                                                .department
                                                                .toString()
                                                                .trim()
                                                                .isNotEmpty)
                                                        ? StringUtils.toUpperCase(
                                                          employee
                                                              .workId!
                                                              .department!
                                                              .toString()
                                                              .trim(),
                                                        )
                                                        : "-",
                                              ),

                                              _ProfileField(
                                                label: "Position",
                                                value:
                                                    (employee.workId?.jobPosition !=
                                                                null &&
                                                            employee
                                                                .workId!
                                                                .jobPosition
                                                                .toString()
                                                                .trim()
                                                                .isNotEmpty)
                                                        ? StringUtils.capitalizeEachWord(
                                                          employee
                                                              .workId!
                                                              .jobPosition!
                                                              .toString()
                                                              .trim(),
                                                        )
                                                        : "-",
                                              ),

                                              _ProfileField(
                                                label: "Joining Date",
                                                value:
                                                    (employee.workId?.joiningDate !=
                                                                null &&
                                                            employee
                                                                .workId!
                                                                .joiningDate
                                                                .toString()
                                                                .trim()
                                                                .isNotEmpty)
                                                        ? DateFormatter.formatToLongDate(
                                                          employee
                                                              .workId
                                                              ?.joiningDate
                                                              .toString()
                                                              .trim(),
                                                        )
                                                        : "-",
                                              ),

                                              _ProfileField(
                                                label: "Reporting To",
                                                value:
                                                    (employee.workId?.reportingManager !=
                                                                null &&
                                                            employee
                                                                .workId!
                                                                .reportingManager
                                                                .toString()
                                                                .trim()
                                                                .isNotEmpty)
                                                        ? StringUtils.capitalizeEachWord(
                                                          employee
                                                              .workId!
                                                              .reportingManager!
                                                              .toString()
                                                              .trim(),
                                                        )
                                                        : "-",
                                              ),

                                              _ProfileField(
                                                label: "Your Salary",
                                                value:
                                                    (employee.workId?.salary !=
                                                                null &&
                                                            employee
                                                                .workId!
                                                                .salary
                                                                .toString()
                                                                .trim()
                                                                .isNotEmpty)
                                                        ? "₹ ${StringUtils.capitalizeEachWord(employee.workId!.salary!.toString().trim())}/-"
                                                        : "-",
                                              ),

                                              _ProfileField(
                                                label: "Employment Type",
                                                value:
                                                    (employee.workId?.shipInformation !=
                                                                null &&
                                                            employee
                                                                .workId!
                                                                .shipInformation
                                                                .toString()
                                                                .trim()
                                                                .isNotEmpty)
                                                        ? StringUtils.capitalizeEachWord(
                                                          employee
                                                              .workId!
                                                              .shipInformation!
                                                              .toString()
                                                              .trim(),
                                                        )
                                                        : "-",
                                              ),

                                              _ProfileField(
                                                label: "Work Type",
                                                value:
                                                    (employee.workId?.workType !=
                                                                null &&
                                                            employee
                                                                .workId!
                                                                .workType
                                                                .toString()
                                                                .trim()
                                                                .isNotEmpty)
                                                        ? StringUtils.capitalizeEachWord(
                                                          employee
                                                              .workId!
                                                              .workType!
                                                              .toString()
                                                              .trim(),
                                                        )
                                                        : "-",
                                              ),

                                              _ProfileField(
                                                label: "Work Location",
                                                value:
                                                    (employee.workId?.workLocation !=
                                                                null &&
                                                            employee
                                                                .workId!
                                                                .workLocation
                                                                .toString()
                                                                .trim()
                                                                .isNotEmpty)
                                                        ? StringUtils.capitalizeEachWord(
                                                          employee
                                                              .workId!
                                                              .workLocation!
                                                              .toString()
                                                              .trim(),
                                                        )
                                                        : "-",
                                              ),
                                            ],
                                          ),
                                        ),

                                      const SizedBox(height: 20),
                                      // Update button
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: CustomButton(
                                          text: "Update Profile",
                                          textColor: Colors.black,
                                          type: ButtonType.outlined,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        UpdateEmployeeScreen(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      const SizedBox(height: 15),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: CustomButton(
                                          text: "Delete Employee",
                                          color: Colors.red,
                                          onPressed: () {
                                            showDeleteBottomSheet(
                                              context,
                                              widget.employeeId,
                                            );
                                            // Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                    ),
                                                child: CustomButton(
                                                  text: "🏦 Bank Details",
                                                  textStyle:
                                                      AppTextStyles.bodyText1(
                                                        context,
                                                        overrideStyle:
                                                            new TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10,
                                                            ),
                                                      ),
                                                  textColor: Colors.black,
                                                  type: ButtonType.outlined,
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                EmpBankDetailScreen(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                    ),
                                                child: CustomButton(
                                                  text: "👔 Work Details",
                                                  textColor: Colors.black,
                                                  type: ButtonType.outlined,
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                EmpWorkDetailScreen(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(
                                      //     horizontal: 8.0,
                                      //   ),
                                      //   child: Row(
                                      //     children: [
                                      //       Expanded(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.symmetric(
                                      //                 horizontal: 10,
                                      //               ),
                                      //           child: CustomButton(
                                      //             text: "👔 Add Work",
                                      //             textColor: Colors.black,
                                      //             type: ButtonType.outlined,
                                      //             onPressed: () {
                                      //               Navigator.push(
                                      //                 context,
                                      //                 MaterialPageRoute(
                                      //                   builder:
                                      //                       (context) =>
                                      //                           AddEmployeeWorkScreen(),
                                      //                 ),
                                      //               );
                                      //             },
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       Expanded(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.symmetric(
                                      //                 horizontal: 10,
                                      //               ),
                                      //           child: CustomButton(
                                      //             text: "👔 Work Details",
                                      //             textColor: Colors.black,
                                      //             type: ButtonType.outlined,
                                      //             onPressed: () {
                                      //               Navigator.push(
                                      //                 context,
                                      //                 MaterialPageRoute(
                                      //                   builder:
                                      //                       (context) =>
                                      //                           EmpWorkDetailScreen(),
                                      //                 ),
                                      //               );
                                      //             },
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      //
                                      // const SizedBox(height: 15),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  case 1: // Address Details
                    return const AddEmployeeWorkScreen();
                  case 2: // Address Details
                    return AddEmployeeBankDetailScreen();
                  case 3: // Address Details
                    return AddEmpDocumentUploadWidget(empId: widget.employeeId);
                  default:
                    return AddEmployeeWorkScreen();
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}

void showDeleteBottomSheet(BuildContext context, String employeeId) {
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
                      "Confirmation For Delete Employee",
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
                      "Are you sure you would like to delete this employee",
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
                    print("idd=>${employeeId}");
                    Provider.of<EmployeeApiProvider>(
                      context,
                      listen: false,
                    ).deleteEmployee(context, employeeId);
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
                    "Delete",
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
  final IconData? icon;
  final String title;
  final String value;

  const _InfoItem({this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon != null
            ? CircleAvatar(
              backgroundColor: Colors.blue.shade50,
              child: Icon(icon, color: AppColors.primary),
            )
            : SizedBox.shrink(),
        const SizedBox(height: 8),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.heading3(
              context,
              overrideStyle: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyText3(
              context,
              overrideStyle: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
