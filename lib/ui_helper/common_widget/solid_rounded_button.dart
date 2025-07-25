import 'package:flutter/material.dart';

import '../app_text_styles.dart';

enum ButtonType { solid, outlined }

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double heightPercentage;
  final double widthPercentage;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final IconData? iconData;
  final double? iconSize;
  final Color? iconColor;
  final int? borderWidth;
  final ButtonType type;
  final Color? borderColor;

  const CustomButton({
    Key? key,
    this.text = '',
    this.color = const Color(0xFF075271),
    this.textColor = Colors.white,
    this.borderRadius = 10.0,
    this.heightPercentage = 5.0,
    this.widthPercentage = 100.0,
    required this.onPressed,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.iconData,
    this.iconSize,
    this.iconColor,
    this.borderWidth,
    this.type = ButtonType.solid,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double responsiveHeight = (heightPercentage / 100) * screenHeight;
    final double responsiveWidth = (widthPercentage / 100) * screenWidth;

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      side: type == ButtonType.outlined
          ? BorderSide(color: borderColor ?? color, width: 1)
          : BorderSide.none,
    );

    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: type == ButtonType.solid ? color : Colors.transparent,
      foregroundColor: textColor,
      shape: shape,
      padding: padding,
      minimumSize: Size(responsiveWidth, responsiveHeight),
      elevation: type == ButtonType.solid ? 2 : 0,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconData != null)
            Icon(
              iconData,
              size: iconSize ?? 20,
              color: type == ButtonType.outlined
                  ? (iconColor ?? (borderColor ?? color))
                  : textColor,
            ),
          if (text.isNotEmpty) ...[
            if (iconData != null) SizedBox(width: 8.0),
            Text(
              text,
              style: AppTextStyles.heading3(context, overrideStyle: TextStyle(color: textColor,fontSize: 14)) ??
                  TextStyle(
                    fontSize: 14,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
