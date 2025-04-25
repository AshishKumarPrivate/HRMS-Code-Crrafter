import 'package:flutter/material.dart';

class SizeConfig {
   late MediaQueryData _mediaQueryData;
   late double screenWidth;
   late double screenHeight;
   late double blockWidth;
   late double blockHeight;

   void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;
  }

   double scaleWidth(double inputWidth) {
    return (inputWidth / 375.0) * screenWidth;
  }

   double scaleHeight(double inputHeight) {
    return (inputHeight / 812.0) * screenHeight;
  }

   double scaleText(double inputText) {
    return (inputText / 375.0) * screenWidth;
  }
}
