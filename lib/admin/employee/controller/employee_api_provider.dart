import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/employee_list_detail_model.dart' as empDetailModel;
import 'package:hrms_management_code_crafter/admin/employee/screen/employee_list_screen.dart';
import 'package:hrms_management_code_crafter/admin/home/admin_home_screen.dart';

import '../../../network_manager/api_exception.dart';
import '../../../network_manager/dio_error_handler.dart';
import '../../../network_manager/repository.dart';
import '../../../util/custom_snack_bar.dart';
import '../../../util/full_screen_loader_utiil.dart';
import '../model/employee_list_model.dart';


class EmployeeApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  EmployeeListModelResponse? _employeeListModel;
  empDetailModel.EmployeeListDetailModelResponse? _employeeListDetailModel;

  List<Data> _filteredEmployees = [];

  // Cache management
  DateTime? _lastFetchTime;
  final Duration _cacheDuration = Duration(minutes: 5); // 5 min cache

  /// Getters for UI
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  EmployeeListModelResponse? get employeeListModel => _employeeListModel;
  empDetailModel.EmployeeListDetailModelResponse? get employeeListDetailModel => _employeeListDetailModel;
  List<Data> get filteredEmployees => _filteredEmployees;

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

  Future<void> addEmployee(BuildContext context,FormData  requestBody, ) async {

    _setLoadingState(true);
    try {
      // Map<String, dynamic> requestBody = {"email": email, "password": password};
      var response = await _repository.addEmployee(requestBody);
      if (response.success == true) {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Employee Added Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
        Navigator.of(context).pop();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()),);

      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:response.message ?? 'Employee Registration Failed!',
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
      _setLoadingState(false);
    }
  }

  Future<void> updateEmployee(BuildContext context,FormData  requestBody, String employeeId ) async {

    _setLoadingState(true);
    try {
      // Map<String, dynamic> requestBody = {"email": email, "password": password};
      var response = await _repository.updateEmployee(requestBody,employeeId);
      if (response.success == true) {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Employee Updated Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
        // Navigator.of(context).pop();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
              (Route<dynamic> route) => false,
        );
      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:response.message ?? 'Employee Registration Failed!',
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
      _setLoadingState(false);
    }
  }
  /// Fetch Employee List
  Future<bool> getEmployeeList({bool forceRefresh = false}) async {
    // Cache handling
    // if (!forceRefresh && _employeeListModel != null && _lastFetchTime != null) {
    //   final timeDiff = DateTime.now().difference(_lastFetchTime!);
    //   if (timeDiff < _cacheDuration) {
    //     print("🟢 Using cached employee list data");
    //     return true;
    //   }
    // }
    //
    // if (forceRefresh) {
    //   _lastFetchTime = null;
    // }

    _setLoadingState(true);
    _errorMessage = "";
    _employeeListModel = null;

    try {
      var response = await _repository.getAllEmployeeList(); // aapka existing API call

      if (response.data != null) {
      // if (response.success == true && response.data != null) {
        print("✅ Employee list fetched successfully");
        _employeeListModel = response;
        _filteredEmployees = _employeeListModel?.data ?? [];
        _lastFetchTime = DateTime.now();
        _setLoadingState(false);
        return true;
      } else {
        _employeeListModel = null;
        _setErrorState(response.message ?? "Failed to fetch employee list");
      }
    } catch (error) {
      _employeeListModel = null;
      _setErrorState("⚠️ API Error: $error");
    }

    _setLoadingState(false);
    return false;
  }
  /// Fetch Employee Detail by ID
  Future<bool> getEmployeeDetail(String employeeId) async {
    _setLoadingState(true);
    _errorMessage = "";
    _employeeListDetailModel = null;

    try {
      final response = await _repository.getEmployeeDetail(employeeId);

      if (response.data != null) {
        print("✅ Employee detail fetched successfully");
        _employeeListDetailModel = response;
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
  /// Delete Employee by ID
  Future<bool> deleteEmployee( BuildContext context ,String employeeId) async {
    // _setLoadingState(true);
    FullScreenLoader.show(context, message: "Deleting...");
    _errorMessage = "";

    try {
      final Map<String, dynamic> response = await _repository.deleteEmployee(employeeId);

      final bool success = response['success'] == true;
      final String message = response['message'] ?? "Unknown error";
      // 👇 Hide loader
      if (success) {
        FullScreenLoader.hide(context);
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

  /// Pull-to-Refresh Handler
  Future<void> refreshEmployeeList() async {
    await getEmployeeList(forceRefresh: true);
  }
  /// Filter Employees by Search Query
  void filterEmployees(String query) {
    if (_employeeListModel?.data == null || query.isEmpty) {
      _filteredEmployees = _employeeListModel?.data ?? [];
    } else {
      _filteredEmployees = _employeeListModel!.data!
          .where((employee) =>
      (employee.name?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          (employee.email?.toLowerCase().contains(query.toLowerCase()) ?? false))
          .toList();
    }
    notifyListeners();
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
