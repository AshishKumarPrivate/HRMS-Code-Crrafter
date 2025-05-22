import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../network_manager/repository.dart';
import '../model/emp_chart_attendance_model.dart';

class AttendanceChartProvider extends ChangeNotifier {
  final Repository _repository = Repository();

  AttendanceChartModel? _chartModel;
  bool _isLoading = false;
  String _errorMessage = "";
  String? _error;

  AttendanceChartModel? get chartModel => _chartModel;
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
  }}
