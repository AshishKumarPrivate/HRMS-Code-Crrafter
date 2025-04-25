import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../ui_helper/app_colors.dart';

class ProfileListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final IconData? leadingIcon;
  final String? leadingAssetImage;
  final Color? leadingIconColor;
  final Color avatarBackgroundColor;
  final double borderRadius;
  final Color backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double iconSize;
  final double assetImageSize;
  final bool showTrailingArrow;

  const ProfileListTile({
    Key? key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.leadingIcon,
    this.leadingAssetImage,
    this.leadingIconColor,
    this.avatarBackgroundColor = const Color(0xFFD6E4FF),
    this.borderRadius = 16.0,
    this.backgroundColor = Colors.white,
    this.titleStyle,
    this.subtitleStyle,
    this.iconSize = 20.0,
    this.assetImageSize = 20.0,
    this.showTrailingArrow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: avatarBackgroundColor,
          child:
              leadingAssetImage != null
                  ? SvgPicture.asset(
                    leadingAssetImage!,
                    width: assetImageSize,
                    height: assetImageSize,
                    colorFilter: ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  )
                  : Icon(
                    leadingIcon,
                    color: leadingIconColor ?? Colors.black,
                    size: iconSize,
                  ),
        ),
        title: Text(
          title,
          style:
              titleStyle ??
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle:
            subtitle != null
                ? Text(
                  subtitle!,
                  style:
                      subtitleStyle ??
                      TextStyle(fontSize: 12, color: Colors.grey[700]),
                )
                : null,
        trailing:
            showTrailingArrow
                ? const Icon(Icons.arrow_forward_ios, size: 16)
                : null,
        onTap: onTap,
      ),
    );
  }
}
