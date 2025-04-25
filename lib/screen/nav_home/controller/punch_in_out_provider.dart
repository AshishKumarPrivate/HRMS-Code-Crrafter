import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/storage_util.dart';

class PunchInOutProvider extends ChangeNotifier {
  DateTime? punchInTime;
  DateTime? punchOutTime;
  Timer? _timer;
  Duration workingDuration = Duration.zero;
  double progress = 0.0;

  final Duration fullDay = Duration(hours: 8);
  final Duration halfDay = Duration(hours: 4);

  PunchInOutProvider() {
    loadPunchData(); // load data initially
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
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateWorkingDuration());
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
      await   StorageHelper().saveWorkingSeconds(workingDuration.inSeconds);

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
    return "$h:$m";
  }

  bool get isPunchedIn => punchInTime != null && punchOutTime == null;
  bool get halfDayReached => workingDuration >= halfDay;

  Future<void> _savePunchData() async {
    await StorageHelper().savePunchIn(punchInTime);
    await  StorageHelper().savePunchOut(punchOutTime);
  }

  /// PUBLIC method to load data
  Future<void> loadPunchData() async {
    try {
      punchInTime = await  StorageHelper().getPunchIn();
      punchOutTime = await  StorageHelper().getPunchOut();
      final seconds = await  StorageHelper().getWorkingSeconds();

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
}
