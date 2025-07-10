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
  DateTime? startDate;
  DateTime? endDate;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  late DateTime now;

  @override
  void initState() {
    super.initState();
    // loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _filterByMonthYear(); // Load current month data
    });
  }

  void loadData() {
    now = DateTime.now();
    // startDate = now; // First day of current month
    startDate = DateTime(now.year, now.month, 1);
    endDate = now; // Today's date
    // Fetch employee list when screen opens
    final String formattedStartDate =
        "${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}";
    final String formattedEndDate =
        "${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminEmpSalarySlipApiProvider>(
        context,
        listen: false,
      ).getAllSalarySlipList(
        startDate: formattedStartDate,
        endDate: formattedEndDate,
      );
    });
  }

  void _filterByMonthYear() {
    setState(() {
      startDate = DateTime(selectedYear, selectedMonth, 1);
      endDate = DateTime( selectedYear,  selectedMonth + 1,  0, ); // Last day of selected month
      final String formattedStartDate =
          "${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}";
      final String formattedEndDate =
          "${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}";

      Provider.of<AdminEmpSalarySlipApiProvider>(context, listen: false)
          .getAllSalarySlipList(
        startDate: formattedStartDate,
        endDate: formattedEndDate,
      );


    });
    // loadData();
  }

  Future<void> _pickStartDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: endDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
        if (endDate != null && picked.isAfter(endDate!)) {
          endDate = null;
        }
        loadData(); // Reload data with new start date
      });
    }
  }

  Future<void> _pickEndDate() async {
    DateTime initialDate = endDate ?? DateTime.now();
    DateTime firstDate = startDate ?? DateTime(2000);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        endDate = picked;
        if (startDate != null && picked.isBefore(startDate!)) {
          startDate = null;
        }
        loadData(); // Reload data with new end date
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _clearDateFilters() {
    setState(() {
      now = DateTime.now();
      selectedMonth = now.month;
      selectedYear = now.year;
      startDate = DateTime(now.year, now.month, 1);
      endDate = now;
      loadData();
    });
  }

  static String getMonthName(int month) {
    const List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
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

      // appBar: DefaultCommonAppBar(
      //   activityName: "All Employee Salary Slip",
      //   backgroundColor: AppColors.primary,
      // ),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        // Set AppBar background color
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Back button
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
        title: Text(
          'All Employee Salary Slip',
          style: AppTextStyles.heading1(
            context,
            overrideStyle: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(context, 14),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // const SizedBox(height: 5),
              // 🔽 Month and Year Dropdowns in a Row
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: selectedMonth,
                        dropdownColor: Colors.white,
                        iconEnabledColor: Colors.white,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ResponsiveHelper.fontSize(context, 14),
                        ),
                        // Text style for selected item
                        decoration: InputDecoration(
                          labelText: "Month",
                          labelStyle: const TextStyle(color: Colors.white),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          // Smaller padding
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1,
                            ), // White border
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1,
                            ), // Thicker border when focused
                          ),
                          filled: true,
                          fillColor: Colors .transparent, // Transparent background to show primary color
                        ),
                        selectedItemBuilder: (BuildContext context) {
                          return List.generate(12, (index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              // decoration: BoxDecoration(
                              //   color: Colors.white.withOpacity(0.2),
                              //   borderRadius: BorderRadius.circular(6),
                              // ),
                              child: Text(
                                getMonthName(index + 1),
                                style: const TextStyle(color: Colors.white), // Selected item white
                              ),
                            );
                          });
                        },

                        items: List.generate(12, (index) {
                          return DropdownMenuItem(
                            value: index + 1,
                            child: Text(
                              getMonthName(index + 1),
                              // style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              selectedMonth = val;
                              _filterByMonthYear();
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: selectedYear,
                        dropdownColor: Colors.white,
                        iconEnabledColor: Colors.white,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ResponsiveHelper.fontSize(context, 14),
                        ),
                        // Text style for selected item
                        decoration: InputDecoration(
                          labelText: "Year",
                          labelStyle: const TextStyle(color: Colors.white70),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        selectedItemBuilder: (BuildContext context) {
                          return List.generate(5, (index){
                            int year = DateTime.now().year - index;
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              // decoration: BoxDecoration(
                              //   color: Colors.white.withOpacity(0.2),
                              //   borderRadius: BorderRadius.circular(6),
                              // ),
                              child: Text(
                                "$year",
                                style: const TextStyle(color: Colors.white), // Selected item white
                              ),
                            );
                          });
                        },
                        items: List.generate(5, (index) {
                          int year = DateTime.now().year - index;
                          return DropdownMenuItem(
                            value: year,
                            child: Text(
                              "$year",
                              // style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              selectedYear = val;
                              _filterByMonthYear();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Space between dropdowns and date pickers
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _pickStartDate,
                        style: OutlinedButton.styleFrom(
                          // backgroundColor: AppColors.white, // Still want white background
                          foregroundColor: AppColors.primary,
                          // Text color
                          side: const BorderSide(color: AppColors.white),
                          // Add a border with primary color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 1),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Start Date',
                              style: AppTextStyles.heading1(
                                context,
                                overrideStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    12,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${_formatDate(startDate)}',
                              style: AppTextStyles.heading1(
                                context,
                                overrideStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _pickEndDate,
                        style: OutlinedButton.styleFrom(
                          // backgroundColor: AppColors.white, // Still want white background
                          foregroundColor: AppColors.primary,
                          // Text color
                          side: const BorderSide(color: AppColors.white),
                          // Add a border with primary color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 1),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'End Date',
                              style: AppTextStyles.heading1(
                                context,
                                overrideStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    12,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${_formatDate(endDate)}',
                              style: AppTextStyles.heading1(
                                context,
                                overrideStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.white),
                      tooltip: 'Clear Date Filters',
                      onPressed: _clearDateFilters,
                    ),
                  ],
                ),
              ),

              // const SizedBox(height: 5),
            ],
          ),
        ),
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => CtcDetailScreen(employeData: employeData),
          //   ),
          // );
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
          child: Column(
            children: [
              Row(
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
              SizedBox(height: 10),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Salary Overview",
                            style: AppTextStyles.heading2(
                              context,
                              overrideStyle: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(
                                  context,
                                  14,
                                ),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF004658),
                              ),
                            ),
                          ),
                          Text(
                            employeData.month.toString(),
                            style: AppTextStyles.heading2(
                              context,
                              overrideStyle: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(
                                  context,
                                  12,
                                ),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF004658),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem(
                            context,
                            "Total Days",
                            employeData.totalWorkingDays.toString(),
                            "total_days",
                          ),
                          _buildStatItem(
                            context,
                            "Present",
                            employeData.presentDays.toString(),
                            "present",
                          ),
                          _buildStatItem(
                            context,
                            "Absent",
                            employeData.absentDays.toString(),
                            "absent",
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSalaryItem(
                            "Monthly Salary",
                            "₹${employeData.salary}",
                          ),
                          _buildSalaryItem(
                            "Estimated",
                            "₹${employeData.estimateSalary}",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String title,
    String value,
    String type,
  ) {
    Color color = AppColors.black;
    if (type == "present") color = Colors.green;
    if (type == "absent") color = Colors.red;

    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.heading3(
            context,
            overrideStyle: TextStyle(fontSize: 20, color: color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: AppTextStyles.bodyText3(
            context,
            overrideStyle: TextStyle(fontSize: 12, color: color),
          ),
        ),
      ],
    );
  }

  Widget _buildSalaryItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
      ],
    );
  }
}
