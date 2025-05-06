import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/bank_detail/add_emp_bank_detail_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/bank_detail/emp_bank_detail_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/bank_detail/update_emp_bank_model.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';
import '../../../../network_manager/api_exception.dart';
import '../../../../network_manager/dio_error_handler.dart';
import '../../../../network_manager/repository.dart';
import '../../../../util/custom_snack_bar.dart';
import '../../../../util/full_screen_loader_utiil.dart';
import '../../../home/admin_home_screen.dart';

class AddEmployeeBankDetailApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  AddEmpBankDetailsModel? _employeeListModel;
  UpdateEmpBankDetailsModel? _updateBankModel;
  EmpBankDetailsModel? _bankDetailModel;
  AddEmpBankDetailsModel? get employeeListModel => _employeeListModel;
  UpdateEmpBankDetailsModel? get updateBankModel => _updateBankModel;
  EmpBankDetailsModel? get bankDetailModel => _bankDetailModel;

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

  Future<void> addEmployeeBankDetails(BuildContext context,Map<String, dynamic>  requestBody, ) async {

    _setLoadingState(true);
    try {
       employeeId = await StorageHelper().getEmployeeId();
      print("EmployeeId=>${employeeId}");

      var response = await _repository.addEmployeeBankDetail(requestBody,employeeId);
      if (response.success == true) {
        _employeeListModel = response;
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Bank Details Added Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
        Navigator.of(context).pop();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()),);

      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:response.message ?? 'Failed to Add Bank Details!',
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

  Future<bool> getEmployeeBankDetail(String bankID) async {
    _setLoadingState(true);
    _errorMessage = "";
    _bankDetailModel = null;

    try {
      final response = await _repository.getEmployeeBankDetails(bankID);

      if (response.result != null && response.success == true ) {
        print("✅ Employee detail fetched successfully");
        _bankDetailModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _setErrorState(response.message ?? "Failed to fetch employee detail");
      }
    } catch (error) {
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }

  Future<bool> deleteBank( BuildContext context ,String bankId) async {
    // _setLoadingState(true);
    FullScreenLoader.show(context, message: "Deleting...");
    _errorMessage = "";

    try {
      final Map<String, dynamic> response = await _repository.deleteBankDetails(bankId);

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

  Future<void> updateEmployeeBankDetails(BuildContext context,Map<String, dynamic>  requestBody, String bankId) async {

    _setLoadingState(true);
    try {
      print("bankId=>${bankId}");
      var response = await _repository.updateBank(requestBody,bankId);
      if (response.success == true) {
        // _updateBankModel = response;
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Bank Details Updated Successfully!',
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
          message:response.message ?? 'Failed to Update Bank Details!',
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
