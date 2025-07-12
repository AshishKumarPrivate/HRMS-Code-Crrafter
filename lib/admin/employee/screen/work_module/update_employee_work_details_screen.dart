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
  final Data? workDetail;

  const UpdateEmployeeWorkDetailsScreen({Key? key, required this.workDetail}) : super(key: key);


  @override
  State<UpdateEmployeeWorkDetailsScreen> createState() => _UpdateEmployeeWorkDetailsScreenState();
}

class _UpdateEmployeeWorkDetailsScreenState extends State<UpdateEmployeeWorkDetailsScreen> {
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController shiftInformationController = TextEditingController(text: "Morning");
  final TextEditingController companyController = TextEditingController();
  final TextEditingController jobPositionController = TextEditingController();
  final TextEditingController workTypeController = TextEditingController();
  final TextEditingController reportingMangerController = TextEditingController();
  final TextEditingController workLocationController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
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
      "reportingManager": reportingMangerController.text.trim(),
      "workLocation": workLocationController.text.trim(),
      "jobPosition": jobPositionController.text.trim(),
      "workType": selectedWorkType ?? 'Work from office',
      "salary": salaryController.text.trim(),
      "company": companyController.text.trim(),
      "joiningDate": joiningDateController.text.trim(),
      "tags": tagsController.text.trim() ?? "New",
    };
    bankDetailProvider.updateEmployeeWorkDetails(context, requestBodyAddWorkk,widget.workDetail!.sId.toString());
  }

  @override
  void initState() {
    super.initState();
    print("bankIDD=>${widget.workDetail!.sId}");
    if (widget.workDetail != null) {
      departmentController.text = widget.workDetail?.department ?? '';
      shiftInformationController.text = widget.workDetail?.department ?? '';
      reportingMangerController.text = widget.workDetail?.department ?? '';
      workLocationController.text = widget.workDetail?.workLocation ?? '';
      jobPositionController.text = widget.workDetail?.jobPosition ?? '';
      selectedWorkType = widget.workDetail?.workType ?? '';
      salaryController.text = widget.workDetail?.salary ?? '';
      companyController.text = widget.workDetail?.company ?? '';
      companyController.text = widget.workDetail?.company ?? '';
      tagsController.text = widget.workDetail?.company ?? '';
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
          padding: const EdgeInsets.only(left: 15.0, right: 15.0,top: 0,bottom: 15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
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
                  hintText: "Work Shift",
                  title: "Shift",
                  errorMessage: "Invalid Shift",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: workLocationController,
                  focusNode: _workLocationFocusNode,
                  icon: Icons.email_outlined,
                  hintText: "Work Location",
                  title: "Work Location",
                  errorMessage: "Invalid Lork Location",
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
                  hintText: "Company",
                  title: "Company",
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
