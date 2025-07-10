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

class ApplyEmpLeaveScreen extends StatefulWidget {
  const ApplyEmpLeaveScreen({Key? key}) : super(key: key);

  @override
  State<ApplyEmpLeaveScreen> createState() => _ApplyEmpLeaveScreenState();
}

class _ApplyEmpLeaveScreenState extends State<ApplyEmpLeaveScreen> {
  final TextEditingController leaveDescriptionController =
      TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  final FocusNode _leaveDescriptionFocusNode = FocusNode();
  final FocusNode _startDateFocusNode = FocusNode();
  final FocusNode _endDateFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  // Internal format variables for API submission
  String? _startDateForApi;
  String? _endDateForApi;

  final DateFormat uiDateFormat = DateFormat('dd-MM-yyyy');
  final DateFormat apiDateFormat = DateFormat('yyyy-MM-dd');
  // ["HR", "Finance", "IT", "Marketing", "Sales"],
  final List<String> breakDownList = ['full', 'first_haf', 'second_haf'];
  final List<String> departmentList = ['HR', 'Finance', 'IT', 'Marketing', 'Sales'];
  final Map<String, String> breakDownDisplayMap = {
    'full': 'Full Day Leave',
    'first_haf': 'First Half Day Leave',
    'second_haf': 'Second Half Day Leave',
  };
  final Map<String, String> departmentDisplayMap = {
    'HR': 'HR',
    'Finance': 'Finance',
    'IT': 'IT',
    'Marketing': 'Marketing',
    'Sales': 'Sales',
  };

  final List<String> leaveTypeList = [
    'Casual',
    'Sick',
    'Earned',
    'Maternity',
    'Paternity',
    'unpaid',
  ];
  final Map<String, String> leaveTypeDisplayMap = {
    'Casual': 'Casual Leave',
    'Sick': 'Sick Leave',
    'Earned': 'Earned Leave',
    'Maternity': 'Maternity Leave',
    'Paternity': 'Paternity Leave',
    'unpaid': 'Unpaid Leave',
  };

  String? selectedBreakDown = "full";
  String? selectedLeaveType = "Casual";
  bool showBreakDown = false;
  bool showLeaveType = false;

