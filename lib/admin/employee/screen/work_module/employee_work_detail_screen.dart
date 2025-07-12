import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/employee/controller/work_module/employee_work_api_provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/work_module/update_employee_work_details_screen.dart';
import 'package:hrms_management_code_crafter/ui_helper/app_text_styles.dart';
import 'package:hrms_management_code_crafter/util/date_formate_util.dart';
import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';
import 'package:hrms_management_code_crafter/ui_helper/app_colors.dart';
import 'package:hrms_management_code_crafter/ui_helper/common_widget/default_common_app_bar.dart';
import '../../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../../util/responsive_helper_util.dart';

class EmpWorkDetailScreen extends StatefulWidget {
  const EmpWorkDetailScreen({Key? key}) : super(key: key);

  @override
  State<EmpWorkDetailScreen> createState() => _EmpWorkDetailScreenState();
}

class _EmpWorkDetailScreenState extends State<EmpWorkDetailScreen> {

  String? employeeId , empWorkId;
  bool isInitDone = false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    employeeId = await StorageHelper().getEmployeeId();
    empWorkId = await StorageHelper().getEmployeeWorkId();

    print("employeeId${employeeId} workI => ${empWorkId}");
    if (employeeId != null) {
      await Provider.of<EmployeeWorkApiProvider>(context, listen: false)
          .getEmployeeWorkDetail(employeeId!);
    }

    setState(() {
      isInitDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultCommonAppBar(
        activityName: "Work Details",
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: isInitDone == false
            ? loadingIndicator()
            : empWorkId == null
            ? Center(
          child: Text(
            "No Work Details",
            style: AppTextStyles.heading2(
              context,
              overrideStyle: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 12),
              ),
            ),
          ),
        )
            : Consumer<EmployeeWorkApiProvider>(
          builder: (context, workDetailProvider, child) {
            if (workDetailProvider.isLoading) {
              return loadingIndicator();
            }

            if (workDetailProvider.errorMessage.isNotEmpty) {
              return Center(
                  child: Text(workDetailProvider.errorMessage,   style: AppTextStyles.heading2(
                    context,
                    overrideStyle: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(context, 12),
                    ),
                  ),));
            }

            final workDetail = workDetailProvider.workDetailModel!.data;

            return SingleChildScrollView(
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child:Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetail("Company", workDetail!.company.toString()),
                        _buildDetail("Department", workDetail!.department.toString()),
                        _buildDetail("Job Position",workDetail.jobPosition.toString()),
                        _buildDetail("Joining Date", DateFormatter.formatToShortMonth(workDetail.joiningDate.toString())),
                        _buildDetail("Salary", (workDetail?.salary != null && workDetail!.salary.toString().trim().isNotEmpty)
                              ? "₹${workDetail.salary.toString().trim()}/-"
                              : "-", ),
                        _buildDetail("Work Location", workDetail!.workLocation.toString()),
                        _buildDetail("Shift Information", workDetail!.shiftInformation.toString()),
                        _buildDetail("Reporting Manger", workDetail!.reportingManager.toString()),
                        _buildDetail("Work Type",workDetail!.workType.toString()),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child:  CustomButton(
                            text: "Update Work Details",
                            textColor: Colors.black,
                            type: ButtonType.outlined,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UpdateEmployeeWorkDetailsScreen(workDetail: workDetail,)),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomButton(
                            text: "Delete Work",
                            color: Colors.red,
                            onPressed: () {
                              showDeleteBottomSheet(context ,workDetail.sId.toString() );
                              // Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  Widget _buildDetail(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$title:",
              style: AppTextStyles.heading2(
                context,
                overrideStyle: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(context, 12),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value ?? "N/A",
              style: AppTextStyles.heading2(
                context,
                overrideStyle: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(context, 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteBottomSheet(BuildContext context, String workId) {
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
                        "Confirmation For Delete",
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
                        "Are you sure would like to delete?",
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
                      Provider.of<EmployeeWorkApiProvider>(
                        context,
                        listen: false,
                      ).deleteEmpWork(context , workId.toString());
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

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.heading2(
        context,
        overrideStyle: TextStyle(
          fontSize: ResponsiveHelper.fontSize(context, 12),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: AppTextStyles.heading2(
                context,
                overrideStyle: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(context, 12),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.heading2(
                context,
                overrideStyle: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(context, 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
