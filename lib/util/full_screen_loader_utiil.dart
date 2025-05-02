// lib/widgets/full_screen_loader.dart

import 'package:flutter/material.dart';

class FullScreenLoader {
  static void show(BuildContext context, {String message = "Loading..."}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false, // Disable back button
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                const SizedBox(width: 20),
                Text(message),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(); // Close the loader
  }
}