  Future<void> handleSubmit() async {
    final loginProvider = context.read<EmployeeLeaveApiProvider>();
    FormData requestBodyAddEmployee = FormData.fromMap({
      "breakDown": selectedBreakDown,
      "leaveType": selectedLeaveType,
      "startDate": _startDateForApi ?? '',
      "endDate": _endDateForApi ?? '',
      // "startDate": startDateController.text.trim(),
      // "endDate": endDateController.text.trim(),
      "description": leaveDescriptionController.text.trim(),
    });
    loginProvider.applyLeave(context, requestBodyAddEmployee);
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primary, // header color
            colorScheme: ColorScheme.light(
              primary: AppColors.primary, // header text color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // date text color
            ),
            dialogBackgroundColor: Colors.white, // full background white
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary, // button color (OK, Cancel)
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy/MM/dd').format(pickedDate);
      setState(() {
        // startDateController.text = formattedDate;

        startDateController.text = uiDateFormat.format(pickedDate);
        _startDateForApi = apiDateFormat.format(pickedDate);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primary, // header color
            colorScheme: ColorScheme.light(
              primary: AppColors.primary, // header text color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // date text color
            ),
            dialogBackgroundColor: Colors.white, // full background white
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary, // button color (OK, Cancel)
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy/MM/dd').format(pickedDate);
      setState(() {
        // endDateController.text = formattedDate;
        endDateController.text = uiDateFormat.format(pickedDate);
        _endDateForApi = apiDateFormat.format(pickedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    List<FocusNode> focusNodes = [
      _leaveDescriptionFocusNode,
      _startDateFocusNode,
    ];

    for (var node in focusNodes) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    leaveDescriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    _leaveDescriptionFocusNode.dispose();
    _startDateFocusNode.dispose();
    _endDateFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultCommonAppBar(
        activityName: "Apply Leave",
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
                const SizedBox(height: 10),
                _buildDropdownFormField(
                  title: "Break Down",
                  value: selectedBreakDown,
                  items:
                      breakDownList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            breakDownDisplayMap[value] ?? value,
                            style: AppTextStyles.bodyText1(
                              context,
                              overrideStyle: TextStyle(
                                color: Colors.black87,
                                fontSize: ResponsiveHelper.fontSize(
                                  context,
                                  13,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedBreakDown = newValue;
                    });
                  },
                ),
                const SizedBox(height: 10),
                _buildDropdownFormField(
                  title: "Leave Type",
                  value: selectedLeaveType,
                  items:
                      leaveTypeList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            leaveTypeDisplayMap[value] ?? value,
                            style: AppTextStyles.bodyText1(
                              context,
                              overrideStyle: TextStyle(
                                color: Colors.black87,
                                fontSize: ResponsiveHelper.fontSize(
                                  context,
                                  13,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLeaveType = newValue;
                    });
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectStartDate(context),
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: startDateController,
                      focusNode: _startDateFocusNode,
                      icon: Icons.calendar_month,
                      hintText: "Select Start Date",
                      title: "Select Start Date",
                      errorMessage: "Invalid Start Date",
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectEndDate(context),
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: endDateController,
                      focusNode: _endDateFocusNode,
                      icon: Icons.calendar_month,
                      hintText: "Select End Date",
                      title: "Select End Date",
                      errorMessage: "Invalid End Date",
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: leaveDescriptionController,
                  focusNode: _leaveDescriptionFocusNode,
                  hintText: "Type your reason for taking leave",
                  title: "Reason",
                  maxLines: 4,
                  errorMessage: "Invalid Reason",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 15),
                Consumer<EmployeeLeaveApiProvider>(
                  builder: (context, loginProvider, child) {
                    return loginProvider.isLoading
                        ? loadingIndicator()
                        : CustomButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              handleSubmit();
                            }
                          },
                          text: 'Apply',
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

  Widget _buildDropdownFormField({
    required String title,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            title,
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: InputBorder.none, // Remove default border
              contentPadding: EdgeInsets.zero, // Remove default padding
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            isExpanded: true,
            onChanged: onChanged,
            items: items,
            // Added menuMaxHeight to control dropdown menu's maximum height
            menuMaxHeight: MediaQuery.of(context).size.height * 0.4,
            // Max 40% of screen height
            // Added dropdownColor for better visual distinction of the menu
            dropdownColor: Colors.white,
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return 'Please select a $title';
              }
              return null;
            },
            style: AppTextStyles.bodyText1(
              context,
              overrideStyle: TextStyle(
                color: Colors.black87,
                fontSize: ResponsiveHelper.fontSize(context, 13),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget breakDownDropdown() {
    return _customDropdown(
      context: context,
      title: "Break Down",
      currentValue: selectedBreakDown,
      displayMap: breakDownDisplayMap,
      itemList: breakDownList,
      showDropdown: showBreakDown,
      onToggle: () => setState(() => showBreakDown = !showBreakDown),
      onSelect:
          (value) => setState(() {
            selectedBreakDown = value;
            showBreakDown = false;
          }),
    );
  }

  Widget leaveTypeDropdown() {
    return _customDropdown(
      context: context,
      title: "Leave Type",
      currentValue: selectedLeaveType,
      displayMap: leaveTypeDisplayMap,
      itemList: leaveTypeList,
      showDropdown: showLeaveType,
      onToggle: () => setState(() => showLeaveType = !showLeaveType),
      onSelect:
          (value) => setState(() {
            selectedLeaveType = value;
            showLeaveType = false;
          }),
    );
  }

  Widget _customDropdown({
    required BuildContext context,
    required String title,
    required String? currentValue,
    required Map<String, String> displayMap,
    required List<String> itemList,
    required bool showDropdown,
    required VoidCallback onToggle,
    required ValueChanged<String> onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            title,
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
          onTap: onToggle,
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
                  displayMap[currentValue] ?? "Select $title",
                  style: AppTextStyles.bodyText1(
                    context,
                    overrideStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: ResponsiveHelper.fontSize(context, 13),
                    ),
                  ),
                ),
                Icon(
                  showDropdown ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        if (showDropdown)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children:
                  itemList.map((item) {
                    return ListTile(
                      title: Text(
                        displayMap[item] ?? item,
                        style: AppTextStyles.bodyText1(
                          context,
                          overrideStyle: TextStyle(
                            color: Colors.black,
                            fontSize: ResponsiveHelper.fontSize(context, 13),
                          ),
                        ),
                      ),
                      onTap: () => onSelect(item),
                    );
                  }).toList(),
            ),
          ),
      ],
    );
  }
}
