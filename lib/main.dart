import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import 'package:hrms_management_code_crafter/admin/employee/controller/bank_detail/employee_bank_detail_api_provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/controller/employee_api_provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/controller/policy/company_policy_api_provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/controller/work_module/employee_work_api_provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/leave_module/admin_leave_api_provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/salary_slip/controller/admin_emp_salary_slip_api_provider.dart';
import 'package:hrms_management_code_crafter/firebase/firebase_api_controller.dart';
import 'package:hrms_management_code_crafter/screen/auth/controller/auth_provider.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/controller/emp_attendance_chart_provider.dart';
import 'package:hrms_management_code_crafter/screen/emp_leave/controller/emp_leave_api_provider.dart';
import 'package:hrms_management_code_crafter/screen/nav_home/controller/punch_in_out_provider.dart';
 import 'package:hrms_management_code_crafter/splash/controller/network_provider_controller.dart';
import 'package:hrms_management_code_crafter/splash/screen/SplashScreen.dart';
import 'package:hrms_management_code_crafter/ui_helper/app_colors.dart';
import 'package:hrms_management_code_crafter/ui_helper/common_widget/loading_button_provider.dart';
import 'package:hrms_management_code_crafter/ui_helper/theme/app_theme.dart';
import 'package:hrms_management_code_crafter/ui_helper/theme/theme_provider.dart';
import 'package:hrms_management_code_crafter/util/location_service_utils.dart';
import 'package:hrms_management_code_crafter/util/responsive_builder.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';
import 'package:provider/provider.dart';

import 'admin/company_profile/controller/comp_profile_api_provider.dart';
import 'admin/employee/controller/emp_document_module/emp_doc_api_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageHelper().init();
  await Firebase.initializeApp();
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
        ChangeNotifierProvider(create: (context) => NetworkProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LoadingProvider()),
        ChangeNotifierProvider(create: (context) => AuthAPIProvider()),
        ChangeNotifierProvider(create: (context) => AddEmployeeBankDetailApiProvider()),
        ChangeNotifierProvider(create: (context) => EmployeeApiProvider()),
        ChangeNotifierProvider(create: (context) => EmployeeWorkApiProvider()),
        ChangeNotifierProvider(create: (context) => PunchInOutProvider()),
        ChangeNotifierProvider(create: (context) => CompanyPolicyApiProvider()),
        ChangeNotifierProvider(create: (context) => EmployeeLeaveApiProvider()),
        ChangeNotifierProvider(create: (context) => AdminEmployeeLeaveApiProvider()),
        ChangeNotifierProvider(create: (context) => AdminEmpSalarySlipApiProvider()),
        ChangeNotifierProvider(create: (context) => FirebaeApiProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceChartProvider()),
        ChangeNotifierProvider(create: (_) => LocationService()),
        ChangeNotifierProvider(create: (_) => CompanyProfileApiProvider()),
        ChangeNotifierProvider(create: (_) => DocumentUploadProvider()),
      ],
      child: const MyApp(),
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
      // darkTheme: AppTheme.darkTheme,
      // themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) {
                SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
                  statusBarColor: AppColors.primary,
                  statusBarIconBrightness: Brightness.light,
                ));

                return child!;
              },
            ),
          ],
        );
      },
      home: const ResponsiveBuilder(child: SplashScreen()),
    );
  }
}
