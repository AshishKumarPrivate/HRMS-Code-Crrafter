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
     await prefs.remove('user_id');
     await prefs.remove('user_email');
     await prefs.remove('user_role');
     await prefs.remove('isLoggedIn');
     await prefs.remove('user_access_token');
     await prefs.remove(_employeeDataKey);
     await prefs.remove('punchIn');
     await prefs.remove('punchOut');
     await prefs.remove('workingSeconds');
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

  // 🔍 Specific Getters for Employee Fields

  Future<String?> getEmployeeId() async => (await getEmployeeData())?.sId;
  Future<String?> getEmployeeName() async => (await getEmployeeData())?.name;
  Future<String?> getEmployeeEmail() async => (await getEmployeeData())?.email;
  Future<String?> getEmployeeWorkEmail() async => (await getEmployeeData())?.workEmail;
  Future<String?> getEmployeeMobile() async => (await getEmployeeData())?.mobile;
  // Future<String?> getEmployeeAlternateMobile() async => (await getEmployeeData())?.alternateMobile;
  Future<String?> getEmployeeDob() async => (await getEmployeeData())?.dob;
  Future<String?> getEmployeeGender() async => (await getEmployeeData())?.gender;
  Future<String?> getEmployeeAddress() async => (await getEmployeeData())?.address;
  Future<String?> getEmployeeState() async => (await getEmployeeData())?.state;
  Future<String?> getEmployeeCity() async => (await getEmployeeData())?.city;
  Future<String?> getEmployeeQualification() async => (await getEmployeeData())?.qualification;
  Future<String?> getEmployeeExperience() async => (await getEmployeeData())?.experience;
  Future<String?> getEmployeeMaritalStatus() async => (await getEmployeeData())?.maritalStatus;
  // Future<String?> getEmployeeChildren() async => (await getEmployeeData())?.children;
  // Future<String?> getEmployeeEmergencyContact() async => (await getEmployeeData())?.emergencyContact;
  Future<String?> getEmployeeRoleDetail() async => (await getEmployeeData())?.role;
  Future<String?> getEmployeeToken() async => (await getEmployeeData())?.token;
  Future<String?> getEmployeeCreatedAt() async => (await getEmployeeData())?.createdAt;
  Future<String?> getEmployeeUpdatedAt() async => (await getEmployeeData())?.updatedAt;
  Future<String?> getEmployeeRegistrationId() async => (await getEmployeeData())?.registrationId;
  // Future<String?> getEmployeeBankId() async => (await getEmployeeData())?.bankId;
  /// bank details
  Future<String?> getEmployeeBankId() async => (await getEmployeeData())?.bankId?.sId;
  Future<String?> getEmployeeBankName() async => (await getEmployeeData())?.bankId?.bankName;
  Future<String?> getEmployeeBankAccountNumber() async => (await getEmployeeData())?.bankId?.accountNumber;
  Future<String?> getEmployeeBankBranch() async => (await getEmployeeData())?.bankId?.branch;
  Future<String?> getEmployeeBankIFSC() async => (await getEmployeeData())?.bankId?.ifscCode;
  Future<String?> getEmployeeBankCode() async => (await getEmployeeData())?.bankId?.bankCode;
  Future<String?> getEmployeeBankAddress() async => (await getEmployeeData())?.bankId?.bankAddress;
  /// Wrok details
  Future<String?> getEmployeeWorkId() async => (await getEmployeeData())?.workId?.sId;
  Future<String?> getEmployeeWorkCompanyName() async => (await getEmployeeData())?.workId?.company;
  Future<String?> getEmployeeDepartment() async => (await getEmployeeData())?.workId?.department;
  Future<String?> getEmployeeJoiningDate() async => (await getEmployeeData())?.workId?.joiningDate;
  Future<String?> getEmployeeJobPosition() async => (await getEmployeeData())?.workId?.jobPosition;
  Future<String?> getEmployeeSalary() async => (await getEmployeeData())?.workId?.salary;
  Future<String?> getEmployeeWorkLocation() async => (await getEmployeeData())?.workId?.workLocation;
  Future<String?> getEmployeeWork() async => (await getEmployeeData())?.workId?.workType;


}
