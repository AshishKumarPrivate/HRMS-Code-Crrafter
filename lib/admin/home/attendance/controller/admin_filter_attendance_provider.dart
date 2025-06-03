import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/admin_filter_attendance_model.dart';

class AttendanceProvider with ChangeNotifier {
  List<Data> _attendanceData = [];

  List<Data> get attendanceData => _attendanceData;

  Future<void> fetchAttendanceData() async {
    final url = Uri.parse('https://yourapi.com/attendance'); // Replace with your API endpoint
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final attendanceModel = AdminFilterAttendanceModel.fromJson(jsonData);
        _attendanceData = attendanceModel.data ?? [];
        notifyListeners();
      } else {
        throw Exception('Failed to load attendance data');
      }
    } catch (error) {
      throw error;
    }
  }
}
