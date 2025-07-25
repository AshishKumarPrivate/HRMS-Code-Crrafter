import 'package:flutter/material.dart';

class ResponsiveHelper {
  // -------------------------------------------------------
  //   1) Device Type Checkers
  // -------------------------------------------------------
  /// Mobile breakpoint
  static bool isMobile(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 600; // 600 se kam ko mobile manenge
  }

  /// Tablet breakpoint
  static bool isTablet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 600 && screenWidth < 1024;
    // 600 se 1024 ke beech ko tablet manenge
  }

  /// (Optional) Desktop breakpoint
  static bool isDesktop(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 1024; // 1024 ya usse zyada desktop
  }

  // -------------------------------------------------------
  //   2) Font Size
  // -------------------------------------------------------
  /// Get responsive font size
  static double fontSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Base formula (mobile) - jaisa aap abhi use kar rahe the
    double baseSize = (size / 100) * (screenWidth / 3.75);

    if (isTablet(context)) {
      // Tablet ke liye thoda bada ya chhota karna chahein to factor badha/sikod sakte hain
      baseSize *= 1;
    } else if (isDesktop(context)) {
      // Desktop ke liye aur bada
      baseSize *= 1;
    }
    return baseSize;
  }

  // -------------------------------------------------------
  //   3) Container Width
  // -------------------------------------------------------
  /// Get responsive width (useful for container widths)
  static double containerWidth(BuildContext context, double percentage) {
    final screenWidth = MediaQuery.of(context).size.width;
    double width = (percentage / 100) * screenWidth;

    // Tablet/desktop ke liye agar aap chahte hain ki width thodi adjust ho jaye:
    if (isTablet(context)) {
      width *= 1.1;
    } else if (isDesktop(context)) {
      width *= 1.2;
    }
    return width;
  }

  // -------------------------------------------------------
  //   4) Container Height
  // -------------------------------------------------------
  /// Get responsive height (useful for container heights)
  static double containerHeight(BuildContext context, double percentage) {
    final screenHeight = MediaQuery.of(context).size.height;
    double height = (percentage / 100) * screenHeight;

    if (isTablet(context)) {
      height *= 1.1;
    } else if (isDesktop(context)) {
      height *= 1.2;
    }
    return height;
  }

  // -------------------------------------------------------
  //   5) Padding
  // -------------------------------------------------------
  /// Get responsive padding (based on screen width/height)
  static EdgeInsets padding(BuildContext context, double horizontal, double vertical) {
    return EdgeInsets.symmetric(
      horizontal: containerWidth(context, horizontal),
      vertical: containerHeight(context, vertical),
    );
  }

  // -------------------------------------------------------
  //   6) SizedBox Helpers
  // -------------------------------------------------------
  static Widget sizeBoxHeightSpace(BuildContext context, double percentage) {
    return SizedBox(height: containerHeight(context, percentage));
  }

  static Widget sizeboxWidthlSpace(BuildContext context, double percentage) {
    return SizedBox(width: containerWidth(context, percentage));
  }

  // -------------------------------------------------------
  //   7) Icon Size
  // -------------------------------------------------------
  /// Get responsive icon size
  static double iconSize(BuildContext context, double baseSize) {
    if (isMobile(context)) {
      return baseSize; // Mobile ke liye jo diya, wohi
    } else if (isTablet(context)) {
      return baseSize * 1.2; // Tablet ke liye 20% bada
    } else {
      // Desktop
      return baseSize * 1.4;
    }
  }
}

