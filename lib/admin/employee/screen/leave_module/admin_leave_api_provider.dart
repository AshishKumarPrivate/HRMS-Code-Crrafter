import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/employee_list_detail_model.dart' as empDetailModel;
import 'package:hrms_management_code_crafter/admin/employee/screen/employee_list_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/leave_module/model/all_emp_leave_requests_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/leave_module/model/emp_leave_approved_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/leave_module/model/emp_leave_rejected_model.dart';
import 'package:hrms_management_code_crafter/admin/home/admin_home_screen.dart';
import 'package:hrms_management_code_crafter/bottom_navigation_screen.dart';
import 'package:hrms_management_code_crafter/screen/nav_home/screen/emp_home_screen.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';

import '../../../../network_manager/repository.dart';
import '../../../../util/custom_snack_bar.dart';
import '../../../../util/full_screen_loader_utiil.dart';

class AdminEmployeeLeaveApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  AllEmpLeaveRequestsListModel? _empLeaveRequestListModel;
  LeaveRejectedModel? _leaveRejectedModel;
  LeaveApprovedModel? _leaveApprovedModel;

  // Cache management
  DateTime? _lastFetchTime;
  final Duration _cacheDuration = Duration(minutes: 5); // 5 min cache

  /// Getters for UI
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  AllEmpLeaveRequestsListModel? get empLeaveRequestListModel => _empLeaveRequestListModel;
  LeaveRejectedModel? get leaveRejectedModel => _leaveRejectedModel;
  LeaveApprovedModel? get leaveApprovedModel => _leaveApprovedModel;
  // List<Data> get filteredEmployees => _filteredEmployees;

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

  /// Fetch Employee List
  Future<bool> getAllLeaveRequests({bool forceRefresh = false}) async {
    _setLoadingState(true);
    _errorMessage = "";
    _empLeaveRequestListModel = null;

    try {
      var employeeId =await StorageHelper().getEmpLoginId();
      var response = await _repository.getAllEmpLeaveRequest(); // aapka existing API call

      if (response.success == false) {
        _setErrorState(response.message ?? "No Data Found");
        return false;  // return false if no data
      }
      if (response.success == true  && response.data != null) {
        // if (response.success == true && response.data != null) {
        print("✅ leave list fetched successfully");
        _empLeaveRequestListModel = response;
        // _filteredEmployees = _empLeaveRequestListModel?.data ?? [];
        _lastFetchTime = DateTime.now();
        _setLoadingState(false);
        return true;
      } else {
        _setErrorState(response.message ?? "No Data Found");
      }
    } catch (error) {
      _setErrorState("⚠️ API Error: $error");
    }

    _setLoadingState(false);
    return false;
  }
  /// Delete Employee by ID
  Future<bool> rejectLeave( BuildContext context ,String leaveID, String description) async {
    // _setLoadingState(true);
    FullScreenLoader.show(context, message: "Rejecting...");
    _errorMessage = "";
    _leaveRejectedModel = null;
    try {

      Map<String, dynamic> requestBody = {"adminDescription": description};

      var  response = await _repository.leaveRejectedApi(requestBody,leaveID);
      if (response.success == false) {
        _setErrorState(response.message ?? "No Data Found");
        return false;  // return false if no data
      }
      if (response.success == true  && response.data != null) {
        // if (response.success == true && response.data != null) {
        print("✅ leave Rejected successfully");
        _leaveRejectedModel = response;
        // _setLoadingState(false);
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? "Leave Rejected Successfully",
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        );
        FullScreenLoader.hide(context);  Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
              (Route<dynamic> route) => false,
        );

        return true;
      } else {
        CustomSnackbarHelper.customShowSnackbar(
        context: context,
        message: response.message ?? "Leave Rejected Failed",
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      );
        _setErrorState(response.message ?? "No Data Found");
      }
    } catch (error) {
      FullScreenLoader.hide(context);
      _setErrorState("⚠️ API Error: $error");
    }

    FullScreenLoader.hide(context);
    return false;
  }

  Future<bool> approvedLeave( BuildContext context ,String leaveID, String description) async {
    // _setLoadingState(true);
    FullScreenLoader.show(context, message: "Approve...");
    _errorMessage = "";
    _leaveApprovedModel = null;
    try {

      Map<String, dynamic> requestBody = {"adminDescription": description};

      var  response = await _repository.leaveApproveApi(requestBody,leaveID);
      if (response.success == false) {
        _setErrorState(response.message ?? "No Data Found");
        return false;  // return false if no data
      }
      if (response.success == true  && response.data != null) {
        // if (response.success == true && response.data != null) {
        print("✅ leave Approved successfully");
        _leaveApprovedModel = response;
        // _setLoadingState(false);
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? "Leave Approved Successfully",
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        );
        FullScreenLoader.hide(context);  Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
              (Route<dynamic> route) => false,
        );

        return true;
      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? "Leave Approval Failed",
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        );
        _setErrorState(response.message ?? "No Data Found");
      }
    } catch (error) {
      FullScreenLoader.hide(context);
      _setErrorState("⚠️ API Error: $error");
    }

    FullScreenLoader.hide(context);
    return false;
  }

  /// Pull-to-Refresh Handler
  Future<void> refreshEmployeeList() async {
    await getAllLeaveRequests(forceRefresh: true);
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
