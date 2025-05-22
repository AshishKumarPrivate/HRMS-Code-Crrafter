import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/leave_module/admin_leave_api_provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/leave_module/model/all_emp_leave_requests_model.dart';
import 'package:hrms_management_code_crafter/screen/emp_leave/controller/emp_leave_api_provider.dart';
 import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:hrms_management_code_crafter/util/string_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/app_text_styles.dart';
import '../../../../ui_helper/common_widget/default_common_app_bar.dart';
import '../../../../util/custom_snack_bar.dart';
import '../../../../util/responsive_helper_util.dart';


class EmployeeLeaveRequestListScreen extends StatefulWidget {
  const EmployeeLeaveRequestListScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeLeaveRequestListScreen> createState() =>
      _EmployeeLeaveRequestListScreenState();
}

class _EmployeeLeaveRequestListScreenState extends State<EmployeeLeaveRequestListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<AdminEmployeeLeaveApiProvider>(
            context,
            listen: false,
          ).getAllLeaveRequests(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultCommonAppBar(
        activityName: "Leave Requests",
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<AdminEmployeeLeaveApiProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return loadingIndicator();
          }

          if (provider.errorMessage.isNotEmpty) {
            return Center(child: Text(provider.errorMessage));
          }

          if (provider.empLeaveRequestListModel!.data!.isEmpty) {
            return const Center(child: Text("No leave records found."));
          }
          final leavesProvider = provider.empLeaveRequestListModel!.data;

          return Container(
            color:AppColors.lightBgColor,
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: leavesProvider!.length,
              itemBuilder: (context, index) {
                final leave = leavesProvider[index];
                return EmployeeLeaveCard(
                  leave: leave,
                ); // extracted for cleaner code
              },
            ),
          );
        },
      ),
    );
  }
}


class EmployeeLeaveCard extends StatefulWidget {
  final Data leave;

  const EmployeeLeaveCard({Key? key, required this.leave}) : super(key: key);

  @override
  State<EmployeeLeaveCard> createState() => _EmployeeLeaveCardState();
}

class _EmployeeLeaveCardState extends State<EmployeeLeaveCard> {
  bool showRejectReasonField = false;
  final TextEditingController _reasonController = TextEditingController();

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(dateStr));
    } catch (_) {
      return dateStr;
    }
  }

  String formatBreakDown(String? breakdown) {
    switch (breakdown) {
      case 'full':
        return 'Full Day Leave';
      case 'first_haf':
        return 'First Half Leave';
      case 'second_haf':
        return 'Second Half Leave';
      default:
        return '-';
    }
  }

  Future<void> handleReject(BuildContext context) async {
    if (!showRejectReasonField) {
      setState(() {
        showRejectReasonField = true;
      });
      return;
    }

    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      CustomSnackbarHelper.customShowSnackbar(
        context: context,
        message: 'Reason cannot be empty!',
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Confirm Rejection',style: TextStyle(color: Colors.black),),
        content: const Text('Are you sure you want to reject this leave?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Reject')),
        ],
      ),
    );

    if (confirmed == true) {
      final provider = Provider.of<AdminEmployeeLeaveApiProvider>(context, listen: false);
      await provider.rejectLeave(
        context,
        widget.leave.sId.toString(),
        reason,
      );
    }
  }

  Future<void> handleApprove(BuildContext context) async {
    if (!showRejectReasonField) {
      setState(() {
        showRejectReasonField = true;
      });
      return;
    }

    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      CustomSnackbarHelper.customShowSnackbar(
        context: context,
        message: 'Reason cannot be empty!',
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Leave Approval',style: TextStyle(color: Colors.black),),
        content: const Text('Are you sure you want to approve this leave?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Approved')),
        ],
      ),
    );

    if (confirmed == true) {
      final provider = Provider.of<AdminEmployeeLeaveApiProvider>(context, listen: false);
      await provider.approvedLeave(
        context,
        widget.leave.sId.toString(),
        reason,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.leave.employeeId == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leave Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          StringUtils.capitalizeEachWord(widget.leave.employeeId!.name.toString().trim()),
                          style: AppTextStyles.heading1(
                            context,
                            overrideStyle: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(context, 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: getStatusColor(widget.leave.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.leave.status ?? "Unknown",
                          style: AppTextStyles.heading1(
                            context,
                            overrideStyle: TextStyle(
                              color: getStatusColor(widget.leave.status),
                              fontSize: ResponsiveHelper.fontSize(context, 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_month, size: 14, color: Colors.indigo.shade400),
                      const SizedBox(width: 8),
                      Text(
                        "${formatDate(widget.leave.startDate)} - ${formatDate(widget.leave.endDate)}",
                        style: AppTextStyles.heading1(
                          context,
                          overrideStyle: TextStyle(fontSize: ResponsiveHelper.fontSize(context, 12)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Leave Type: ${widget.leave.leaveType ?? '-'}",
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(fontSize: ResponsiveHelper.fontSize(context, 12)),
                    ),
                  ),
                  if (widget.leave.breakDown != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "Breakdown: ${formatBreakDown(widget.leave.breakDown)}",
                        style: AppTextStyles.heading1(
                          context,
                          overrideStyle: TextStyle(fontSize: ResponsiveHelper.fontSize(context, 12)),
                        ),
                      ),
                    ),
                  if (widget.leave.description?.isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Reason: ${widget.leave.description}",
                        style: AppTextStyles.bodyText3(
                          context,
                          overrideStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Applied: ${formatDate(widget.leave.appliedAt)}",
                      style: AppTextStyles.bodyText3(
                        context,
                        overrideStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveHelper.fontSize(context, 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Reject reason field (if shown)
            if (showRejectReasonField)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  controller: _reasonController,
                  decoration: InputDecoration(
                    labelText: "Reason",
                    hintText: "Reason",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ),

            // Action buttons
            if (widget.leave.status?.toLowerCase() == 'pending')
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFD3F1EC),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Add Approve logic
                          handleApprove(context);
                        },
                        child: const Text("Approve", style: TextStyle(color: Colors.teal)),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFFBEAEA),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                        ),
                        onPressed: () => handleReject(context),
                        child: const Text("Reject", style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
