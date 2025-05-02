import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/add_employee_admin_model.dart';
import 'package:hrms_management_code_crafter/admin/home/admin_home_screen.dart';
import 'package:hrms_management_code_crafter/screen/user_selection_screen.dart';

import '../../../../bottom_navigation_screen.dart';
import '../../../../network_manager/api_exception.dart';
import '../../../../network_manager/dio_error_handler.dart' show DioErrorHandler;
import '../../../../network_manager/repository.dart';
import '../../../../ui_helper/app_colors.dart';
import '../../../../util/custom_snack_bar.dart';
import '../../../../util/storage_util.dart';

class AdminAuthAPIProvider with ChangeNotifier {
  final Repository _repository = Repository();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Future<void> addEmployee(BuildContext context,FormData  requestBody, ) async {
  //
  //   _setLoading(true);
  //   try {
  //     // Map<String, dynamic> requestBody = {"email": email, "password": password};
  //     var response = await _repository.addEmployee(requestBody);
  //     if (response.success == true) {
  //       CustomSnackbarHelper.customShowSnackbar(
  //         context: context,
  //         message: response.message ?? 'Employee Added Successful!',
  //         backgroundColor: Colors.green,
  //         duration: Duration(seconds: 2),
  //       );
  //       Navigator.of(context).pop();
  //       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()),);
  //
  //     } else {
  //       CustomSnackbarHelper.customShowSnackbar(
  //         context: context,
  //         message:response.message ?? 'Employee Registration Failed!',
  //         backgroundColor: Colors.red,
  //         duration: Duration(seconds: 2),
  //       );
  //     }
  //   } on DioException catch (e) {
  //     final ApiException apiError = DioErrorHandler.handle(e);
  //     CustomSnackbarHelper.customShowSnackbar(
  //       context: context,
  //       message: apiError.message,
  //       backgroundColor: Colors.red,
  //       duration: Duration(seconds: 3),
  //     );
  //   } catch (e) {
  //     _handleUnexpectedErrors(
  //       context,
  //       e,
  //       "Something went wrong! Please try again later.",
  //     );
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  void logoutUser(BuildContext context) {
    _setLoading(true);
    Future.delayed(Duration(seconds: 1), () {
      StorageHelper().logout();
      _setLoading(false);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => UserSelectionScreen()),
        (route) => false,
      );
    });
  }

  void _handleDioErrors(BuildContext context, DioException e) {
    CustomSnackbarHelper.customShowSnackbar(
      context: context,
      message: " ApiErrorHandler.handleError(e)",
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    );
  }

  void _handleUnexpectedErrors(
    BuildContext context,
    dynamic e,
    String message,
  ) {
    CustomSnackbarHelper.customShowSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    );
  }
}
