import 'dart:io';

 import 'package:flutter/material.dart';
 import 'package:hrms_management_code_crafter/admin/employee/controller/policy/company_policy_api_provider.dart';

import 'package:provider/provider.dart';

import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/common_widget/custom_text_field.dart';
import '../../../../ui_helper/common_widget/default_common_app_bar.dart';
import '../../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../../util/loading_indicator.dart';

class UpdateCompanyPolicyScreen extends StatefulWidget {
  const UpdateCompanyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<UpdateCompanyPolicyScreen> createState() => _UpdateCompanyPolicyScreenState();
}

class _UpdateCompanyPolicyScreenState extends State<UpdateCompanyPolicyScreen> {
  final TextEditingController policyTitleController = TextEditingController();
  final TextEditingController policyDescriptionController = TextEditingController();

  final FocusNode _policyTitleFocusNode = FocusNode();
  final FocusNode _policyDescriptionFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isAgreed = false;

  // handle the login api here
  Future<void> handleSubmit() async {
    final policyProvider = context.read<CompanyPolicyApiProvider>();
    Map<String, dynamic> requestBodyAddPolicy ={
      "title": policyTitleController.text.trim(),
      "description": policyDescriptionController.text.trim(),
    };
    // policyProvider.updatePolicyDetails(context, requestBodyAddPolicy,policyId);
  }


  @override
  void initState() {
    super.initState();

    List<FocusNode> focusNodes = [
      _policyTitleFocusNode,
      _policyDescriptionFocusNode,
    ];

    for (var node in focusNodes) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    policyTitleController.dispose();
    policyDescriptionController.dispose();
    _policyTitleFocusNode.dispose();
    _policyDescriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultCommonAppBar(
        activityName: "Add New Policy",
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
                CustomTextField(
                  controller: policyTitleController,
                  focusNode: _policyTitleFocusNode,
                  hintText: "Policy Name",
                  title: "Policy Name",
                  errorMessage: "Invalid Policy Name",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: policyDescriptionController,
                  focusNode: _policyDescriptionFocusNode,
                  hintText: "Policy Description",
                  title: "Policy Description",
                  maxLines: 4,
                  errorMessage: "Invalid Policy Description",
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                Consumer<CompanyPolicyApiProvider>(
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
                          text: 'Add Policy',
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
