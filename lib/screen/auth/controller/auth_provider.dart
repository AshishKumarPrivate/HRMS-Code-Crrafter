import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/home/admin_home_screen.dart';

import '../../../bottom_navigation_screen.dart';
import '../../../network_manager/api_exception.dart';
import '../../../network_manager/dio_error_handler.dart' show DioErrorHandler;
import '../../../network_manager/repository.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../util/custom_snack_bar.dart';
import '../../../util/full_screen_loader_utiil.dart';
import '../../../util/storage_util.dart';
import '../../user_selection_screen.dart';
import '../model/user_login_model.dart';

class AuthAPIProvider with ChangeNotifier {
  final Repository _repository = Repository();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> userLogin(
    BuildContext context,
    String email,
    String password,
  ) async {
    _setLoading(true);
    try {
      Map<String, dynamic> requestBody = {"email": email, "password": password};
      var response = await _repository.userLogin(requestBody);
      if (response.success == true && response.data != null) {
        await setLoginUserData(response);
        if (response.data!.role == "Admin") {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
                (Route<dynamic> route) => false,
          );
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(builder: (context) => AdminHomeScreen())
          // );
        } else if (response.data!.role == "employee") {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const UserBottomNavigationScreen()),
                (Route<dynamic> route) => false,
          );

          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => UserBottomNavigationScreen(),
          //   ),
          // );
        }
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Login successful!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Login failed!',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
    } on DioException catch (e) {
      final ApiException apiError = DioErrorHandler.handle(e);
      CustomSnackbarHelper.customShowSnackbar(
        context: context,
        message: apiError.message,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      _handleUnexpectedErrors(
        context,
        e,
        "Something went wrong! Please try again later.",
      );
    } finally {
      _setLoading(false);
    }
  }

  // void logoutUser(BuildContext context) {
  //   FullScreenLoader.show(context, message: "Logout");
  //   Future.delayed(Duration(seconds: 5), () {
  //     StorageHelper().logout();
  //     FullScreenLoader.hide(context);
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => UserSelectionScreen()),
  //       (route) => false,
  //     );
  //   });
  // }
  void logoutUser(BuildContext context) {
    // _setLoading(true);
    FullScreenLoader.show(context, message: "Logout");
    Future.delayed(Duration(seconds: 1), () {
      StorageHelper().logout();
      // _setLoading(false);
      FullScreenLoader.hide(context);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => UserSelectionScreen()),
            (route) => false,
      );
    });
  }

  Future<void> setLoginUserData(UserLoginModelResponse response) async {
    if (response.data != null) {
      await StorageHelper().setUserId(response.data!.id.toString());
      await StorageHelper().setUserEmail(response.data!.email.toString());
      await StorageHelper().setUserRole(response.data!.role.toString());
      await StorageHelper().setBoolIsLoggedIn(true);
    } else {
      await StorageHelper().clearAll();
    }
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
