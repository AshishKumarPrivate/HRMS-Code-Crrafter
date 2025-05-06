import 'dart:io';
import 'package:flutter/material.dart';
 import 'package:hrms_management_code_crafter/admin/employee/screen/bank_module/Update_employee_bank_detail_screen.dart';
import 'package:hrms_management_code_crafter/ui_helper/app_text_styles.dart';
import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/controller/bank_detail/employee_bank_detail_api_provider.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';
import 'package:hrms_management_code_crafter/ui_helper/app_colors.dart';
import 'package:hrms_management_code_crafter/ui_helper/common_widget/default_common_app_bar.dart';
import '../../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../../util/responsive_helper_util.dart';

class EmpBankDetailScreen extends StatefulWidget {
  const EmpBankDetailScreen({Key? key}) : super(key: key);

  @override
  State<EmpBankDetailScreen> createState() => _EmpBankDetailScreenState();
}

class _EmpBankDetailScreenState extends State<EmpBankDetailScreen> {
  String? empEmail;
  String? empName;
  String? empMobile;
  String? empDOB;
  String? bankID;
  bool isInitDone = false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    empEmail = await StorageHelper().getEmployeeEmail();
    empName = await StorageHelper().getEmployeeName();
    empMobile = await StorageHelper().getEmployeeMobile();
    empDOB = await StorageHelper().getEmployeeDob();
    bankID = await StorageHelper().getEmployeeBankId();

    print("bankId${bankID}");
    if (bankID != null) {
      await Provider.of<AddEmployeeBankDetailApiProvider>(context, listen: false)
          .getEmployeeBankDetail(bankID!);
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
        activityName: "Bank Details",
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: isInitDone == false
            ? loadingIndicator()
            : bankID == null
            ? Center(
          child: Text(
            "No Bank Details",
            style: AppTextStyles.heading2(
              context,
              overrideStyle: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 12),
              ),
            ),
          ),
        )
            : Consumer<AddEmployeeBankDetailApiProvider>(
          builder: (context, bankDetailProvider, child) {
            if (bankDetailProvider.isLoading) {
              return loadingIndicator();
            }

            if (bankDetailProvider.errorMessage.isNotEmpty) {
              return Center(
                  child: Text(bankDetailProvider.errorMessage));
            }

            final bankDetail = bankDetailProvider.bankDetailModel;

            return SingleChildScrollView(
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle("🧑 Employee Info"),
                      const SizedBox(height: 8),
                      _infoRow("Name", empName ?? ''),
                      _infoRow("Email", empEmail ?? ''),
                      _infoRow("Mobile", empMobile ?? ''),
                      _infoRow("DOB", empDOB ?? ''),
                      const Divider(height: 32),
                      _sectionTitle("🏦 Bank Info"),
                      const SizedBox(height: 8),
                      _infoRow("Bank Name",
                          bankDetail?.result?.bankName ?? 'N/A'),
                      _infoRow("Account Number",
                          bankDetail?.result?.accountNumber ?? 'N/A'),
                      _infoRow("Branch",
                          bankDetail?.result?.branch ?? 'N/A'),
                      _infoRow("IFSC Code",
                          bankDetail?.result?.ifscCode ?? 'N/A'),
                      _infoRow("Bank Code",
                          bankDetail?.result?.bankCode ?? 'N/A'),
                      _infoRow("Bank Address",
                          bankDetail?.result?.bankAddress ?? 'N/A'),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child:  CustomButton(
                          text: "Update Bank",
                          textColor: Colors.black,
                          type: ButtonType.outlined,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UpdateEmployeeBankDetailScreen(bankDetail: bankDetail!.result,)),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomButton(
                          text: "Delete Bank",
                          color: Colors.red,
                          onPressed: () {
                            showDeleteBottomSheet(context ,bankID.toString() );
                            // Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
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
                      Provider.of<AddEmployeeBankDetailApiProvider>(
                        context,
                        listen: false,
                      ).deleteBank(context , bankID.toString());
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
