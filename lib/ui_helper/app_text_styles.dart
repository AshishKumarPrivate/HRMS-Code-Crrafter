import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle heading1(BuildContext context, {TextStyle? overrideStyle}) {
    double fontSize = _responsiveFontSize(context, 18.0);
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ).merge(overrideStyle);
  }

  static TextStyle heading2(BuildContext context, {TextStyle? overrideStyle}) {
    double fontSize = _responsiveFontSize(context, 16.0);
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ).merge(overrideStyle);
  }

  static TextStyle heading3(BuildContext context, {TextStyle? overrideStyle}) {
    double fontSize = _responsiveFontSize(context, 14.0);
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ).merge(overrideStyle);
  }

  static TextStyle bodyText1(BuildContext context, {TextStyle? overrideStyle}) {
    double fontSize = _responsiveFontSize(context, 18.0);
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize,
      color: Colors.black54,
    ).merge(overrideStyle);
  }

  static TextStyle bodyText2(BuildContext context, {TextStyle? overrideStyle}) {
    double fontSize = _responsiveFontSize(context, 16.0);
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize,
      color: Colors.black54,
    ).merge(overrideStyle);
  }

  static TextStyle bodyText3(BuildContext context, {TextStyle? overrideStyle}) {
    double fontSize = _responsiveFontSize(context, 14.0);
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize,
      color: Colors.black54,
    ).merge(overrideStyle);
  }

  static TextStyle caption(BuildContext context, {TextStyle? overrideStyle}) {
    double fontSize = _responsiveFontSize(context, 12.0);
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ).merge(overrideStyle);
  }

  // Helper function to calculate responsive font size
  static double _responsiveFontSize(BuildContext context, double baseFontSize) {

    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 375.0; // 375 is iPhone 11 width (reference)
    final adjustedScale = scaleFactor.clamp(0.85, 1.15); // 👈 Clamp for consistency
    return baseFontSize * adjustedScale;

    // double screenWidth = MediaQuery.of(context).size.shortestSide;
    // double scaleFactor = MediaQuery.of(context).textScaleFactor;
    // return (baseFontSize * (screenWidth / 375.0))*scaleFactor; // Reference width is 375.0
  }
}
