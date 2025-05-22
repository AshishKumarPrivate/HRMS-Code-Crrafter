import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/model/emp_attandance_detail_model_response.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/model/emp_check_in_model_response.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/model/emp_check_out_model_response.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/model/emp_monthly_attendance_history_model.dart';
import 'package:hrms_management_code_crafter/util/date_formate_util.dart';
import 'package:hrms_management_code_crafter/util/full_screen_loader_utiil.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network_manager/api_exception.dart';
import '../../../network_manager/dio_error_handler.dart';
import '../../../network_manager/repository.dart';
import '../../../util/custom_snack_bar.dart';
import '../../../util/storage_util.dart';

class EmpProfileProvider extends ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";

  /// Getters for UI
  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  EmpPunchInModel? _empPunchInModel;
  EmpCheckOUTModelResponse? _empPunchOutModel;
  EmpAttancanceDetailModelResponse? _empAttendanceDetailModel;
  EmpMonthlyAttancanceHistoryModel? _empMonthlyAttendanceModel;

  EmpPunchInModel? get empPunchInModel => _empPunchInModel;

  EmpCheckOUTModelResponse? get empPunchOutModel => _empPunchOutModel;

  EmpAttancanceDetailModelResponse? get empAttendanceDetailModel =>
      _empAttendanceDetailModel;

  EmpMonthlyAttancanceHistoryModel? get empMonthlyAttendanceModel =>
      _empMonthlyAttendanceModel;

  DateTime? punchInTime;
  DateTime? punchOutTime;
  Timer? _timer;
  Duration workingDuration = Duration.zero;
  double progress = 0.0;

  final Duration fullDay = Duration(hours: 8);
  final Duration halfDay = Duration(hours: 4);

  EmpProfileProvider() {
    loadPunchData(); // load data initially
  }

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

  Future<void> punchIn() async {
    punchInTime = DateTime.now();
    punchOutTime = null;
    workingDuration = Duration.zero;
    await _savePunchData();
    _startTimer();
    notifyListeners();
  }

  Future<void> punchOut() async {
    punchOutTime = DateTime.now();
    _stopTimer();
    _calculateFinalDuration();
    await _savePunchData();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (_) => _updateWorkingDuration(),
    );
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _updateWorkingDuration() async {
    if (punchInTime != null && punchOutTime == null) {
      workingDuration = DateTime.now().difference(punchInTime!);
      _updateProgress();
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setInt('workingSeconds', workingDuration.inSeconds);
      await StorageHelper().saveWorkingSeconds(workingDuration.inSeconds);

      notifyListeners();
    }
  }

  void _calculateFinalDuration() {
    if (punchInTime != null && punchOutTime != null) {
      workingDuration = punchOutTime!.difference(punchInTime!);
      _updateProgress();
    }
  }

  void _updateProgress() {
    if (fullDay.inSeconds == 0) return;
    double ratio = workingDuration.inSeconds / fullDay.inSeconds;
    progress = ratio.clamp(0.0, 1.0);
  }

  String getTotalHours() {
    final h = workingDuration.inHours.toString().padLeft(2, '0');
    final m = (workingDuration.inMinutes % 60).toString().padLeft(2, '0');
    final s = (workingDuration.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  bool get isPunchedIn => punchInTime != null && punchOutTime == null;

  bool get halfDayReached => workingDuration >= halfDay;

  Future<void> _savePunchData() async {
    await StorageHelper().savePunchIn(punchInTime);
    await StorageHelper().savePunchOut(punchOutTime);
  }

  /// PUBLIC method to load data
  Future<void> loadPunchData() async {
    try {
      punchInTime = await StorageHelper().getPunchIn();
      punchOutTime = await StorageHelper().getPunchOut();
      final seconds = await StorageHelper().getWorkingSeconds();

      if (punchInTime != null && punchOutTime == null) {
        workingDuration = Duration(seconds: seconds);
        _startTimer();
      } else if (punchInTime != null && punchOutTime != null) {
        _calculateFinalDuration();
      }

      _updateProgress();
      notifyListeners();
    } catch (e) {
      print("Error loading punch data: $e");
    }
  }

  /// api call for check in check out
  Future<void> empCheckIn(BuildContext context) async {
    _setLoadingState(true);
    FullScreenLoader.show(context, message: "Please Wait");
    final employeeRegistrationId =
        await StorageHelper().getEmpLoginRegistrationId();
    print("employeeRegistrationId--- ${employeeRegistrationId}");
    _empPunchInModel = null;
    try {
      // Map<String, dynamic> requestBody = {"email": email, "password": password};
      var response = await _repository.empCheckIn(
        employeeRegistrationId.toString(),
      );

      if (response.success == true) {
        _empPunchInModel = response;
        punchIn();
        final String? utcLoginTime = _empPunchInModel?.addEmployee?.loginTime;
        print(" login time in indian formate =${DateFormatter.formatUtcToReadable(utcLoginTime)}");
        // if (utcLoginTime != null) {
        //   final DateTime utcDateTime = DateTime.parse(utcLoginTime).toUtc();
        //   final DateTime istDateTime = utcDateTime.add(Duration(hours: 5, minutes: 30));
        //   punchInTime = istDateTime;
        //
        //   await StorageHelper().savePunchIn(istDateTime);
        //   _startTimer();
        // }
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Punch In Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Failed to Punch In!',
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
      FullScreenLoader.hide(context);
      _setLoadingState(false);
    }
  }

  /// api call for check in check out
  Future<void> empCheckOut(BuildContext context) async {
    // _setLoadingState(true);
    FullScreenLoader.show(context, message: "Please Wait");
    final employeeRegistrationId =
        await StorageHelper().getEmpLoginRegistrationId();
    print("employeeRegistrationId--- ${employeeRegistrationId}");
    _empPunchOutModel = null;
    try {
      // Map<String, dynamic> requestBody = {"email": email, "password": password};
      var response = await _repository.empCheckOUT(
        employeeRegistrationId.toString(),
      );

      if (response.success == true) {
        // FullScreenLoader.hide(context);
        // notifyListeners();
        // _setLoadingState(false);
        _empPunchOutModel = response;
        punchOut();
        final String? utcLogOUTTime = _empPunchOutModel?.data?.logoutTime;
        print(" Logout time in indian formate =${DateFormatter.formatUtcToReadable(utcLogOUTTime)}");
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Punch Out Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
      } else {
        // FullScreenLoader.hide(context);
        // notifyListeners();
        // _setLoadingState(false);
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Failed to Punch Out!',
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
      FullScreenLoader.hide(context);
      _setLoadingState(false);
    }
  }

  Future<void> empAttendanceDetail(BuildContext context) async {
    _setLoadingState(true);
    // FullScreenLoader.show(context, message: "Please Wait");
    final empLoginId = await StorageHelper().getEmpLoginId();
    print("empLoginId--- ${empLoginId}");
    _empAttendanceDetailModel = null;
    try {
      // Map<String, dynamic> requestBody = {"email": email, "password": password};
      var response = await _repository.empAttendanceDetail(
        empLoginId.toString(),
      );

      if (response.success == true) {
        // FullScreenLoader.hide(context);
        // notifyListeners();
        // _setLoadingState(false);
        _empAttendanceDetailModel = response;
        punchOut();
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:
              response.message ?? 'Attendance Detail Fetched Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
      } else {
        // FullScreenLoader.hide(context);
        // notifyListeners();
        // _setLoadingState(false);
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Failed to Fetch Attendance Detail!',
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
      // FullScreenLoader.hide(context);
      _setLoadingState(false);
    }
  }

  Future<void> empMonthlyAttendanceHistory(BuildContext context, String month , String year) async {
    _setLoadingState(true);
    // FullScreenLoader.show(context, message: "Please Wait");

    final empLoginId = await StorageHelper().getEmpLoginId();
    print("empLoginId--- ${empLoginId}");
    _empMonthlyAttendanceModel = null;
    try {
      Map<String, dynamic> requestBody = {
        "employeeId": empLoginId,
        "month": month,
        "year": year,
      };
      var response = await _repository.empMonthlyAttendanceHistory(requestBody);

      if (response.success == true) {
        // FullScreenLoader.hide(context);
        // notifyListeners();
        // _setLoadingState(false);
        _empMonthlyAttendanceModel = response;
        punchOut();
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Attendance History Fetched Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
      } else {
        // FullScreenLoader.hide(context);
        // notifyListeners();
        // _setLoadingState(false);
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ??  'Failed to Fetch Attendance History!',
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
      // FullScreenLoader.hide(context);
      _setLoadingState(false);
    }
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
