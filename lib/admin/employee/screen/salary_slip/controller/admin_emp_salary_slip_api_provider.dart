import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/employee_list_detail_model.dart' as empDetailModel;
import 'package:hrms_management_code_crafter/admin/employee/screen/employee_list_screen.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/leave_module/model/all_emp_leave_requests_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/leave_module/model/emp_leave_approved_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/leave_module/model/emp_leave_rejected_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/salary_slip/model/payroll_salary_slip_list_admin_side_model.dart';
import 'package:hrms_management_code_crafter/admin/home/admin_home_screen.dart';
import 'package:hrms_management_code_crafter/bottom_navigation_screen.dart';
import 'package:hrms_management_code_crafter/screen/nav_home/model/emp_salary_slip_emp_side_model.dart';
import 'package:hrms_management_code_crafter/screen/nav_home/screen/emp_home_screen.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';

import '../../../../../../network_manager/repository.dart';
import '../../../../../../util/custom_snack_bar.dart';
import '../../../../../../util/full_screen_loader_utiil.dart';

class AdminEmpSalarySlipApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  PayrollSalarySlipListAdminSideModel? _empSalarySlipListModel;
  EmpSalarySlipEmpSideModel? _empSalarySlipEmpSideModel;

  // Cache management
  DateTime? _lastFetchTime;

  /// Getters for UI
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  PayrollSalarySlipListAdminSideModel? get empSalarySlipListModel => _empSalarySlipListModel;
  EmpSalarySlipEmpSideModel? get empSalarySlipEmpSideModel => _empSalarySlipEmpSideModel;


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
  Future<bool> getAllSalarySlipList({bool forceRefresh = false,String? startDate,  String? endDate}) async {
    _setLoadingState(true);
    _errorMessage = "";
    _empSalarySlipListModel = null;

    try {
      Map<String, dynamic> queryParams = {
        'startDate': startDate,
        'endDate': endDate,
      };
      var response = await _repository.getAllEmpSalarySlipList(queryParams); // aapka existing API call

      if (response.success == false) {
        _setErrorState(response.message ?? "No Data Found");
        return false;  // return false if no data
      }
      if (response.success == true  && response.data != null) {
        // if (response.success == true && response.data != null) {
        print("✅ leave list fetched successfully");
        _empSalarySlipListModel = response;
        // _filteredEmployees = _empSalarySlipListModel?.data ?? [];
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

  Future<void> refreshEmployeeList() async {
    await getAllSalarySlipList(forceRefresh: true);
  }

  Future<void> empSalarySlipEmpSide({required String startDate, required String endDate}) async {
    _setLoadingState(true);
    _errorMessage = "";
    _empSalarySlipEmpSideModel = null;
    try {


      final employeeRegistrationId =  await StorageHelper().getEmpLoginRegistrationId();
      Map<String, dynamic> queryParams = {
        'startDate': startDate,
        'endDate': endDate,
      };
      var response = await _repository.getEmpSalarySlipEmpSide(queryParams,employeeRegistrationId);

      if (response.success == false) {
        _setErrorState("No Data Found");
      } else if (response.success == true && response.data != null) {
        _empSalarySlipEmpSideModel = response;
        _setLoadingState(false);
      } else {
        _setErrorState("No Data Found");
      }
    } catch (e) {
      _setErrorState("⚠️ API Error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }}

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

