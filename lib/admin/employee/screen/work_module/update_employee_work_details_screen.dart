import 'dart:io';

 import 'package:flutter/material.dart';
 import 'package:hrms_management_code_crafter/admin/employee/model/work_module/emp_work_detail_model.dart';

import 'package:provider/provider.dart';

import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/common_widget/custom_text_field.dart';
import '../../../../ui_helper/common_widget/default_common_app_bar.dart';
import '../../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../../util/loading_indicator.dart';
import '../../controller/work_module/employee_work_api_provider.dart';

class UpdateEmployeeWorkDetailsScreen extends StatefulWidget {
  final Data? bankDetail;

  const UpdateEmployeeWorkDetailsScreen({Key? key, required this.bankDetail}) : super(key: key);


  @override
  State<UpdateEmployeeWorkDetailsScreen> createState() => _UpdateEmployeeWorkDetailsScreenState();
}

class _UpdateEmployeeWorkDetailsScreenState extends State<UpdateEmployeeWorkDetailsScreen> {
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController shiftInformationController = TextEditingController();
  final TextEditingController reportingMangerController = TextEditingController();
  final TextEditingController workLocationController = TextEditingController();
  final TextEditingController jobPositionController = TextEditingController();
  final TextEditingController workTypeController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController joiningDateController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  final FocusNode _departmentFocusNode = FocusNode();
  final FocusNode _shiftInformationFocusNode = FocusNode();
  final FocusNode _reportingMangerFocusNode = FocusNode();
  final FocusNode _workLocationFocusNode = FocusNode();
  final FocusNode _jobPositionFocusNode = FocusNode();
  final FocusNode _workTypeFocusNode = FocusNode();
  final FocusNode _salaryFocusNode = FocusNode();
  final FocusNode _companyFocusNode = FocusNode();
  final FocusNode _joiningDateFocusNode = FocusNode();
  final FocusNode _tagDateFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  String? selectedWorkType;

  // handle the login api here
  Future<void> handleSubmit() async {
    final bankDetailProvider = context.read<EmployeeWorkApiProvider>();
    Map<String, dynamic> requestBodyAddWorkk ={
      "department": departmentController.text.trim(),
      "shiftInformation": shiftInformationController.text.trim(),
      "reportingManger": reportingMangerController.text.trim(),
      "workLocation": workLocationController.text.trim(),
      "jobPosition": jobPositionController.text.trim(),
      "workType": selectedWorkType ?? 'Work from office',
      "salary": salaryController.text.trim(),
      "company": companyController.text.trim(),
      "joiningDate": joiningDateController.text.trim(),
      "tags": tagsController.text.trim() ?? "New",
    };
    bankDetailProvider.updateEmployeeWorkDetails(context, requestBodyAddWorkk,widget.bankDetail!.sId.toString());
  }

  @override
  void initState() {
    super.initState();
    print("bankIDD=>${widget.bankDetail!.sId}");
    if (widget.bankDetail != null) {
      departmentController.text = widget.bankDetail?.department ?? '';
      shiftInformationController.text = widget.bankDetail?.department ?? '';
      reportingMangerController.text = widget.bankDetail?.department ?? '';
      workLocationController.text = widget.bankDetail?.workLocation ?? '';
      jobPositionController.text = widget.bankDetail?.jobPosition ?? '';
      selectedWorkType = widget.bankDetail?.workType ?? '';
      salaryController.text = widget.bankDetail?.salary ?? '';
      companyController.text = widget.bankDetail?.company ?? '';
      companyController.text = widget.bankDetail?.company ?? '';
      tagsController.text = widget.bankDetail?.company ?? '';
    }

    List<FocusNode> focusNodes = [
      _departmentFocusNode,
      _shiftInformationFocusNode,
      _reportingMangerFocusNode,
      _workLocationFocusNode,
      _jobPositionFocusNode,
      _workTypeFocusNode,
      _salaryFocusNode,
      _companyFocusNode,
      _joiningDateFocusNode,
      _tagDateFocusNode,

    ];

    for (var node in focusNodes) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    // Dispose TextEditingControllers
    departmentController.dispose();
    shiftInformationController.dispose();
    reportingMangerController.dispose();
    workLocationController.dispose();
    jobPositionController.dispose();
    workTypeController.dispose();
    salaryController.dispose();
    companyController.dispose();
    joiningDateController.dispose();
    tagsController.dispose();

    // Dispose FocusNodes
    _departmentFocusNode.dispose();
    _shiftInformationFocusNode.dispose();
    _reportingMangerFocusNode.dispose();
    _workLocationFocusNode.dispose();
    _jobPositionFocusNode.dispose();
    _workTypeFocusNode.dispose();
    _salaryFocusNode.dispose();
    _companyFocusNode.dispose();
    _joiningDateFocusNode.dispose();
    _tagDateFocusNode.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultCommonAppBar(
        activityName: "Update Work Details",
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                CustomTextField(
                  controller: departmentController,
                  focusNode: _departmentFocusNode,
                  icon: Icons.person_pin,
                  hintText: "Department",
                  title: "Department",
                  errorMessage: "Invalid Department",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: shiftInformationController,
                  focusNode: _shiftInformationFocusNode,
                  icon: Icons.food_bank_outlined,
                  hintText: "Shift",
                  title: "Shift",
                  errorMessage: "Invalid Shift",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: workLocationController,
                  focusNode: _workLocationFocusNode,
                  icon: Icons.email_outlined,
                  hintText: "work Location",
                  title: "work Location",
                  errorMessage: "Invalid work Location",
                  keyboardType: TextInputType.text,
                  enableAllCaps: true,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: reportingMangerController,
                  focusNode: _reportingMangerFocusNode,
                  icon: Icons.person_pin,
                  hintText: "Reporting To",
                  title: "Reporting To",
                  errorMessage: "Invalid Reporting To",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: jobPositionController,
                  focusNode: _jobPositionFocusNode,
                  icon: Icons.phone_android_sharp,
                  hintText: "Position",
                  title: "Position",
                  errorMessage: "Invalid Position",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: companyController,
                  focusNode: _companyFocusNode,
                  icon: Icons.phone_android_sharp,
                  hintText: "Country",
                  title: "Country",
                  errorMessage: "Invalid Country",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: salaryController,
                  focusNode: _salaryFocusNode,
                  icon: Icons.location_on_sharp,
                  hintText: "Salary",
                  title: "Salary",
                  errorMessage: "Invalid Salary",
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                Consumer<EmployeeWorkApiProvider>(
                  builder: (context, loginProvider, child) {
                    print("✅ Consumer call ho rha hai ");
                    return loginProvider.isLoading
                        ? loadingIndicator() // Show loader
                        : CustomButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              handleSubmit();
                            }
                          },
                          text: 'Update Details',
                        );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
