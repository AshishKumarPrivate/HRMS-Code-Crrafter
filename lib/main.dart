import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms_management_code_crafter/screen/auth/controller/auth_provider.dart';
import 'package:hrms_management_code_crafter/screen/nav_home/controller/punch_in_out_provider.dart';
import 'package:hrms_management_code_crafter/screen/user_selection_screen.dart' show UserSelectionScreen;
import 'package:hrms_management_code_crafter/ui_helper/app_colors.dart';
import 'package:hrms_management_code_crafter/ui_helper/theme/app_theme.dart';
import 'package:hrms_management_code_crafter/ui_helper/theme/theme_provider.dart';
import 'package:hrms_management_code_crafter/util/responsive_builder.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set default status bar style globally
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.primary, // Default background
      statusBarIconBrightness: Brightness.light, // Dark icons for Android
      statusBarBrightness: Brightness.light, // Light text for iOS
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => PunchInOutProvider()),
        ChangeNotifierProvider(create: (context) => AuthAPIProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'HRMS Code Crafter',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: ResponsiveBuilder(child: UserSelectionScreen()),
    );
  }
}
