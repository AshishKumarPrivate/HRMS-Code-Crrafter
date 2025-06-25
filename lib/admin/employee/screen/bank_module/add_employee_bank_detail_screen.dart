import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
 import 'package:hrms_management_code_crafter/admin/employee/controller/bank_detail/employee_bank_detail_api_provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/controller/employee_api_provider.dart';
import 'package:hrms_management_code_crafter/util/custom_snack_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/common_widget/custom_text_field.dart';
import '../../../../ui_helper/common_widget/default_common_app_bar.dart';
import '../../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../../util/loading_indicator.dart';

class AddEmployeeBankDetailScreen extends StatefulWidget {
  const AddEmployeeBankDetailScreen({Key? key}) : super(key: key);

  @override
  State<AddEmployeeBankDetailScreen> createState() => _AddEmployeeBankDetailScreenState();
}

class _AddEmployeeBankDetailScreenState extends State<AddEmployeeBankDetailScreen> {
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController bankCodeController = TextEditingController();
  final TextEditingController bankAddressController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  final FocusNode _bankNameFocusNode = FocusNode();
  final FocusNode _accountNumberFocusNode = FocusNode();
  final FocusNode _branchFocusNode = FocusNode();
  final FocusNode _ifscCodeFocusNode = FocusNode();
  final FocusNode _bankCodeFocusNode = FocusNode();
  final FocusNode _bankAddressFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  // handle the login api here
  Future<void> handleSubmit() async {
    final bankDetailProvider = context.read<AddEmployeeBankDetailApiProvider>();
    if (accountNumberController.text.isEmpty || branchController.text.isEmpty) {
      print("🔴 Validation Failed: Fields are empty");
      return;
    }
    Map<String, dynamic> requestBodyAddEmployee ={
      "bankName": bankNameController.text.trim(),
      "accountNumber": accountNumberController.text.trim(),
      "branch": branchController.text.trim(),
      "ifscCode": ifscCodeController.text.trim(),
      "bankCode": bankCodeController.text.trim(),
      "bankAddress": bankAddressController.text.trim(),
      "country": countryController.text.trim(),
    };
    bankDetailProvider.addEmployeeBankDetails(context, requestBodyAddEmployee);
  }

  @override
  void initState() {
    super.initState();

    List<FocusNode> focusNodes = [
      _bankNameFocusNode,
      _accountNumberFocusNode,
      _branchFocusNode,
      _ifscCodeFocusNode,
      _bankCodeFocusNode,
      _countryFocusNode,
      _bankAddressFocusNode,
    ];

    for (var node in focusNodes) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    bankNameController.dispose();
    accountNumberController.dispose();
    branchController.dispose();
    ifscCodeController.dispose();
    bankCodeController.dispose();
    countryController.dispose();
    bankAddressController.dispose();
    _bankNameFocusNode.dispose();
    _accountNumberFocusNode.dispose();
    _branchFocusNode.dispose();
    _ifscCodeFocusNode.dispose();
    _bankCodeFocusNode.dispose();
    _countryFocusNode.dispose();
    _bankAddressFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: DefaultCommonAppBar(
      //   activityName: "Add Employee Bank",
      //   backgroundColor: AppColors.primary,
      // ),
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
                  controller: bankNameController,
                  focusNode: _bankNameFocusNode,
                  icon: Icons.person_pin,
                  hintText: "Bank Name",
                  title: "Bank Name",
                  errorMessage: "Invalid Bank Name",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: accountNumberController,
                  focusNode: _accountNumberFocusNode,
                  icon: Icons.food_bank_outlined,
                  hintText: "Account Number",
                  title: "Account Number",
                  errorMessage: "Invalid Account Number",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: ifscCodeController,
                  focusNode: _ifscCodeFocusNode,
                  icon: Icons.email_outlined,
                  hintText: "IFSC Code",
                  title: "IFSC Code",
                  errorMessage: "Invalid IFSC Code",
                  keyboardType: TextInputType.text,
                  enableAllCaps: true,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: branchController,
                  focusNode: _branchFocusNode,
                  icon: Icons.person_pin,
                  hintText: "Branch Name",
                  title: "Branch Name",
                  errorMessage: "Invalid Branch Name",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: bankCodeController,
                  focusNode: _bankCodeFocusNode,
                  icon: Icons.phone_android_sharp,
                  hintText: "Bank Code",
                  title: "Bank Code",
                  errorMessage: "Invalid Bank Code",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: countryController,
                  focusNode: _countryFocusNode,
                  icon: Icons.phone_android_sharp,
                  hintText: "Country",
                  title: "Country",
                  errorMessage: "Invalid Country",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: bankAddressController,
                  focusNode: _bankAddressFocusNode,
                  icon: Icons.location_on_sharp,
                  hintText: "Bank Address",
                  title: "Bank Address",
                  errorMessage: "Invalid Bank Address",
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
                          text: 'Add Bank Details',
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
