
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/ui_helper/app_colors.dart';

import '../../../ui_helper/app_text_styles.dart';
import '../../../util/responsive_helper_util.dart';

class AdminServiceCardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const AdminServiceCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.lightBlueColor,
            shape: BoxShape.circle,
            // boxShadow: [
            //   BoxShadow(
            //     color: color.withOpacity(0.3),
            //     blurRadius: 12,
            //     offset: const Offset(0, 6),
            //   ),
            // ],
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.heading3(
            context,
            overrideStyle: TextStyle(
              fontSize: ResponsiveHelper.fontSize(context, 10),
            ),
          ),
        ),
      ],
    );
  }
}