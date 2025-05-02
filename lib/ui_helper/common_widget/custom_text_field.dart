import 'package:flutter/material.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';
import '../../util/responsive_helper_util.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final IconData icon;
  final Color? iconColor;
  final int? maxLength;
  final String hintText;
  final String title;
  final String errorMessage;
  final TextInputType keyboardType;
  final double? elevation;
  final double? borderWidth;
  final Color? borderColor;
  final Color? shadowColor;
  final bool enableShadow;
  final bool enableValidation;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.icon,
    this.iconColor,
    this.maxLength,
    required this.hintText,
    required this.title,
    required this.errorMessage,
    this.keyboardType = TextInputType.text,
    this.elevation,
    this.borderWidth,
    this.borderColor,
    this.shadowColor,
    this.enableShadow = true,
    this.enableValidation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormField<String>(
          validator: (value) {
            if (enableValidation && controller.text.isEmpty) {
              return errorMessage;
            }
            return null;
          },
          builder: (FormFieldState<String> fieldState) {
            bool isFocused = focusNode.hasFocus;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: ResponsiveHelper.padding(context, 2, 0.52),
                  child: Text(
                    title,
                    style: AppTextStyles.heading2(
                      context,
                      overrideStyle: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
                ),
                Material(
                  elevation: elevation ?? 0,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: enableShadow
                          ? [
                        BoxShadow(
                          color: isFocused
                              ? shadowColor ?? AppColors.primary.withAlpha(50)
                              : Colors.black12,
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: Offset(0, 0), // Shadow equally on all sides
                        ),

                      ]
                          : [], // No shadow if enableShadow is false
                      border: Border.all(
                        color: isFocused
                            ? (borderColor ?? AppColors.primary)
                            : Colors.transparent,
                        width: borderWidth ?? 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: ResponsiveHelper.padding(context, 2, 0.02),
                          child: Icon(
                            icon,
                            size: ResponsiveHelper.fontSize(context, 20),
                            color: isFocused
                                ? (iconColor ?? AppColors.primary)
                                : AppColors.txtGreyColor,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            keyboardType: keyboardType,
                            maxLength: maxLength,


                            decoration: InputDecoration(
                              counterText: "", // Hides the counter text
                              hintText: hintText,
                              border: InputBorder.none,
                              hintStyle: AppTextStyles.caption(context),
                              contentPadding: ResponsiveHelper.padding(context, 0, 0.2),
                            ),
                            style: AppTextStyles.heading2(context,overrideStyle: TextStyle(fontSize: 14,letterSpacing: 1)),
                            onChanged: (value) {
                              fieldState.didChange(value); // Trigger validation
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (fieldState.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      fieldState.errorText!,
                      style: AppTextStyles.bodyText3(context,overrideStyle: TextStyle(color: Colors.red,fontSize: 12))
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
