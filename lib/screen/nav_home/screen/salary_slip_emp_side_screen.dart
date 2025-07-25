import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/screen/nav_home/model/emp_salary_slip_emp_side_model.dart';
import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/salary_slip/controller/admin_emp_salary_slip_api_provider.dart';
import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/app_text_styles.dart';
import '../../../util/responsive_helper_util.dart';
import '../../../util/storage_util.dart';

class SalarySlipEmpSideScreen extends StatefulWidget {
  const SalarySlipEmpSideScreen({super.key});

  @override
  State<SalarySlipEmpSideScreen> createState() =>
      _SalarySlipEmpSideScreenState();
}

class _SalarySlipEmpSideScreenState extends State<SalarySlipEmpSideScreen> {
  DateTime? startDate;
  DateTime? endDate;
  late DateTime now;
  String? employeeRegistrationId;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    startDate = DateTime(now.year, now.month, 1);
    endDate = now;
    loadSalarySlipData();
  }

  Future<void> loadSalarySlipData() async {
    employeeRegistrationId = await StorageHelper().getEmpLoginRegistrationId();
    if (employeeRegistrationId != null) {
      final String formattedStartDate =
          "${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}";
      final String formattedEndDate =
          "${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}";

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<AdminEmpSalarySlipApiProvider>(
          context,
          listen: false,
        );
        provider.empSalarySlipEmpSide(
          startDate: formattedStartDate,
          endDate: formattedEndDate,
        );
      });
    }
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
        loadSalarySlipData();
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
        loadSalarySlipData();
      });
    }
  }

  void _clearDateFilters() {
    setState(() {
      startDate = DateTime(now.year, now.month, 1);
      endDate = now;
      loadSalarySlipData();
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminEmpSalarySlipApiProvider>();
    final model = provider.empSalarySlipEmpSideModel?.data;
    final employee = model?.employeeData;
    // Extract values safely with defaults
    final int totalDays = model?.totalDays ?? 0;
    final int presentDays = model?.presentDays ?? 0;
    final int absentDays = model?.absentDays ?? 0;
    final Object salary = model?.salary ?? "0";
    final String estimateSalary = model?.estimateSalary?.toStringAsFixed(2) ?? "0.00";

    print("Salary: $salary, Present: $presentDays, Absent: $absentDays, Total: $totalDays");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Back button
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
        title: Text(
          'Salary Slip',
          style: AppTextStyles.heading1(
            context,
            overrideStyle: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(context, 14),
            ),
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
        //     onPressed: () {},
        //   ),
        // ],
        bottom: PreferredSize(
          preferredSize: ResponsiveHelper.isTablet(context) ? const Size.fromHeight(90): const Size.fromHeight(50),
          child:   Padding(
            padding:  EdgeInsets.symmetric(
              horizontal: 18,
              vertical: ResponsiveHelper.isTablet(context) ?14 : 4,
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
                          'From',
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
                          'To',
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
        ),
      ),
      body:
      provider.isLoading
          ? loadingIndicator()
          : provider.empSalarySlipEmpSideModel == null
          ? Center(child: Text("\u274C No salary data available."))
          : SingleChildScrollView(
            child: Container(
              // width: 1000,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Salary Overview",
                            style: AppTextStyles.heading2(
                              context,
                              overrideStyle: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(context, 14),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF004658),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatItem("Total Days", totalDays.toString(), "total_days"),
                              _buildStatItem("Present", presentDays.toString(), "present"),
                              _buildStatItem("Absent", absentDays.toString(), "absent"),
                            ],
                          ),
                          const Divider(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSalaryItem("Monthly Salary", "₹$salary"),
                              _buildSalaryItem("Estimated", "₹$estimateSalary"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                  ////////

                ],
              ),
            ),
          ),
    );
  }


  Widget _buildStatItem(String title, String value, String type) {
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700]),
        ),
      ],
    );
  }

  TableRow _buildTableRow(List<String> cells) {
    return TableRow(
      children:
          cells
              .map(
                (cell) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(cell, style: TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
    );
  }
}
