import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/auth/controller/admin_auth_provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/controller/employee_api_provider.dart';
import 'package:hrms_management_code_crafter/util/custom_snack_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../screen/auth/controller/auth_provider.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/common_widget/custom_text_field.dart';
import '../../../ui_helper/common_widget/default_common_app_bar.dart';
import '../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../util/loading_indicator.dart';
import '../../../util/responsive_helper_util.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController workEmailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController altPhoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController roleController = TextEditingController(text: "employee", );

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _workEmailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _altPhoneFocusNode = FocusNode();
  final FocusNode _dobFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _qualificationFocusNode = FocusNode();
  final FocusNode _experienceFocusNode = FocusNode();
  final FocusNode _roleFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  final List<String> gender = ['Male', 'Female', 'Other'];
  final List<String> maritalStatus = ['Single', 'Married'];
  String? selectedGender = "Male";
  String? selectedMaritalStatus = "Single";
  bool showGender = false;
  bool showMaritalStatus = false;
  File? _image;
  bool _isAgreed = false;

  // handle the login api here
  Future<void> handleSubmit() async {
    final loginProvider = context.read<EmployeeApiProvider>();
    print("🟢 Login Button Clicked");
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      print("🔴 Validation Failed: Fields are empty");
      return;
    }
    FormData requestBodyAddEmployee = FormData.fromMap({
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "workEmail": workEmailController.text.trim(),
      "alternateMobile": altPhoneController.text.trim(),
      "mobile": phoneController.text.trim(),
      "dob": dobController.text.trim(),
      "gender": selectedGender,
      "address": addressController.text.trim(),
      "state": stateController.text.trim(),
      "city": cityController.text.trim(),
      "qualification": qualificationController.text.trim(),
      "experience": experienceController.text.trim(),
      "maritalStatus": selectedMaritalStatus,
      "children": "",
      "emergencyContact": "",
       if (_image != null) "photo": await MultipartFile.fromFile(_image!.path, filename: "profile.jpg"),      // use MultipartFile.fromFile(...) if you have a file
      "document": "",
      "idCard": "",
      "role": roleController.text.trim(),
      "password": passwordController.text.trim(),
    });
    loginProvider.addEmployee(context, requestBodyAddEmployee);
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
        dobController.text = formattedDate;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery); // or ImageSource.camera

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    List<FocusNode> focusNodes = [
      _nameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _workEmailFocusNode,
      _phoneFocusNode,
      _altPhoneFocusNode,
      _dobFocusNode,
      _addressFocusNode,
      _qualificationFocusNode,
      _experienceFocusNode,
      _roleFocusNode,
      _stateFocusNode,
      _cityFocusNode,
    ];

    for (var node in focusNodes) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    workEmailController.dispose();
    phoneController.dispose();
    altPhoneController.dispose();
    dobController.dispose();
    addressController.dispose();
    stateController.dispose();
    cityController.dispose();
    qualificationController.dispose();
    experienceController.dispose();
    roleController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _workEmailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _altPhoneFocusNode.dispose();
    _dobFocusNode.dispose();
    _addressFocusNode.dispose();
    _qualificationFocusNode.dispose();
    _experienceFocusNode.dispose();
    _roleFocusNode.dispose();
    _stateFocusNode.dispose();
    _cityFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultCommonAppBar(
        activityName: "Add New Employee",
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
                GestureDetector(
                  onTap: _pickImage,
                  child: Center(
                    child: _image  == null
                        ? Icon(Icons.account_circle, size: 100, color: Colors.blueAccent)
                        : CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(_image !),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: nameController,
                  focusNode: _nameFocusNode,
                  icon: Icons.person_pin,
                  hintText: "Employee Name",
                  title: "Name",
                  errorMessage: "Invalid Name",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: emailController,
                  focusNode: _emailFocusNode,
                  icon: Icons.email_outlined,
                  hintText: "Employee Email",
                  title: "Email",
                  errorMessage: "Invalid Email",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: workEmailController,
                  focusNode: _workEmailFocusNode,
                  icon: Icons.email_outlined,
                  hintText: "Employee Work Email",
                  title: "Work Email",
                  errorMessage: "Invalid Email",
                  enableValidation: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: passwordController,
                  focusNode: _passwordFocusNode,
                  icon: Icons.lock_open,
                  hintText: "Employee Password",
                  title: "Password",
                  errorMessage: "Invalid Password",
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: phoneController,
                  focusNode: _phoneFocusNode,
                  icon: Icons.phone_android_sharp,
                  hintText: "Employee Phone Number",
                  title: "Phone",
                  errorMessage: "Invalid Phone No",
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: altPhoneController,
                  focusNode: _altPhoneFocusNode,
                  icon: Icons.phone_android_sharp,
                  hintText: "Employee Alternate Phone Number",
                  title: "Alternate Phone",
                  errorMessage: "Invalid Phone No",
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: addressController,
                  focusNode: _addressFocusNode,
                  icon: Icons.location_on_sharp,
                  hintText: "Address",
                  title: "Address",
                  errorMessage: "Invalid Address",
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: CustomTextField(
                      controller: dobController,
                      focusNode: _dobFocusNode,
                      icon: Icons.calendar_today,
                      hintText: "Select Date of Birth",
                      title: "Date of Birth",
                      errorMessage: "Invalid Date of Birth",
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                genderDropdown(),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: qualificationController,
                  focusNode: _qualificationFocusNode,
                  icon: Icons.badge_outlined,
                  hintText: "Qualification",
                  title: "Qualification",
                  errorMessage: "Invalid Qualification",
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: roleController,
                  focusNode: _roleFocusNode,
                  icon: Icons.badge_outlined,
                  hintText: "Role",
                  title: "Role",
                  errorMessage: "Invalid Role",
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: experienceController,
                  focusNode: _experienceFocusNode,
                  icon: Icons.badge_outlined,
                  hintText: "Experience",
                  title: "Experience",
                  errorMessage: "Invalid Experience",
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: stateController,
                  focusNode: _stateFocusNode,
                  icon: Icons.badge_outlined,
                  hintText: "State",
                  title: "State",
                  errorMessage: "Invalid State",
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: cityController,
                  focusNode: _cityFocusNode,
                  icon: Icons.badge_outlined,
                  hintText: "City",
                  title: "City",
                  errorMessage: "Invalid City",
                ),
                const SizedBox(height: 10),
                maritalStatusDropdown(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _isAgreed,
                      onChanged: (value) {
                        setState(() {
                          _isAgreed = value ?? false;
                        });
                      },
                      activeColor: Colors.blueAccent,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "I agree to the ",
                              style: TextStyle(color: Colors.black87),
                            ),
                            TextSpan(
                              text: "Terms & Conditions & Privacy Policy",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " set out by this site.",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Consumer<EmployeeApiProvider>(
                  builder: (context, loginProvider, child) {
                    print("✅ Consumer call ho rha hai ");
                    return loginProvider.isLoading
                        ? loadingIndicator() // Show loader
                        : CustomButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_isAgreed) {
                                handleSubmit();
                              } else {
                                CustomSnackbarHelper.customShowSnackbar(
                                  context: context,
                                  backgroundColor: Colors.red,
                                  message: "Please agree to the terms.",
                                );
                              }
                            }
                          },
                          text: 'Login',
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
  Widget genderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Gender",
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
              showGender = !showGender;
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
                  selectedGender ?? "Select Gender",
                  style: AppTextStyles.bodyText1(
                    context,
                    overrideStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: ResponsiveHelper.fontSize(context, 13),
                    ),
                  ),
                ),
                Icon(
                  showGender ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        if (showGender)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children:
                  gender
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
                              selectedGender = item;
                              showGender = false;
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

  /// 🎯 Marital Status Dropdown Matching`
  Widget maritalStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Marital Status",
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
              showMaritalStatus = !showMaritalStatus;
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
                  selectedMaritalStatus ?? "Marital Status",
                  style: AppTextStyles.bodyText1(
                    context,
                    overrideStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: ResponsiveHelper.fontSize(context, 13),
                    ),
                  ),
                ),
                Icon(
                  showMaritalStatus
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        if (showMaritalStatus)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children:
                  maritalStatus
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
                              selectedMaritalStatus = item;
                              showMaritalStatus = false;
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
