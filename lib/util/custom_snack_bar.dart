import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/util/responsive_helper_util.dart';
import '../ui_helper/app_colors.dart';
import '../ui_helper/app_text_styles.dart';

class CustomSnackbarHelper {
  static void customShowSnackbar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 5),
    Color? backgroundColor,
  }) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: AppTextStyles.heading1(context,
            overrideStyle: TextStyle(
              color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(context, 12))),

      ),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor ?? AppColors.primary,
      // Default background color
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
    );

    ScaffoldMessenger.of(context)
        .clearSnackBars(); // Clear any previous snackbars
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
