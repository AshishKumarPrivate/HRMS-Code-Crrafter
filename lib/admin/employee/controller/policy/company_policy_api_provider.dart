import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/bank_detail/add_emp_bank_detail_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/bank_detail/emp_bank_detail_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/bank_detail/update_emp_bank_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/policy/all_cmp_policy_list_model_response.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';
import '../../../../network_manager/api_exception.dart';
import '../../../../network_manager/dio_error_handler.dart';
import '../../../../network_manager/repository.dart';
import '../../../../util/custom_snack_bar.dart';
import '../../../../util/full_screen_loader_utiil.dart';
import '../../../home/admin_home_screen.dart';
import '../../model/policy/add_cmp_policy_model_response.dart';

class CompanyPolicyApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  AddCompanyPolicyModel? _addPolicyModel;
  UpdateEmpBankDetailsModel? _updateBankModel;
  CompanyPolicyListModelResponse? _policyListModel;
  AddCompanyPolicyModel? get employeeListModel => _addPolicyModel;
  UpdateEmpBankDetailsModel? get updateBankModel => _updateBankModel;
  CompanyPolicyListModelResponse? get policyListModel => _policyListModel;

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

  Future<void> addPolicy(BuildContext context,Map<String, dynamic>  requestBody, ) async {

    _setLoadingState(true);
    try {
       employeeId = await StorageHelper().getEmployeeId();
      print("EmployeeId=>${employeeId}");

      var response = await _repository.addCompanyPolicy(requestBody);
      if (response.success == true) {
        _addPolicyModel = response;
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Policy Details Added Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
        Navigator.of(context).pop();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()),);

      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:response.message ?? 'Failed to Add Policy Details!',
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

  Future<bool> getAllPolicyList({bool forceRefresh = false}) async {
    _setLoadingState(true);
    _errorMessage = "";
    _policyListModel = null;

    try {
      final response = await _repository.getAllPolicyList();

      if (response.data != null && response.success == true ) {
        print("✅ Policy List fetched successfully");
        _policyListModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _setErrorState(response.message ?? "Failed to fetch Policy detail");
      }
    } catch (error) {
      _setErrorState("⚠️ API Error: $error");
    }

    _setLoadingState(false);
    return false;
  }

  Future<bool> deletePolicy( BuildContext context ,String policyID) async {
    // _setLoadingState(true);
    FullScreenLoader.show(context, message: "Deleting...");
    _errorMessage = "";

    try {
      final Map<String, dynamic> response = await _repository.deletePolicy(policyID);

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

  Future<void> updatePolicyDetails(BuildContext context,Map<String, dynamic>  requestBody, String policyId) async {

    _setLoadingState(true);
    try {
      print("policyId=>${policyId}");
      var response = await _repository.updatePolicy(requestBody,policyId);
      if (response.success == true) {
        // _updateBankModel = response;
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Policy Details Updated Successfully!',
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
          message:response.message ?? 'Failed to Update Policy Details!',
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
  /// Pull-to-Refresh Handler
  Future<void> refreshEmployeeList() async {
    await getAllPolicyList(forceRefresh: true);
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
