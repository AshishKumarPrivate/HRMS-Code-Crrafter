import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/controller/comp_profile_api_provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/controller/employee_api_provider.dart';
import 'package:hrms_management_code_crafter/util/custom_snack_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/app_text_styles.dart';
import '../../../../ui_helper/common_widget/custom_text_field.dart';
import '../../../../ui_helper/common_widget/default_common_app_bar.dart';
import '../../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../../util/loading_indicator.dart';
import '../../../../util/responsive_helper_util.dart';
import '../model/company_profile_data_model.dart';

class UpdateCompanyProfileScreen extends StatefulWidget {
  // const UpdateCompanyProfileScreen({Key? key}) : super(key: key);

  final OverviewData data;

  const UpdateCompanyProfileScreen({Key? key, required this.data})
    : super(key: key);

  @override
  State<UpdateCompanyProfileScreen> createState() =>
      _UpdateCompanyProfileScreenState();
}

class _UpdateCompanyProfileScreenState
    extends State<UpdateCompanyProfileScreen> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController brandNameController = TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final TextEditingController companyPhoneController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController domainNameController = TextEditingController();
  final TextEditingController industryTypesController = TextEditingController();

  final FocusNode _cmpNameFocusNode = FocusNode();
  final FocusNode _brandNameFocusNode = FocusNode();
  final FocusNode _companyEmailFocusNode = FocusNode();
  final FocusNode _companyPhoneFocusNode = FocusNode();
  final FocusNode _websiteFocusNode = FocusNode();
  final FocusNode _domainNameFocusNode = FocusNode();
  final FocusNode _industryTypesFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  File? _image;
  String? _existingLogoUrl; // to preview API image

  // handle the login api here
  Future<void> handleSubmit() async {
    final loginProvider = context.read<CompanyProfileApiProvider>();
    if (companyEmailController.text.isEmpty || websiteController.text.isEmpty) {
      print("🔴 Validation Failed: Fields are empty");
      return;
    }
    FormData requestBodyAddEmployee = FormData.fromMap({
      "companyName": companyNameController.text.trim(),
      "brandName": brandNameController.text.trim(),
      "companyOfficialEmail": companyEmailController.text.trim(),
      "companyOfficialContact": companyPhoneController.text.trim(),
      "website": websiteController.text.trim(),
      "domainName": domainNameController.text.trim(),
      "industryTypes": industryTypesController.text.trim(),
      if (_image != null)
        "logo": await MultipartFile.fromFile(
          _image!.path,
          filename: "profile.jpg",
        ),

      // use MultipartFile.fromFile(...) if you have a file
    });
    // loginProvider.updateCompanyOverview(context, requestBodyAddEmployee, widget.data.sId ?? '');
    bool isUpdated = await loginProvider.updateCompanyOverview(
      context,
      requestBodyAddEmployee,
      widget.data.sId ?? '',
    );

    if (isUpdated) {
      Navigator.pop(context, true); // 🟢 Notify previous screen to refresh
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    ); // or ImageSource.camera

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 🟢 Set controller text from widget.data
    companyNameController.text = widget.data.companyName ?? '';
    brandNameController.text = widget.data.brandName ?? '';
    companyEmailController.text = widget.data.companyOfficialEmail ?? '';
    companyPhoneController.text = widget.data.companyOfficialContact ?? '';
    websiteController.text = widget.data.website ?? '';
    domainNameController.text = widget.data.domainName ?? '';
    industryTypesController.text = (widget.data.industryTypes ?? []).join(', ');

    _existingLogoUrl = widget.data.logo?.secureUrl;

    List<FocusNode> focusNodes = [
      _cmpNameFocusNode,
      _brandNameFocusNode,
      _companyEmailFocusNode,
      _companyPhoneFocusNode,
      _websiteFocusNode,
      _domainNameFocusNode,
      _industryTypesFocusNode,
    ];

    for (var node in focusNodes) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    companyNameController.dispose();
    companyEmailController.dispose();
    websiteController.dispose();
    brandNameController.dispose();
    companyPhoneController.dispose();
    domainNameController.dispose();
    industryTypesController.dispose();
    _cmpNameFocusNode.dispose();
    _brandNameFocusNode.dispose();
    _companyEmailFocusNode.dispose();
    _companyPhoneFocusNode.dispose();
    _websiteFocusNode.dispose();
    _domainNameFocusNode.dispose();
    _industryTypesFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultCommonAppBar(
        activityName: "Add Company Profile",
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
                  child:
                  // Center(
                  //   child: _image  == null
                  //       ? Icon(Icons.account_circle, size: 100, color: AppColors.primary)
                  //       : CircleAvatar(
                  //     radius: 50,
                  //     backgroundImage: FileImage(_image !),
                  //   ),
                  // ),
                  Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade100,
                        // Dashed border requires a custom painter or external package
                      ),
                      child:
                          _image != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _image!,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              )
                              : (_existingLogoUrl != null &&
                                  _existingLogoUrl!.isNotEmpty)
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  _existingLogoUrl!,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          _buildLogoPlaceholder(),
                                ),
                              )
                              : _buildLogoPlaceholder(),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: companyNameController,
                  focusNode: _cmpNameFocusNode,
                  icon: Icons.person_pin,
                  hintText: "Company Name",
                  title: "Company Name",
                  errorMessage: "Invalid Company Name",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: companyEmailController,
                  focusNode: _companyEmailFocusNode,
                  icon: Icons.email_outlined,
                  hintText: "Company Email",
                  title: "Company Email",
                  errorMessage: "Invalid Company Email",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: brandNameController,
                  focusNode: _brandNameFocusNode,
                  icon: Icons.person,
                  hintText: "Brand Name",
                  title: "Brand Name",
                  errorMessage: "Invalid Brand Name",
                  enableValidation: false,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: websiteController,
                  focusNode: _websiteFocusNode,
                  icon: Icons.drive_file_rename_outline,
                  hintText: "Website",
                  title: "Website",
                  errorMessage: "Invalid Website",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: companyPhoneController,
                  focusNode: _companyPhoneFocusNode,
                  icon: Icons.phone_android_sharp,
                  hintText: "Phone Number",
                  title: "Phone",
                  errorMessage: "Invalid Phone No",
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: domainNameController,
                  focusNode: _domainNameFocusNode,
                  icon: Icons.person_pin,
                  hintText: "Domain Name",
                  title: "Domain Name",
                  errorMessage: "Invalid Domain Name",
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: industryTypesController,
                  focusNode: _industryTypesFocusNode,
                  icon: Icons.location_on_sharp,
                  hintText: "Industry Type 1,Industry Type 2,Industry Type 3",
                  title: "Industry Type (Comma Separated)",
                  errorMessage: "Invalid Industry Type",
                ),
                const SizedBox(height: 20),
                Consumer<CompanyProfileApiProvider>(
                  builder: (context, loginProvider, child) {
                    print("✅ Consumer call ho rha hai ");
                    return loginProvider.isLoading
                        ? loadingIndicator() // Show loader
                        : CustomButton(
                          color: Colors.amber,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              handleSubmit();
                            }
                          },
                          text: 'Update Profile',
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

  Widget _buildLogoPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.add, size: 30, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          "Your Company Logo\ncomes here",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
