// main.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/common_widget/default_common_app_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CameraScreen(), // Start with the CameraScreen
    );
  }
}
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  XFile? _imageFile; // Stores the captured image file

  @override
  void initState() {
    super.initState();
    // Load the image path when the screen initializes using the new service
    _loadImagePathFromPrefs();
  }

  /// Loads the image path from shared preferences when the screen starts.
  Future<void> _loadImagePathFromPrefs() async {
    final String? imagePath = await ImageStorageService.loadImagePath();
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _imageFile = XFile(imagePath);
      });
    }
  }

  /// Picks an image from the camera and stores its path persistently in app storage
  /// and updates shared preferences with the path.
  /// Sets the captured image to `_imageFile` state variable.
  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    try {
      // Pick an image from the camera
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

      if (photo != null) {
        // Get the application's documents directory for persistent storage
        final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
        // Create a unique file name using a timestamp to avoid overwrites
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String newPath = '${appDocumentsDir.path}/$fileName';

        // Copy the temporary image file (from image_picker) to the new permanent path within app storage
        final File savedImageInAppStorage = await File(photo.path).copy(newPath);

        // Store the path of the saved image in shared preferences using the new service
        await ImageStorageService.saveImagePath(savedImageInAppStorage.path);

        setState(() {
          // Update _imageFile with the permanently saved image's XFile representation
          _imageFile = XFile(savedImageInAppStorage.path);
        });

        _showSuccessSnackBar(context, 'Photo saved to app storage and path saved in preferences!');
      }
    } catch (e) {
      // Handle potential errors during photo capture or saving
      _showErrorSnackBar(context, 'Failed to take or save photo: $e');
    }
  }

  /// Displays a SnackBar with an error message.
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Displays a SnackBar with a success message.
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultCommonAppBar(
        activityName: "Capture Photo",
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Check if an image has been captured
            _imageFile == null
                ? const Text(
              'No photo captured yet.',
              style: TextStyle(fontSize: 18),
            )
                : Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.file(
                  File(_imageFile!.path), // Display the captured image from its stored path
                  fit: BoxFit.contain, // Adjust image to fit within bounds
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Button to take/re-take photo
            ElevatedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: Text(_imageFile == null ? 'Take Photo' : 'Re-take Photo'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Button to use photo and go back (now pops the screen with the image path)
            if (_imageFile != null) // Only show if a photo is captured
              ElevatedButton.icon(
                onPressed: () {
                  // Pop the screen and return the image path to the previous screen
                  Navigator.pop(context, _imageFile!.path);
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Use Photo and Go Back'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors.green, // Differentiate button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DisplayPhotoScreen extends StatelessWidget {
  final String imagePath; // Path to the image file to display

  const DisplayPhotoScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captured Photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This photo was passed from the previous screen:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.file(
                  File(imagePath), // Display the image using the provided path
                  fit: BoxFit.contain, // Adjust image to fit within bounds
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A service class to handle saving and loading the image path using SharedPreferences.
class ImageStorageService {
  static const String _imagePathKey = 'last_captured_image_path';

  /// Saves the given [imagePath] to SharedPreferences.
  static Future<void> saveImagePath(String imagePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imagePathKey, imagePath);
  }

  /// Loads the saved image path from SharedPreferences.
  /// Returns the image path if found, otherwise returns null.
  static Future<String?> loadImagePath() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_imagePathKey);
  }
}

