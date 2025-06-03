import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hrms_management_code_crafter/admin/home/attendance/model/admin_filter_attendance_model.dart';
import '../../../network_manager/repository.dart';
import '../model/emp_chart_attendance_model.dart';

class AttendanceChartProvider extends ChangeNotifier {
  final Repository _repository = Repository();

  AttendanceChartModel? _chartModel;
  AdminFilterAttendanceModel? _adminFilterAttendanceModel;
  bool _isLoading = false;
  String _errorMessage = "";
  String? _error;

  AttendanceChartModel? get chartModel => _chartModel;
  AdminFilterAttendanceModel? get adminFilterAttendanceModel => _adminFilterAttendanceModel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get errorMessage => _errorMessage;

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

  Future<void> fetchAttendanceChart({required String employeeId, required String month}) async {
    _setLoadingState(true);
    _errorMessage = "";

    try {
      Map<String, dynamic> queryParams = {
        'id': employeeId,
        'month': month,
      };

      var response = await _repository.getChartAttendance(queryParams);

      if (response.success == false) {
        _setErrorState("No Data Found");
      } else if (response.success == true && response.chart != null) {
        _chartModel = response;
        _setLoadingState(false);
      } else {
        _setErrorState("No Data Found");
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }


  Future<void> filterAttendanceExcel({required String startDate, required String endDate}) async {
    _setLoadingState(true);
    _errorMessage = "";

    try {
      Map<String, dynamic> queryParams = {
        'startDate': startDate,
        'endDate': endDate,
      };

      var response = await _repository.filterAdminAttendanceExcel(queryParams);

      if (response.success == false) {
        _setErrorState("No Data Found");
      } else if (response.success == true && response.data != null) {
        _adminFilterAttendanceModel = response;
        _setLoadingState(false);
      } else {
        _setErrorState("No Data Found");
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }}

