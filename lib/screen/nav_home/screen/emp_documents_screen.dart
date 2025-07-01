import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
 import 'package:hrms_management_code_crafter/screen/emp_leave/controller/emp_leave_api_provider.dart';
 import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

 import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/app_text_styles.dart';
import '../../../../ui_helper/common_widget/custom_text_field.dart';
import '../../../../ui_helper/common_widget/default_common_app_bar.dart';
import '../../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../../util/loading_indicator.dart';
import '../../../../util/responsive_helper_util.dart';
import '../../../admin/employee/screen/emp_document_module/add_employee_documents_screen.dart';

class EmpDocumentsScreen extends StatefulWidget {
  // const EmpDocumentsScreen({Key? key}) : super(key: key);

  final String empId; // Path to the image file to display

  const EmpDocumentsScreen({super.key, required this.empId});


  @override
  State<EmpDocumentsScreen> createState() => _EmpDocumentsScreenState();
}

class _EmpDocumentsScreenState extends State<EmpDocumentsScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultCommonAppBar(
        activityName: "Documents",
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: AddEmpDocumentUploadWidget(empId: widget.empId),
      ),
    );
  }


}
