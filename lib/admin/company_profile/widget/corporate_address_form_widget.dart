import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/controller/comp_profile_api_provider.dart';
import 'package:provider/provider.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/common_widget/custom_text_field.dart';
import '../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../util/loading_indicator.dart';

class CorporateAddressForm extends StatefulWidget {
  final Function(String address, String city) onSave;
  final VoidCallback onCancel;

  const CorporateAddressForm({
    Key? key,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<CorporateAddressForm> createState() => _CorporateAddressFormState();
}

class _CorporateAddressFormState extends State<CorporateAddressForm> {
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  final FocusNode _address1FocusNode = FocusNode();
  final FocusNode _address2FocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _pinCodeFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  // handle the login api here
  Future<void> handleSubmit() async {
    final loginProvider = context.read<CompanyProfileApiProvider>();
    FormData requestBodyAddEmployee = FormData.fromMap({
      "address1": address1Controller.text.trim(),
      "address2": address2Controller.text.trim(),
      "city": cityController.text.trim(),
      "state": stateController.text.trim(),
      "country": countryController.text.trim(),
      "pincode": pinCodeController.text.trim(),
      "overviewId": "685274d2f7bbec00069e3c48",
    });
    loginProvider.addCmpCorporateAddress(context, requestBodyAddEmployee);
  }

  @override
  void initState() {
    super.initState();

    List<FocusNode> focusNodes = [
      _address1FocusNode,
      _address2FocusNode,
      _cityFocusNode,
      _stateFocusNode,
      _countryFocusNode,
      _pinCodeFocusNode,
    ];

    for (var node in focusNodes) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    pinCodeController.dispose();

    _address1FocusNode.dispose();
    _address2FocusNode.dispose();
    _cityFocusNode.dispose();
    _stateFocusNode.dispose();
    _countryFocusNode.dispose();
    _pinCodeFocusNode.dispose();
    super.dispose();
  }

  void _clearForm() {
    address1Controller.clear();
    address2Controller.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
    pinCodeController.clear();
  }

  void _onCancelPressed() {
    _clearForm(); // Clear form fields on cancel
    widget.onCancel();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Corporate Address Details",
                style: AppTextStyles.heading2(context),
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: address1Controller,
                focusNode: _address1FocusNode,
                hintText: "Address Line 1",
                title: "Address Line 1",
                errorMessage: "Invalid Address Line 1",
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: address2Controller,
                focusNode: _address2FocusNode,
                hintText: "Address Line 2",
                title: "Address Line 2",
                errorMessage: "Invalid Address Line 2",
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: cityController,
                      focusNode: _cityFocusNode,
                      hintText: "City",
                      title: "City",
                      errorMessage: "City",
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: CustomTextField(
                      controller: stateController,
                      focusNode: _stateFocusNode,
                      hintText: "State",
                      title: "State",
                      errorMessage: "State",
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: countryController,
                      focusNode: _countryFocusNode,
                      hintText: "Country",
                      title: "Country",
                      errorMessage: "Country",
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child:  CustomTextField(
                      controller: pinCodeController,
                      focusNode: _pinCodeFocusNode,
                      hintText: "Pin Code",
                      title: "Pin Code",
                      errorMessage: "Pin Code",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 100,
                    child: CustomButton(
                      textColor: Colors.black,
                      type: ButtonType.outlined,
                      color: AppColors.txtGreyColor,
                      onPressed: () {
                        _onCancelPressed();
                      },
                      text: 'Cancel',
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Consumer<CompanyProfileApiProvider>(
                    builder: (context, loginProvider, child) {
                      print("✅ Consumer call ho rha hai ");
                      return loginProvider.isLoading
                          ? loadingIndicator() // Show loader
                          : SizedBox(
                            width: 100,
                            child: CustomButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  handleSubmit();
                                }
                              },
                              text: 'Save',
                            ),
                          );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
