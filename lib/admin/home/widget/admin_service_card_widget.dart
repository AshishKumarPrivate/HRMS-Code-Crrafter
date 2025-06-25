
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(height: 10),
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