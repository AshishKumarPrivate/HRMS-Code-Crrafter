import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/model/check_status_model.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/model/emp_attandance_detail_model_response.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/model/emp_check_in_model_response.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/model/emp_check_out_model_response.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/model/emp_monthly_attendance_history_model.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/model/emp_single_profile_model.dart';
import 'package:hrms_management_code_crafter/ui_helper/app_colors.dart';
import 'package:hrms_management_code_crafter/util/date_formate_util.dart';
import 'package:hrms_management_code_crafter/util/full_screen_loader_utiil.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network_manager/api_exception.dart';
import '../../../network_manager/dio_error_handler.dart';
import '../../../network_manager/repository.dart';
import '../../../util/custom_snack_bar.dart';
import '../../../util/location_service_utils.dart';
import '../../../util/storage_util.dart';

class PunchInOutProvider extends ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  EmpPunchInModel? _empPunchInModel;
  EmpCheckOUTModelResponse? _empPunchOutModel;
  EmpAttancanceDetailModelResponse? _empAttendanceDetailModel;
  EmpMonthlyAttancanceHistoryModel? _empMonthlyAttendanceModel;
  EmpSingleProfileModel? _empSingleProfileDetailModel;
  CheckInStatusModelResponse? _empCheckInStatusModel;

  EmpPunchInModel? get empPunchInModel => _empPunchInModel;
  EmpCheckOUTModelResponse? get empPunchOutModel => _empPunchOutModel;
  EmpAttancanceDetailModelResponse? get empAttendanceDetailModel => _empAttendanceDetailModel;
  EmpMonthlyAttancanceHistoryModel? get empMonthlyAttendanceModel =>_empMonthlyAttendanceModel;
  EmpSingleProfileModel? get empSingleProfileDetailModel =>  _empSingleProfileDetailModel;
  CheckInStatusModelResponse? get empCheckInStatusModel =>  _empCheckInStatusModel;

  DateTime? punchInTime; // Stored as UTC
  DateTime? punchOutTime; // Stored as UTC
  Timer? _timer;
  Duration workingDuration = Duration.zero;
  double progress = 0.0;

  final Duration fullDay = Duration(hours: 8);
  final Duration halfDay = Duration(hours: 4);

  PunchInOutProvider() {
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

  // apiPunchInTime should be UTC from the API
  Future<void> punchIn({required DateTime apiPunchInTime}) async {
    punchInTime = apiPunchInTime; // Store as UTC
    print("Punch In Time (UTC from API): ${punchInTime}");
    punchOutTime = null;
    workingDuration = Duration.zero;
    await _savePunchData();
    _startTimer();
    notifyListeners();
  }

  // apiPunchOutTime should be UTC from the API
  Future<void> punchOut({required DateTime apiPunchOutTime}) async {
    punchOutTime = apiPunchOutTime; // Store as UTC
    print("Punch Out Time (UTC from API): ${punchOutTime}");
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
    _timer = null;
  }

  void _updateWorkingDuration() async {
    if (punchInTime != null && punchOutTime == null) {
      workingDuration = DateTime.now().toUtc().difference(punchInTime!);
      print("PunchInTime (UTC): ${punchInTime} | Current UTC: ${DateTime.now().toUtc()} | Working Duration: ${workingDuration}");
      _updateProgress();
      await StorageHelper().saveWorkingSeconds(workingDuration.inSeconds);
      notifyListeners();
    }
  }

  void _calculateFinalDuration() {
    if (punchInTime != null && punchOutTime != null) {
      // Both are UTC, direct difference
      workingDuration = punchOutTime!.difference(punchInTime!);
      _updateProgress();
    }
  }

  Color get progressColor {
    return workingDuration >= fullDay ? Colors.green : AppColors.primary;
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
      // Retrieve stored times. Assume they were saved as UTC.
      punchInTime = await StorageHelper().getPunchIn();
      punchOutTime = await StorageHelper().getPunchOut();
      final seconds = await StorageHelper().getWorkingSeconds();

      if (punchInTime != null && punchOutTime == null) {
        workingDuration = Duration(seconds: seconds);
        _startTimer();
      } else if (punchInTime != null && punchOutTime != null) {
        _calculateFinalDuration();
        _stopTimer(); // Ensures timer doesn't run if already punched out
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
    final employeeRegistrationId =  await StorageHelper().getEmpLoginRegistrationId();
    print("employeeRegistrationId--- ${employeeRegistrationId}");
    _empPunchInModel = null;
    try {
      final locationService = LocationService();
      await locationService.getLocationAndAddress();
      final position = locationService.currentPosition;

      if (position == null) {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:  'Failed to Punch In! Location not available. Please enable GPS.',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
        return;
        // throw Exception("Location not available. Please enable GPS.");
      }

      double latitude = position.latitude;
      double longitude = position.longitude;
      print("Lat: $latitude, Lon: $longitude");

      Map<String, dynamic> requestBody = {
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
      };

      var response = await _repository.empCheckIn(
        employeeRegistrationId.toString(),
          requestBody
      );

      if (response.success == true) {
        _empPunchInModel = response;
        final String? utcLoginTime = _empPunchInModel?.addEmployee?.loginTime;
        print("Login time (UTC from API): $utcLoginTime | Login time (Local): ${DateFormatter.formatUtcToReadable(utcLoginTime)}");

        try {
          final parsedLoginTimeUtc = DateTime.parse(utcLoginTime ?? '');
          // Convert UTC to IST (UTC+5:30)
          final parsedLoginTimeIst = parsedLoginTimeUtc.add(Duration(hours: 5, minutes: 30));
          final formattedLoginTimeIst = DateFormat('hh:mm:ss a').format(parsedLoginTimeIst);
          print("Login time (IST converted and formatted): $formattedLoginTimeIst");
          await punchIn(apiPunchInTime: parsedLoginTimeUtc.toUtc());

          CustomSnackbarHelper.customShowSnackbar(
            context: context,
            message: 'Punch In Successfully at $formattedLoginTimeIst!', // Display formatted IST time
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4), // Increased duration to read time
          );

        } catch (e) {
          print("Error parsing loginTime from API: $e. Falling back to current UTC time.");
          await punchIn(apiPunchInTime: DateTime.now().toUtc());
          CustomSnackbarHelper.customShowSnackbar(
            context: context,
            message: response.message ?? 'Punch In Successfully!',
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          );
        }


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
    FullScreenLoader.show(context, message: "Please Wait");
    final employeeRegistrationId =  await StorageHelper().getEmpLoginRegistrationId();
    print("employeeRegistrationId--- ${employeeRegistrationId}");
    _empPunchOutModel = null;
    try {
      var response = await _repository.empCheckOUT(
        employeeRegistrationId.toString(),
      );

      if (response.success == true) {
        _empPunchOutModel = response;
        final String? utcLogoutTime = _empPunchOutModel?.data?.logoutTime;
        print( "Logout time (UTC from API): $utcLogoutTime | Logout time (Local): ${DateFormatter.formatUtcToReadable(utcLogoutTime)}");

        try {
          final parsedLogoutTime = DateTime.parse(utcLogoutTime ?? '');
          // Convert UTC to IST (UTC+5:30)
          final parsedLogoutTimeIst = parsedLogoutTime.add(Duration(hours: 5, minutes: 30));
          // Format to Indian format with AM/PM
          final formattedLogoutTimeIst = DateFormat('hh:mm:ss a').format(parsedLogoutTimeIst);

          // Call punchOut with the UTC time from the API
          await punchOut(apiPunchOutTime: parsedLogoutTime.toUtc());

          CustomSnackbarHelper.customShowSnackbar(
            context: context,
            message: 'Punch Out Successfully at $formattedLogoutTimeIst!', // Display formatted IST time
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4), // Increased duration to read time
          );

        } catch (e) {
          print("Error parsing logoutTime from API: $e. Falling back to current UTC time.");
          await punchOut(apiPunchOutTime: DateTime.now().toUtc());
          CustomSnackbarHelper.customShowSnackbar(
            context: context,
            message: response.message ?? 'Punch Out Successfully!',
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          );
        }

        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Punch Out Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
      } else {
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
      // _setLoadingState(false); // Make sure to set loading state to false on error
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


  Future<void> checkInStatus(BuildContext context) async {
    // _setLoadingState(true);
    FullScreenLoader.show(context, message: "Please Wait"); // Loader can be controlled here

    final employeeRegistrationId =  await StorageHelper().getEmpLoginRegistrationId();
    print("employeeRegistrationId--- ${employeeRegistrationId}");
    _empCheckInStatusModel = null;

    try {
      var response = await _repository.checkInStatusApi(
        employeeRegistrationId.toString(),
      );

      if (response.success == true  && response.data != null) {
        _empCheckInStatusModel = response;

        try {
          final String? utcLoginTime = _empCheckInStatusModel?.data?.loginTime;
          final parsedLoginTimeUtc = DateTime.parse(utcLoginTime ?? '');
          // Convert UTC to IST (UTC+5:30)
          final parsedLoginTimeIst = parsedLoginTimeUtc.add(Duration(hours: 5, minutes: 30));
          final formattedLoginTimeIst = DateFormat('hh:mm:ss a').format(parsedLoginTimeIst);
          print("Login time (IST converted and formatted): $formattedLoginTimeIst");
          await punchIn(apiPunchInTime: parsedLoginTimeUtc.toUtc());

          CustomSnackbarHelper.customShowSnackbar(
            context: context,
            message: 'Already Checked In',
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          );

        } catch (e) {
          print("Error parsing loginTime from API: $e. Falling back to current UTC time.");
          // await punchIn(apiPunchInTime: DateTime.now().toUtc());
          CustomSnackbarHelper.customShowSnackbar(
            context: context,
            message: 'Failed to Check Status!',
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          );
        }

      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: 'Not Checked In',
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
      FullScreenLoader.hide(context); // Hide loader here
      // _setLoadingState(false);
    }
  }

  Future<void> empAttendanceDetail(BuildContext context) async {
    _setLoadingState(true);
    // FullScreenLoader.show(context, message: "Please Wait"); // Loader can be controlled here
    final empLoginId = await StorageHelper().getEmpLoginId();
    print("empLoginId--- ${empLoginId}");
    _empAttendanceDetailModel = null;
    try {
      var response = await _repository.empAttendanceDetail(
        empLoginId.toString(),
      );

      if (response.success == true  && response.data != null) {
        _empAttendanceDetailModel = response;
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:
          response.message ?? 'Attendance Detail Fetched Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
      } else {
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
      // FullScreenLoader.hide(context); // Hide loader here
      _setLoadingState(false);
    }
  }

  Future<void> empMonthlyAttendanceHistory(
      BuildContext context,String employeeId, String month, String year) async {
    _setLoadingState(true);
    // FullScreenLoader.show(context, message: "Please Wait");

    // final empLoginId = await StorageHelper().getEmpLoginId();
    print("empLoginId--- ${employeeId}");
    _empMonthlyAttendanceModel = null;
    try {
      Map<String, dynamic> requestBody = {
        "employeeId": employeeId,
        "month": month,
        "year": year,
      };
      var response = await _repository.empMonthlyAttendanceHistory(requestBody);

      if (response.success == true) {
        _empMonthlyAttendanceModel = response;
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:
          response.message ?? 'Attendance History Fetched Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:
          response.message ?? 'Failed to Fetch Attendance History!',
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

  Future<void> empSingleProfile(BuildContext context) async {
    _setLoadingState(true);
    // FullScreenLoader.show(context, message: "Please Wait");
    final empLoginId = await StorageHelper().getEmpLoginId();
    print("empLoginId--- ${empLoginId}");
    _empSingleProfileDetailModel = null;
    try {
      var response = await _repository.empSingleProfile(
        empLoginId.toString(),
      );

      if (response.success == true) {
        _empSingleProfileDetailModel = response;
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Profile Detail Fetched Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Failed to Fetch Profile Detail!',
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