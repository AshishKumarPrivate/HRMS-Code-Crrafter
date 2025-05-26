import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/home/admin_home_screen.dart';
import 'package:hrms_management_code_crafter/screen/auth/model/user_and_admin_login_model.dart';

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
      final String fcmToken = await StorageHelper().getFCMToken();
      Map<String, dynamic> requestBody = {"email": email, "password": password, "fcmToken": fcmToken};
      var response = await _repository.userLogin(requestBody);
      if (response.success == true && response.data != null) {
        if (response.data!.role == "Admin") {
          /// admin login id set here
          await StorageHelper().setAdminLoginId(response.data!.id.toString());
          await StorageHelper().setAdminLoginEmail(response.data!.email.toString());
          await StorageHelper().setUserRole(response.data!.role.toString());
          await StorageHelper().setBoolIsLoggedIn(true);
          /// admin login id set here

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
                (Route<dynamic> route) => false,
          );
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(builder: (context) => AdminHomeScreen())
          // );
        } else if (response.data!.role == "employee") {

          await setLoginUserData(response);
          print("EmploginData=>>${response.employeeeData!.name.toString()} ");
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

  Future<void> setLoginUserData(UserAndAdminLoginModelResponse response) async {
    if (response.data != null) {

      // await StorageHelper().setUserRole(response.data!.role.toString());
      await StorageHelper().setEmpLoginId(response.employeeeData!.sId.toString());
      await StorageHelper().setEmpLoginName(response.employeeeData!.name.toString());
      await StorageHelper().setEmpLoginEmail(response.employeeeData!.email.toString());
      await StorageHelper().setEmpLoginWorkEmail(response.employeeeData!.workEmail.toString());
      await StorageHelper().setEmpLoginMobile(response.employeeeData!.mobile.toString());
      await StorageHelper().setEmpLoginAlternateMobile(response.employeeeData!.alternateMobile.toString());
      await StorageHelper().setEmpLoginDOB(response.employeeeData!.dob.toString());
      await StorageHelper().setEmpLoginGender(response.employeeeData!.gender.toString());
      await StorageHelper().setEmpLoginAddress(response.employeeeData!.address.toString());
      await StorageHelper().setEmpLoginState(response.employeeeData!.state.toString());
      await StorageHelper().setEmpLoginCity(response.employeeeData!.city.toString());
      await StorageHelper().setEmpLoginQualification(response.employeeeData!.qualification.toString());
      await StorageHelper().setEmpLoginExperience(response.employeeeData!.experience.toString());
      await StorageHelper().setEmpLoginMaritalStatus(response.employeeeData!.maritalStatus.toString());
      await StorageHelper().setEmpLoginChildren(response.employeeeData!.children.toString());
      await StorageHelper().setEmpLoginEmergencyContact(response.employeeeData!.emergencyContact.toString());
      await StorageHelper().setUserRole(response.employeeeData!.role.toString());
      await StorageHelper().setEmpLoginToken(response.employeeeData!.token.toString());
      await StorageHelper().setEmpLoginRegistrationId(response.employeeeData!.registrationId.toString());
      await StorageHelper().setEmpLoginBankId(response.employeeeData!.bankId.toString());
      await StorageHelper().setEmpLoginWorkId(response.employeeeData!.workId.toString());
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
