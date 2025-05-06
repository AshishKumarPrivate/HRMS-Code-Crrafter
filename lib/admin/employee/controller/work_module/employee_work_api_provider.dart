import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/bank_detail/add_emp_bank_detail_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/bank_detail/emp_bank_detail_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/bank_detail/update_emp_bank_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/work_module/add_emp_work_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/work_module/emp_work_detail_model.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';
import '../../../../network_manager/api_exception.dart';
import '../../../../network_manager/dio_error_handler.dart';
import '../../../../network_manager/repository.dart';
import '../../../../util/custom_snack_bar.dart';
import '../../../../util/full_screen_loader_utiil.dart';
import '../../../home/admin_home_screen.dart';

class EmployeeWorkApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  AddEmpWorkModel? _addEmployeeWorkModel;
  UpdateEmpBankDetailsModel? _updateBankModel;
  EmpWorkDetailModel? _workDetailModel;

  AddEmpWorkModel? get addEmployeeWorkModel => _addEmployeeWorkModel;
  UpdateEmpBankDetailsModel? get updateBankModel => _updateBankModel;
  EmpWorkDetailModel? get workDetailModel => _workDetailModel;

  var employeeId ;
  /// Set Loading State
  void _setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set Error State
  void _setErrorState(String message) {
    _errorMessage = message;
    _setLoadingState(false);
  }

  Future<void> addEmployeeWorkDetails(BuildContext context,Map<String, dynamic>  requestBody, ) async {

    _setLoadingState(true);
    try {
       employeeId = await StorageHelper().getEmployeeId();
      print("EmployeeId=>${employeeId}");

      var response = await _repository.addEmployeeWork(requestBody,employeeId);
      if (response.success == true) {
        _addEmployeeWorkModel = response;
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Work Details Added Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
        Navigator.of(context).pop();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()),);

      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:response.message ?? 'Failed to Add Work Details!',
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
      _handleUnexpectedErrors(   context,  e, "Something went wrong! Please try again later.", );
    } finally {
      _setLoadingState(false);
    }
  }

  Future<bool> getEmployeeWorkDetail(String empId) async {
    _setLoadingState(true);
    _errorMessage = "";
    _workDetailModel = null;

    try {
      final response = await _repository.getEmployeeWorkDetails(empId);

      if (response.success == true ) {
        print("✅ Employee Work Detail Fetched Successfully");
        _workDetailModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _setErrorState("Failed to Fetch Employee Work details");
      }
    } catch (error) {
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }

  Future<bool> deleteEmpWork( BuildContext context ,String workId) async {
    // _setLoadingState(true);
    FullScreenLoader.show(context, message: "Deleting...");
    _errorMessage = "";

    try {
      final Map<String, dynamic> response = await _repository.deleteWorkDetails(workId);

      final bool success = response['success'] == true;
      final String message = response['message'] ?? "Unknown error";
      // 👇 Hide loader
      FullScreenLoader.hide(context);
      if (success) {
        print("✅ $message");
        // Close the bottom sheet first (safely)
        Navigator.of(context, rootNavigator: true).pop();

        // Then navigate to AdminHomeScreen and clear all back stack
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
                (Route<dynamic> route) => false,
          );
        });

        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: message ?? 'Employee Deleted Successful!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
        return true;
      } else {
        _setErrorState(message);
      }
    } catch (error) {
      FullScreenLoader.hide(context);
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }

  Future<void> updateEmployeeWorkDetails(BuildContext context,Map<String, dynamic>  requestBody, String empWorkId) async {

    _setLoadingState(true);
    try {
      print("bankId=>${empWorkId}");
      var response = await _repository.updateEmpWork(requestBody,empWorkId);
      if (response.success == true) {
        // _updateBankModel = response;
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Work Details Updated Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
        // Navigator.of(context).pop();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AdminHomeScreen()),
              (Route<dynamic> route) => false, // Remove all previous routes
        );
      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:response.message ?? 'Failed to Update Work Details!',
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
      _handleUnexpectedErrors(   context,  e, "Something went wrong! Please try again later.", );
    } finally {
      _setLoadingState(false);
    }
  }


  void _handleUnexpectedErrors( BuildContext context,   dynamic e,  String message,  ) {
    CustomSnackbarHelper.customShowSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    );
  }
}
