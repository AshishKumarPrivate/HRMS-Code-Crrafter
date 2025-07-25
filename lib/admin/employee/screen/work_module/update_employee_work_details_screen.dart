import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/work_module/emp_work_detail_model.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/common_widget/custom_text_field.dart';
import '../../../../ui_helper/common_widget/default_common_app_bar.dart';
import '../../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../../util/loading_indicator.dart';
import '../../controller/work_module/employee_work_api_provider.dart';

class UpdateEmployeeWorkDetailsScreen extends StatefulWidget {
  final Data? workDetail;
  final String? companyName;
  final String? workId;
  final String? department;
  final String? shiftInformation;
  final String? jobPosition;
  final String? workType;
  final String? reportingManger;
  final String? workLocation;
  final String? salary;
  final String? joiningDate;
  final bool? isEmployeeLogin;

  const UpdateEmployeeWorkDetailsScreen({
    Key? key,
    this.companyName,
    this.workId,
    this.department,
    this.shiftInformation,
    this.jobPosition,
    this.workType,
    this.reportingManger,
    this.workLocation,
    this.salary,
    this.joiningDate,
    this.isEmployeeLogin,
    this.workDetail,
  }) : super(key: key);

  @override
  State<UpdateEmployeeWorkDetailsScreen> createState() =>
      _UpdateEmployeeWorkDetailsScreenState();
}

