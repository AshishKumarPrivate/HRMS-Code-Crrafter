import 'dart:convert';

import 'package:hrms_management_code_crafter/admin/employee/model/employee_list_detail_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class  StorageHelper {
  static final StorageHelper _singleton = StorageHelper._internal();
  static const String _employeeDataKey = 'employee_data';

  factory StorageHelper() {
    return _singleton;
  }

  StorageHelper._internal();
  late SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }
   Future<void> savePunchIn(DateTime? time) async {
    await prefs.setString('punchIn', time?.toIso8601String() ?? '');
  }

   Future<void> savePunchOut(DateTime? time) async {
    // final prefs = await SharedPreferences.getInstance();
    await prefs.setString('punchOut', time?.toIso8601String() ?? '');
  }

   Future<void> saveWorkingSeconds(int seconds) async {

    await prefs.setInt('workingSeconds', seconds);
  }

   Future<DateTime?> getPunchIn() async {

    final inStr = prefs.getString('punchIn') ?? '';
    return inStr.isNotEmpty ? DateTime.tryParse(inStr) : null;
  }

   Future<DateTime?> getPunchOut() async {

    final outStr = prefs.getString('punchOut') ?? '';
    return outStr.isNotEmpty ? DateTime.tryParse(outStr) : null;
  }

   Future<int> getWorkingSeconds() async {

    return prefs.getInt('workingSeconds') ?? 0;
  }
   Future<void> clearAll() async {

    await prefs.remove('punchIn');
    await prefs.remove('punchOut');
    await prefs.remove('workingSeconds');
    prefs.clear();
  }

   setUserAccessToken(String token) async{

    prefs.setString('user_access_token', token);
  }

   Future<String> getUserAccessToken()async {

    return prefs.getString('user_access_token') ?? "";
  }
  /// 🔐 Logout and clear user data
   Future<void> logout() async {
    await prefs.clear(); // or use `remove(...)` for selected keys
  }

   Future<void> setUserId(String userId) async {
    await prefs.setString('user_id', userId);
  }
   Future<String> getUserId() async {

    return prefs.getString('user_id') ?? "";
  }

   Future<void> setUserEmail(String email) async {

    await prefs.setString('user_email', email);
  }
   Future<String> getUserEmail() async {

    return prefs.getString('user_email') ?? "";
  }
   Future<void> setUserRole(String email) async {
    await prefs.setString('user_role', email);
  }
   Future<String> getUserRole() async {
    return prefs.getString('user_role') ?? "";
  }

  Future<void> setBoolIsLoggedIn(bool value) async {
    await prefs.setBool("isLoggedIn", value);
  }
  bool getBoolIsLoggedIn() => prefs.getBool("isLoggedIn") ?? false;

  Future<void> saveEmployeeData(Data employee) async {
    String jsonStr = jsonEncode(employee.toJson());
    await prefs.setString(_employeeDataKey, jsonStr);
  }

  Future<Data?> getEmployeeData() async {
    String? jsonStr = prefs.getString(_employeeDataKey);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    return Data.fromJson(jsonMap);
  }

  Future<void> clearEmployeeData() async {
    await prefs.remove(_employeeDataKey);
  }


}
