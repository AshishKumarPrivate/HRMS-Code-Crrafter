
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/announcement/controller/announcement_api_provider.dart';
import 'package:hrms_management_code_crafter/admin/announcement/widget/announcement_slider_widgets.dart';
import 'package:hrms_management_code_crafter/admin/company_terms_conditions/controller/terms_conditions_api_provider.dart';
import 'package:hrms_management_code_crafter/admin/company_terms_conditions/widget/term_conditiions_slider_widgets.dart';
import 'package:provider/provider.dart';

import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/common_widget/custom_text_field.dart';
import '../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../util/loading_indicator.dart';
import '../../../util/storage_util.dart';


class AnnouncementTabContentWidget extends StatefulWidget {
  const AnnouncementTabContentWidget({super.key});

  @override
  State<AnnouncementTabContentWidget> createState() => _AnnouncementTabContentWidgetState();
}

class _AnnouncementTabContentWidgetState extends State<AnnouncementTabContentWidget> {
  bool _showTermsConditionsForm = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onAnnouncementSaved(String address, String city) {
    print("Corporate Address Saved from form:");
    print("  Address: $address");
    print("  City: $city");

    setState(() {
      _showTermsConditionsForm = false; // Hide the form after saving
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Announcement saved successfully!')),
    );
  }

  void _onAnnouncementFormCancelled() {
    setState(() {
      _showTermsConditionsForm = false; // Hide the form on cancel
    });

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // REGISTERED OFFICE
          AnnouncementSliderWidget(),
          const SizedBox(height: 24.0),
          // CORPORATE OFFICE
          _buildAnnouncementSection(
            context,
            title: "Add Announcement",
            showAddIcon: !_showTermsConditionsForm, // Show Add only if form is hidden
            showEditIcon: false, // Edit icon for corporate office not shown when form is active
            onAdd: () {
              setState(() {
                _showTermsConditionsForm = true; // Show the form
              });
            },
            // Dynamically show the form or existing content for Corporate Office
            contentWidget: _showTermsConditionsForm
                ? AnnouncementFormWidget( // <--- NEW USAGE OF THE REUSABLE FORM
              onSave: _onAnnouncementSaved,
              onCancel: _onAnnouncementFormCancelled,
            )
                : null, // Show form when active, otherwise null
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  // Helper method to build common address section layout
  Widget _buildAnnouncementSection(
      BuildContext context, {
        required String title,
        bool showRemoveIcon = false,
        bool showEditIcon = false,
        bool showAddIcon = false,
        VoidCallback? onRemove,
        VoidCallback? onEdit,
        VoidCallback? onAdd,
        Widget? contentWidget, // Optional widget for content like the address card or form
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.heading2(
                  context,
                  overrideStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            if (showRemoveIcon)
              GestureDetector(
                onTap: onRemove,
                child: const Icon(Icons.close, color: Colors.red, size: 20),
              ),
            const SizedBox(width: 8),
            if (showEditIcon)
              GestureDetector(
                onTap: onEdit,
                child: const Icon(Icons.edit, color: Colors.grey, size: 20),
              ),
            if (showAddIcon) // Only show Add icon if showAddIcon is true
              GestureDetector(
                onTap: onAdd,
                child: Row(
                  children: [
                    const Icon(
                      Icons.add_circle_outline,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Add",
                      style: AppTextStyles.bodyText1(
                        context,
                        overrideStyle: const TextStyle(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        if (contentWidget != null) contentWidget,
      ],
    );
  }
}

class AnnouncementFormWidget extends StatefulWidget {
  final Function(String address, String city) onSave;
  final VoidCallback onCancel;

  const AnnouncementFormWidget({
    Key? key,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<AnnouncementFormWidget> createState() => _AnnouncementFormWidgetState();
}

class _AnnouncementFormWidgetState extends State<AnnouncementFormWidget> {
  final TextEditingController announcementTitleController = TextEditingController();
  final TextEditingController announcementMessageController = TextEditingController();

  final FocusNode _announcementTitleFocusNode = FocusNode();
  final FocusNode _announcementDescriptionsFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  // handle the login api here
  Future<void> handleSubmit() async {
    final loginProvider = context.read<CompanyAnnouncementApiProvider>();
    final String overviewId = await StorageHelper().getCompanyOverviewId();
    Map<String, dynamic> requestBody =
    {
      "message": announcementMessageController.text.trim(),
      "overviewId": overviewId,
    };
    loginProvider.addAnnouncement(context,requestBody );
  }

  @override
  void initState() {
    super.initState();

    List<FocusNode> focusNodes = [
      _announcementTitleFocusNode,
      _announcementDescriptionsFocusNode,
    ];

    for (var node in focusNodes) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    announcementTitleController.dispose();
    announcementMessageController.dispose();

    _announcementTitleFocusNode.dispose();
    _announcementDescriptionsFocusNode.dispose();
    super.dispose();
  }

  void _clearForm() {
    announcementTitleController.clear();
    announcementMessageController.clear();
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
                "Add Announcement",
                style: AppTextStyles.heading2(context),
              ),
              const SizedBox(height: 16.0),
              // CustomTextField(
              //   controller: announcementTitleController,
              //   focusNode: _announcementTitleFocusNode,
              //   hintText: "Title",
              //   title: "Title",
              //   errorMessage: "Invalid Title",
              //   keyboardType: TextInputType.text,
              // ),
              // const SizedBox(height: 16.0),
              CustomTextField(
                controller: announcementMessageController,
                focusNode: _announcementDescriptionsFocusNode,
                hintText: "Description",
                title: "Description",
                errorMessage: "Invalid Description",
                keyboardType: TextInputType.text,
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
                  Consumer<CompanyAnnouncementApiProvider>(
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
