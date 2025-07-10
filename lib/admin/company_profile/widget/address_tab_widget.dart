import 'package:flutter/material.dart';

import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import 'corporate_address_form_widget.dart';

class AddressTabContentWidget extends StatefulWidget {
  const AddressTabContentWidget({super.key});

  @override
  State<AddressTabContentWidget> createState() =>
      _AddressTabContentWidgetState();
}

class _AddressTabContentWidgetState extends State<AddressTabContentWidget> {
  bool _showCorporateAddressForm = false;

  void _onCorporateAddressSaved(String address, String city) {
    print("Corporate Address Saved from form:");
    print("  Address: $address");
    print("  City: $city");

    setState(() {
      _showCorporateAddressForm = false; // Hide the form after saving
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Corporate address saved successfully!')),
    );
  }

  void _onCorporateAddressCancelled() {
    setState(() {
      _showCorporateAddressForm = false; // Hide the form on cancel
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAddressSection(
            context,
            title: "CORPORATE OFFICE",
            showAddIcon: !_showCorporateAddressForm,
            // Show Add only if form is hidden
            showEditIcon: false,
            // Edit icon for corporate office not shown when form is active
            onAdd: () {
              setState(() {
                _showCorporateAddressForm = true; // Show the form
              });
            },
            // Dynamically show the form or existing content for Corporate Office
            contentWidget:
                _showCorporateAddressForm
                    ? CorporateAddressForm(
                      // <--- NEW USAGE OF THE REUSABLE FORM
                      onSave: _onCorporateAddressSaved,
                      onCancel: _onCorporateAddressCancelled,
                    )
                    : null, // Show form when active, otherwise null
          ),
          const SizedBox(height: 24.0),
          // CUSTOM ADDRESS TITLE
          // _buildAddressSection(
          //   context,
          //   title: "CUSTOM ADDRESS TITLE",
          //   showAddIcon: true,
          //   onAdd: () {
          //     // Handle add custom address
          //     print("Add Custom Address Title");
          //   },
          // ),
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
    Widget?
    contentWidget, // Optional widget for content like the address card or form
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
