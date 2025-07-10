import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../admin/employee/screen/salary_slip/controller/admin_emp_salary_slip_api_provider.dart';
import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/app_text_styles.dart';
import '../../../../util/responsive_helper_util.dart';

class EmpSalarySummaryWidget extends StatefulWidget {
  const EmpSalarySummaryWidget({Key? key}) : super(key: key);

  @override
  State<EmpSalarySummaryWidget> createState() => _EmpSalarySummaryWidgetState();
}

class _EmpSalarySummaryWidgetState extends State<EmpSalarySummaryWidget> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    startDate = DateTime(now.year, now.month, 1);
    endDate = now;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AdminEmpSalarySlipApiProvider>(context, listen: false);
      provider.empSalarySlipEmpSide(
        startDate: _formatDate(startDate!),
        endDate: _formatDate(endDate!),
      );
    });
  }

  String _formatDate(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdminEmpSalarySlipApiProvider>();
    final model = provider.empSalarySlipEmpSideModel?.data;

    // Extract values safely with defaults
    final int totalDays = model?.totalDays ?? 0;
    final int presentDays = model?.presentDays ?? 0;
    final int absentDays = model?.absentDays ?? 0;
    final Object salary = model?.salary ?? "0";
    final String estimateSalary = model?.estimateSalary?.toStringAsFixed(2) ?? "0.00";

    print("Salary: $salary, Present: $presentDays, Absent: $absentDays, Total: $totalDays");

    return Container(
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
}
