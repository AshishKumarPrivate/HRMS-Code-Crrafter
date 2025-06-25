
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/model/announcement_list_model.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/widget/announcement_slider_widgets.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/common_widget/custom_text_field.dart';
import '../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../util/loading_indicator.dart';
import '../../../util/responsive_helper_util.dart';
import '../controller/comp_profile_api_provider.dart';


class AnnouncementTabContentWidget extends StatefulWidget {
  const AnnouncementTabContentWidget({super.key});

  @override
  State<AnnouncementTabContentWidget> createState() => _AnnouncementTabContentWidgetState();
}

class _AnnouncementTabContentWidgetState extends State<AnnouncementTabContentWidget> {
  bool _showAnnouncementForm = false;

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
    // Here, you would typically update your data model or call an API
    // e.g., companyProfile.updateCorporateAddress(address, city);

    setState(() {
      _showAnnouncementForm = false; // Hide the form after saving
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Announcement saved successfully!')),
    );
  }

  void _onAnnouncementFormCancelled() {
    setState(() {
      _showAnnouncementForm = false; // Hide the form on cancel
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
          _buildAddressSection(
            context,
            title: "Add Announcement",
            showAddIcon: !_showAnnouncementForm, // Show Add only if form is hidden
            showEditIcon: false, // Edit icon for corporate office not shown when form is active
            onAdd: () {
              setState(() {
                _showAnnouncementForm = true; // Show the form
              });
            },
            // Dynamically show the form or existing content for Corporate Office
            contentWidget: _showAnnouncementForm
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
  Widget _buildAddressSection(
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

//
// class AnnouncementCard extends StatelessWidget {
//   final Data announcement;
//
//   const AnnouncementCard({Key? key, required this.announcement}): super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 5.0),
//       child: Card(
//         elevation: 2.0,
//         color: AppColors.lightBlueColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       "Published On: ${announcement.createdAt?.split("T").first ?? "N/A" }",
//                       style: AppTextStyles.heading1(
//                         context,
//                         overrideStyle: TextStyle(
//                           fontSize: ResponsiveHelper.fontSize(context, 12),
//                         ),
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.teal.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Text(
//                       'ID: ${announcement.sId?.padRight(2, '0')?? "N/A" }',
//                       style: AppTextStyles.heading1(
//                         context,
//                         overrideStyle: TextStyle(
//                           color: AppColors.primary,
//                           fontSize: ResponsiveHelper.fontSize(context, 12),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const Divider(height: 25, thickness: 1, color: Colors.grey),
//               Expanded(
//                 child: SingleChildScrollView(
//                   // Allow scrolling for long descriptions
//                   child: Text(
//                     announcement.message.toString(),
//                     style: AppTextStyles.bodyText1(
//                       context,
//                       overrideStyle: TextStyle(
//                         color: Colors.black,
//                         fontSize: ResponsiveHelper.fontSize(context, 12),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
  final TextEditingController announcementMessageController = TextEditingController();

  final FocusNode _announcementMessageFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  // handle the login api here
  Future<void> handleSubmit() async {
    final loginProvider = context.read<CompanyProfileApiProvider>();
    // FormData requestBodyAddEmployee = FormData.fromMap({
    //   "message": announcementMessageController.text.trim(),
    //   "overviewId": "684ab1f3e60f846f79ba22b1",
    // });

    Map<String, dynamic> requestBody = {"message": announcementMessageController.text.trim(),
      "overviewId": "684ab1f3e60f846f79ba22b1"};
    loginProvider.addCompanyAnnouncement(context, requestBody);
  }

  @override
  void initState() {
    super.initState();

    List<FocusNode> focusNodes = [
      _announcementMessageFocusNode,
    ];

    for (var node in focusNodes) {
      node.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    announcementMessageController.dispose();

    _announcementMessageFocusNode.dispose();
    super.dispose();
  }

  void _clearForm() {
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
                "Add Announcement Details",
                style: AppTextStyles.heading2(context),
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: announcementMessageController,
                focusNode: _announcementMessageFocusNode,
                hintText: "Message",
                title: "Message",
                errorMessage: "Invalid Message",
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
