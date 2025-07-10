import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/controller/comp_profile_api_provider.dart';
import 'package:provider/provider.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/common_widget/custom_text_field.dart';
import '../../../ui_helper/common_widget/default_common_app_bar.dart';
import '../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../util/loading_indicator.dart';
import '../model/company_profile_data_model.dart';

class UpdateCorporateAddressForm extends StatefulWidget {
  // final Function(String address, String city) onSave;
  // final VoidCallback onCancel;
  //
  // const UpdateCorporateAddressForm({
  //   Key? key,
  //   required this.onSave,
  //   required this.onCancel,
  // }) : super(key: key);

  final OverviewData data;
  final RegisteredOfficeAddress registeredOfficeAddress;

  const UpdateCorporateAddressForm({Key? key, required this.registeredOfficeAddress, required this.data}) : super(key: key);


  @override
  State<UpdateCorporateAddressForm> createState() =>
      _UpdateCorporateAddressFormState();
}

class _UpdateCorporateAddressFormState extends State<UpdateCorporateAddressForm> {

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
    final Map<String, dynamic> requestBodyAddEmployee = {
      "address1": address1Controller.text.trim(),
      "address2": address2Controller.text.trim(),
      "city": cityController.text.trim(),
      "state": stateController.text.trim(),
      "country": countryController.text.trim(),
      "pincode": pinCodeController.text.trim(),
      "overviewId":  widget.data.sId ?? '',
    };
    loginProvider.updateCmpRegisteredAddress(context, requestBodyAddEmployee, widget.data.registeredOfficeId ?? '');
  }

  @override
  void initState() {
    super.initState();
    
    address1Controller.text = widget.registeredOfficeAddress.address1 ?? '';
    address2Controller.text = widget.registeredOfficeAddress.address2 ?? '';
    cityController.text = widget.registeredOfficeAddress.city ?? '';
    stateController.text = widget.registeredOfficeAddress.state ?? '';
    countryController.text = widget.registeredOfficeAddress.country ?? '';
    pinCodeController.text = widget.registeredOfficeAddress.pincode.toString() ?? '';

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

  // void _onCancelPressed() {
  //   _clearForm(); // Clear form fields on cancel
  //   widget.onCancel();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultCommonAppBar(
        activityName: "Update Address",
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      child: CustomTextField(
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
                          text: 'Update',
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
