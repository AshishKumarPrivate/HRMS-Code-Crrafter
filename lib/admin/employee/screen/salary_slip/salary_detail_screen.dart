import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/salary_slip/model/payroll_salary_slip_list_admin_side_model.dart';

import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/app_text_styles.dart';
import '../../../../ui_helper/common_widget/default_common_app_bar.dart';

class CtcDetailScreen extends StatelessWidget {
  final Data employeData;

  const CtcDetailScreen({super.key, required this.employeData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: DefaultCommonAppBar(
        activityName: "CTC Details",
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            const SizedBox(height: 16),
            _employeeInfoCard(context),
            const SizedBox(height: 16),
            _ctcBreakdownCard(context),
            const SizedBox(height: 16),
            _salaryDetailsCard(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_money, color: Colors.white, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Comprehensive\nCTC Details",
                  style: AppTextStyles.bodyText1(
                    context,
                    overrideStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Easily access detailed CTC breakdowns and insights.",
                  style: AppTextStyles.bodyText2(
                    context,
                    overrideStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _employeeInfoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Employee Info",
            style: AppTextStyles.heading1(
              context,
              overrideStyle: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),
          _infoRow(context, "Name", employeData.employeeName ?? "N/A"),
          _infoRow(context, "Email", employeData.email ?? "N/A"),
        ],
      ),
    );
  }

  Widget _ctcBreakdownCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Gross Pay",
                style: AppTextStyles.heading1(
                  context,
                  overrideStyle: const TextStyle(fontSize: 16),
                ),
              ),
              Text(
                "₹ 8,00,000",
                style: AppTextStyles.heading2(
                  context,
                  overrideStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Effective from: Apr 2025",
            style: AppTextStyles.bodyText2(
              context,
              overrideStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          const Divider(height: 24),
          _ctcRow(context, "Gross benefits", 400000, Colors.green),
          _ctcRow(context, "Other benefits", 200000, Colors.orange),
          _ctcRow(context, "Contributions", 100000, Colors.yellow),
          _ctcRow(context, "Recurring Deduction", 100000, Colors.purple),
        ],
      ),
    );
  }

  Widget _ctcRow(
    BuildContext context,
    String label,
    int? value,
    Color dotColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.heading2(
                context,
                overrideStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          Text(
            "₹ ${value ?? 0}",
            style: AppTextStyles.heading2(
              context,
              overrideStyle: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _salaryDetailsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          Text(
            "Salary Details",
            style: AppTextStyles.heading1(
              context,
              overrideStyle: const TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 12),
          _StaticInfoRow("Salary revision month", "April"),
          _StaticInfoRow("Arrear effect from", "April"),
          _StaticInfoRow("Pay group", "A1"),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyText1(
              context,
              overrideStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyText1(
              context,
              overrideStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
      ],
    );
  }
}

class _StaticInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _StaticInfoRow(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,    style: AppTextStyles.bodyText2(
            context,
            overrideStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),),
          Text(
            value,
            style: AppTextStyles.heading2(
              context,
              overrideStyle: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