class _UpdateEmployeeWorkDetailsScreenState
    extends State<UpdateEmployeeWorkDetailsScreen> {
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController shiftInformationController =
      TextEditingController(text: "Morning");
  final TextEditingController companyController = TextEditingController();
  final TextEditingController jobPositionController = TextEditingController();
  final TextEditingController workTypeController = TextEditingController();
  final TextEditingController reportingMangerController =
      TextEditingController();
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

    String? formattedJoiningDate;
    if (joiningDateController.text.isNotEmpty) {
      try {
        // Parse the date from dd-MM-yyyy format (UI format)
        final DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(joiningDateController.text);
        // Format it to yyyy-MM-dd for the API
        formattedJoiningDate = DateFormat('yyyy-MM-dd').format(parsedDate);
      } catch (e) {
        print("Error formatting joining date for API: $e");
        formattedJoiningDate = joiningDateController.text; // Send as is if formatting fails
      }
    }


    Map<String, dynamic> requestBodyAddWorkk = {
      "department": departmentController.text.trim(),
      "shiftInformation": shiftInformationController.text.trim(),
      "reportingManager": reportingMangerController.text.trim(),
      "workLocation": workLocationController.text.trim(),
      "jobPosition": jobPositionController.text.trim(),
      "workType": selectedWorkType ?? 'Work from office',
      "salary": salaryController.text.trim(),
      "company": companyController.text.trim(),
      "joiningDate": formattedJoiningDate,
      "tags": tagsController.text.trim() ?? "New",
    };

    final id =
        widget.isEmployeeLogin == true
            ? await StorageHelper().getEmpLoginId()
            : widget.workDetail!.employeeId.toString();
    if (id != null) {
      bankDetailProvider.updateEmployeeWorkDetails(
        context,
        requestBodyAddWorkk,
        id.toString(),
        widget.isEmployeeLogin,
      );
    } else {
      // Handle error, maybe show a snackbar or print
      print("❌ Error: Work detail ID is null");
    }

    // bankDetailProvider.updateEmployeeWorkDetails(
    //   context,
    //   requestBodyAddWorkk,
    //   widget.workDetail!.employeeId.toString(),
    // );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: joiningDateController.text.isNotEmpty
          ? DateFormat('dd-MM-yyyy').parse(joiningDateController.text)
          : DateTime(2000), // Use existing date if available, else a default,
      // initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      // String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      setState(() {
        joiningDateController.text = formattedDate;
      });
    }
  }

  // Helper method to set joining date from API format to UI format
  void _setJoiningDateFromApi(String? dateString) {
    if (dateString != null && dateString.isNotEmpty) {
      try {
        final DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(dateString);
        joiningDateController.text = DateFormat(
          'dd-MM-yyyy',
        ).format(parsedDate);
      } catch (e) {
        print("Error parsing joining date from API: $e");
        joiningDateController.text =
            dateString; // Fallback to raw string if parsing fails
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.workDetail != null) {
      print("bankIDD => ${widget.workDetail!.sId}");
    } else {
      print("⚠️ workDetail is null in initState");
    } // if (widget.workDetail != null) {
    //   departmentController.text = widget.workDetail?.department ?? '';
    //   shiftInformationController.text =
    //       widget.workDetail?.shiftInformation ?? '';
    //   reportingMangerController.text =
    //       widget.workDetail?.reportingManager ?? '';
    //   workLocationController.text = widget.workDetail?.workLocation ?? '';
    //   jobPositionController.text = widget.workDetail?.jobPosition ?? '';
    //   selectedWorkType = widget.workDetail?.workType ?? '';
    //   salaryController.text = widget.workDetail?.salary ?? '';
    //   companyController.text = widget.workDetail?.company ?? '';
    //   // companyController.text = widget.workDetail?.company ?? '';
    //   tagsController.text = widget.workDetail?.company ?? '';
    // }

    if (widget.isEmployeeLogin == true) {
      // When editing from employee-side flow (pass string params)
      departmentController.text = widget.department ?? '';
      shiftInformationController.text = widget.shiftInformation ?? '';
      reportingMangerController.text = widget.reportingManger ?? '';
      workLocationController.text = widget.workLocation ?? '';
      jobPositionController.text = widget.jobPosition ?? '';
      selectedWorkType = widget.workType ?? '';
      salaryController.text = widget.salary ?? '';
      companyController.text = widget.companyName ?? '';
      _setJoiningDateFromApi(widget.joiningDate);
      // joiningDateController.text = widget.joiningDate ?? '';
      // tagsController.text = "New";
    } else if (widget.workDetail != null) {
      // When editing from admin or existing model
      departmentController.text = widget.workDetail?.department ?? '';
      shiftInformationController.text =
          widget.workDetail?.shiftInformation ?? '';
      reportingMangerController.text =
          widget.workDetail?.reportingManager ?? '';
      workLocationController.text = widget.workDetail?.workLocation ?? '';
      jobPositionController.text = widget.workDetail?.jobPosition ?? '';
      selectedWorkType = widget.workDetail?.workType ?? '';
      salaryController.text = widget.workDetail?.salary ?? '';
      companyController.text = widget.workDetail?.company ?? '';
      _setJoiningDateFromApi(widget.workDetail?.joiningDate);
      // joiningDateController.text = widget.workDetail?.joiningDate ?? '';
      // tagsController.text = widget.workDetail?.tags ?? 'New';
    } else {
      // Fallback for initial values if no data is provided (e.g., for adding new)
      shiftInformationController.text = 'Morning';
      selectedWorkType = 'Work from office';
      workTypeController.text = selectedWorkType!;
      tagsController.text = 'New';
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
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 0,
            bottom: 15,
          ),
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
                  icon: Icons.watch_later_outlined,
                  hintText: "Work Shift",
                  title: "Shift",
                  errorMessage: "Invalid Shift",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: workLocationController,
                  focusNode: _workLocationFocusNode,
                  icon: Icons.location_pin,
                  hintText: "Work Location",
                  title: "Work Location",
                  errorMessage: "Invalid Work Location",
                  keyboardType: TextInputType.text,
                  enableAllCaps: true,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: workTypeController,
                  focusNode: _workTypeFocusNode,
                  icon: Icons.perm_device_info_outlined,
                  hintText: "Work Type",
                  title: "Work Type",
                  errorMessage: "Invalid Work Type",
                  keyboardType: TextInputType.text,
                  enableAllCaps: true,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: reportingMangerController,
                  focusNode: _reportingMangerFocusNode,
                  icon: Icons.person_pin,
                  readOnly: widget.isEmployeeLogin == true,
                  hintText: "Reporting To",
                  title: "Reporting To",
                  errorMessage: "Invalid Reporting To",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: jobPositionController,
                  focusNode: _jobPositionFocusNode,
                  icon: Icons.person_pin,
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
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: joiningDateController,
                      focusNode: _joiningDateFocusNode,
                      icon: Icons.calendar_today,
                      hintText: "Select Joining Date",
                      title: "Joining Date",
                      errorMessage: "Invalid Joining Date",
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: salaryController,
                  focusNode: _salaryFocusNode,
                  icon: Icons.currency_rupee,
                  readOnly: widget.isEmployeeLogin == true,
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
