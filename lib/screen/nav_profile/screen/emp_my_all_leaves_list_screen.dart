import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/screen/emp_leave/controller/emp_leave_api_provider.dart';
import 'package:hrms_management_code_crafter/screen/emp_leave/model/my_all_leave_model.dart';
import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/common_widget/default_common_app_bar.dart';
import '../../../util/responsive_helper_util.dart';

class EmployeeLeaveListScreen extends StatefulWidget {
  const EmployeeLeaveListScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeLeaveListScreen> createState() =>
      _EmployeeLeaveListScreenState();
}

class _EmployeeLeaveListScreenState extends State<EmployeeLeaveListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<EmployeeLeaveApiProvider>(
            context,
            listen: false,
          ).getEmpLeaveList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultCommonAppBar(
        activityName: "My Leave",
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<EmployeeLeaveApiProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return loadingIndicator();
          }

          if (provider.errorMessage.isNotEmpty) {
            return Center(child: Text(provider.errorMessage,style: AppTextStyles.heading2(
              context,
              overrideStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.fontSize(context, 12),
              ),
            ),));
          }

          if (provider.empLeaveListModel!.data!.isEmpty) {
            return Center(child: Text("No leave records found.",style: AppTextStyles.heading2(
              context,
              overrideStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.fontSize(context, 12),
              ),
            ),));
          }
          final leavesProvider = provider.empLeaveListModel!.data;

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

class EmployeeLeaveCard extends StatelessWidget {
  final Data leave;

  const EmployeeLeaveCard({Key? key, required this.leave}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: Colors.indigo.shade400,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${formatDate(leave.startDate)} - ${formatDate(leave.endDate)}",
                          style: AppTextStyles.heading1(
                            context,
                            overrideStyle: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(context, 12),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusColor(leave.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            leave.status ?? "Unknown",
                            style: AppTextStyles.heading1(
                              context,
                              overrideStyle: TextStyle(
                                color: getStatusColor(leave.status),
                                fontSize: ResponsiveHelper.fontSize(context, 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Leave Type: ${leave.leaveType ?? '-'}",
                      style: AppTextStyles.heading1(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 12),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    if (leave.breakDown != null)
                      Text(
                        "Breakdown: ${formatBreakDown(leave.breakDown)}",
                        style: AppTextStyles.heading1(
                          context,
                          overrideStyle: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ),
                    if (leave.description != null && leave.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Reason: ${leave.description}",
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
                        "Applied: ${formatDate(leave.appliedAt)}",
                        style: AppTextStyles.bodyText3(
                          context,
                          overrideStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              // Action Buttons
              if (leave.status?.toLowerCase() == 'pending')
               SizedBox(
                height: 40, // Reduced height for slimmer buttons
                child: Row(
                  children: [
                    Visibility(
                      visible: false,
                      child: Expanded(
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
                            // EDIT action

                          },
                          child: const Text(
                            "Update",
                            style: TextStyle(color: Colors.teal),
                          ),
                        ),
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
                        onPressed: () async {
                          // REJECT action
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirm Delete',style: TextStyle(color: Colors.black),),
                              content: const Text('Are you sure you want to delete this leave?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            final provider = Provider.of<EmployeeLeaveApiProvider>(context, listen: false);
                            await provider.deleteLeave(context, leave.sId.toString()); // Ensure `leave.id` is not null
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(content: Text('Leave deleted successfully')),
                            // );
                          }
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
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
    );
  }
}
