import 'dart:io';

 import 'package:flutter/material.dart';
 import 'package:hrms_management_code_crafter/admin/employee/controller/bank_detail/employee_bank_detail_api_provider.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/app_text_styles.dart';
import '../../../../ui_helper/common_widget/custom_text_field.dart';
import '../../../../ui_helper/common_widget/default_common_app_bar.dart';
import '../../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../../util/loading_indicator.dart';
import '../../../../util/responsive_helper_util.dart';
import '../../controller/work_module/employee_work_api_provider.dart';

class AddEmployeeWorkScreen extends StatefulWidget {
  const AddEmployeeWorkScreen({Key? key}) : super(key: key);

  @override
  State<AddEmployeeWorkScreen> createState() => _AddEmployeeWorkScreenState();
}

class _AddEmployeeWorkScreenState extends State<AddEmployeeWorkScreen> {
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController shiftInformationController = TextEditingController(text: "Morning");
  final TextEditingController reportingMangerController = TextEditingController(text: "Manager");
  final TextEditingController workLocationController = TextEditingController(text: "India");
  final TextEditingController jobPositionController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController joiningDateController = TextEditingController();
  final FocusNode _departmentFocusNode = FocusNode();
  final FocusNode _shiftInformationFocusNode = FocusNode();
  final FocusNode _reportingMangerFocusNode = FocusNode();
  final FocusNode _workLocationFocusNode = FocusNode();
  final FocusNode _jobPositionFocusNode = FocusNode();
  final FocusNode _salaryFocusNode = FocusNode();
  final FocusNode _companyCodeFocusNode = FocusNode();
  final FocusNode _joiningDateFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();


  String? selectedWorkType = "OnSite";
  bool showWorkType = false;
  final List<String> workType = ['OnSite', 'Work From Home'];


  // handle the login api here
  Future<void> handleSubmit() async {
    final bankDetailProvider = context.read<EmployeeWorkApiProvider>();
    Map<String, dynamic> requestBodyAddWorkk ={
      "department": departmentController.text.trim(),
      "shiftInformation": shiftInformationController.text.trim(),
      "reportingManager": reportingMangerController.text.trim(),
      "workLocation": workLocationController.text.trim(),
      "jobPosition": jobPositionController.text.trim(),
      "workType": selectedWorkType ?? 'OnSite',
      "salary": salaryController.text.trim(),
      "company": companyController.text.trim(),
      "joiningDate": joiningDateController.text.trim(),
    };
    bankDetailProvider.addEmployeeWorkDetails(context, requestBodyAddWorkk);
  }


  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      // String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      setState(() {
        joiningDateController.text = formattedDate;
      });
    }
  }


  @override
  void initState() {
    super.initState();

    List<FocusNode> focusNodes = [
      _departmentFocusNode,
      _shiftInformationFocusNode,
      _reportingMangerFocusNode,
      _workLocationFocusNode,
      _jobPositionFocusNode,
      _salaryFocusNode,
      _companyCodeFocusNode,
      _joiningDateFocusNode
    ];

    for (var node in focusNodes) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    departmentController.dispose();
    shiftInformationController.dispose();
    reportingMangerController.dispose();
    workLocationController.dispose();
    jobPositionController.dispose();
    salaryController.dispose();
    companyController.dispose();
    joiningDateController.dispose();

    _departmentFocusNode.dispose();;
    _shiftInformationFocusNode.dispose();
    _reportingMangerFocusNode.dispose();
    _workLocationFocusNode.dispose();
    _jobPositionFocusNode.dispose();
    _salaryFocusNode.dispose();
    _companyCodeFocusNode.dispose();
    _joiningDateFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultCommonAppBar(
        activityName: "Add Employee Work",
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
                  hintText: "Department Name",
                  title: "Department Name",
                  errorMessage: "Invalid Department Name",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: shiftInformationController,
                  focusNode: _shiftInformationFocusNode,
                  icon: Icons.food_bank_outlined,
                  hintText: "Shift Information",
                  title: "Shift Information",
                  errorMessage: "Invalid Shift Type",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: workLocationController,
                  focusNode: _workLocationFocusNode,
                  icon: Icons.location_on_sharp,
                  hintText: "Work Location",
                  title: "Work Location",
                  errorMessage: "Invalid Work Location",
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
                // Work type dropdown
                workTypeDropdown(),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: companyController,
                  focusNode: _companyCodeFocusNode,
                  icon: Icons.phone_android_sharp,
                  hintText: "Company Name",
                  title: "Company Name",
                  errorMessage: "Invalid Company Name",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: salaryController,
                  focusNode: _salaryFocusNode,
                  icon: Icons.currency_rupee,
                  hintText: "Salary",
                  title: "Salary",
                  errorMessage: "Invalid Salary",
                ),
                const SizedBox(height: 10),
                // joining date dropdown

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
                const SizedBox(height: 10),
                Consumer<AddEmployeeBankDetailApiProvider>(
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
                          text: 'Add Work Details',
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

  /// 🎯 Gender Dropdown Matching`
  Widget workTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Work Type",
            style: AppTextStyles.bodyText1(
              context,
              overrideStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.fontSize(context, 12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            setState(() {
              showWorkType = !showWorkType;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: Offset(0, 0),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedWorkType ?? "Select Gender",
                  style: AppTextStyles.bodyText1(
                    context,
                    overrideStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: ResponsiveHelper.fontSize(context, 13),
                    ),
                  ),
                ),
                Icon(
                  showWorkType ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        if (showWorkType)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children:
              workType
                  .map(
                    (item) => ListTile(
                  title: Text(
                    item,
                    style: AppTextStyles.bodyText1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveHelper.fontSize(
                          context,
                          13,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedWorkType = item;
                      showWorkType = false;
                    });
                  },
                ),
              )
                  .toList(),
            ),
          ),
      ],
    );
  }
}
