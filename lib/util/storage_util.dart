import 'dart:convert';

import 'package:hrms_management_code_crafter/admin/employee/model/employee_list_detail_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class  StorageHelper {
  static final StorageHelper _singleton = StorageHelper._internal();
  static const String _employeeDataKey = 'employee_data';

  static const String _imagePathKey = 'last_captured_image_path';


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

  static Future<void> saveImagePath(String imagePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imagePathKey, imagePath);
  }

  /// Loads the saved image path from SharedPreferences.
  /// Returns the image path if found, otherwise returns null.
  static Future<String?> loadImagePath() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_imagePathKey);
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
  Future<void> removePunchIn() async {
    await prefs.remove("punchIn");
  }

  Future<void> removePunchOut() async {
    await prefs.remove("punchOut");
  }

  Future<void> removeWorkingSeconds() async {
    await prefs.remove("workingSeconds");
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
     // await prefs.remove('user_id');
     // await prefs.remove('user_email');
     // await prefs.remove('user_role');
     await prefs.remove('isLoggedIn');
    //  await prefs.remove('user_access_token');
    //  await prefs.remove(_employeeDataKey);
    //  // await prefs.remove('punchIn');
    //  // await prefs.remove('punchOut');
    //  // await prefs.remove('workingSeconds');
    // await prefs.clear(); // or use `remove(...)` for selected keys
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

  void setFCMToken(String token) {
    prefs.setString('fcm_token', token);
  }

  String getFCMToken() {
    return prefs.getString('fcm_token') ?? "";
  }

  //  Future<void> setUserRole(String email) async {
  //   await prefs.setString('user_role', email);
  // }
  //  Future<String> getUserRole() async {
  //   return prefs.getString('user_role') ?? "";
  // }

  Future<void> setBoolIsLoggedIn(bool value) async {
    await prefs.setBool("isLoggedIn", value);
  }
  bool getBoolIsLoggedIn() => prefs.getBool("isLoggedIn") ?? false;

  //////////////// 🔐🔐🔐🔐🔐🔐🔐🔐 ADMIN SIDE EMPLOYEE DETAILS 🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐
  // ID

  Future<void> setCompanyOverviewId(String email) async {
    await prefs.setString('cmp_overview_id', email);
  }
  Future<String> getCompanyOverviewId() async {
    return prefs.getString('cmp_overview_id') ?? "";
  }
  Future<void> setAdminLoginId(String adminLoginId) async {
    await prefs.setString('admin_login_id', adminLoginId);
  }

  Future<String> getAdminLoginId() async {
    return prefs.getString('admin_login_id') ?? '';
  }

  Future<void> setAdminLoginEmail(String email) async {
    await prefs.setString('admin_login_email', email);
  }

  Future<String> getAdminLoginEmail() async {
    return prefs.getString('admin_login_email') ?? '';
  }


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
//////////////// 🔐🔐🔐🔐🔐🔐🔐🔐 ADMIN SIDE EMPLOYEE DETAILS END HERE  🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐🔐


//////////////// ✅✅✅✅✅✅✅✅✅✅  EMPLOYEE Login  DETAILS HERE  ✅✅✅✅✅✅✅✅✅✅

  // Name
  Future<void> setEmpLoginName(String name) async {
    await prefs.setString('employee_name', name);
  }

  Future<String> getEmpLoginName() async {
    return prefs.getString('employee_name') ?? '';
  }

  // Email
  Future<void> setEmpLoginEmail(String email) async {
    await prefs.setString('employee_email', email);
  }

  Future<String> getEmpLoginEmail() async {
    return prefs.getString('employee_email') ?? '';
  }

  // Email
  Future<void> setEmpLoginPhoto(String email) async {
    await prefs.setString('employee_photo', email);
  }

  Future<String> getEmpLoginPhoto() async {
    return prefs.getString('employee_photo') ?? '';
  }

  // Work Email
  Future<void> setEmpLoginWorkEmail(String email) async {
    await prefs.setString('employee_work_email', email);
  }

  Future<String> getEmpLoginWorkEmail() async {
    return prefs.getString('employee_work_email') ?? '';
  }

  // Mobile
  Future<void> setEmpLoginMobile(String mobile) async {
    await prefs.setString('employee_mobile', mobile);
  }

  Future<String> getEmpLoginMobile() async {
    return prefs.getString('employee_mobile') ?? '';
  }

  // Alternate Mobile
  Future<void> setEmpLoginAlternateMobile(String mobile) async {
    await prefs.setString('alternate_mobile', mobile);
  }

  Future<String> getEmpLoginAlternateMobile() async {
    return prefs.getString('alternate_mobile') ?? '';
  }

  // DOB
  Future<void> setEmpLoginDOB(String dob) async {
    await prefs.setString('employee_dob', dob);
  }

  Future<String> getEmpLoginDOB() async {
    return prefs.getString('employee_dob') ?? '';
  }

  // Gender
  Future<void> setEmpLoginGender(String gender) async {
    await prefs.setString('employee_gender', gender);
  }

  Future<String> getEmpLoginGender() async {
    return prefs.getString('employee_gender') ?? '';
  }

  // Address
  Future<void> setEmpLoginAddress(String address) async {
    await prefs.setString('employee_address', address);
  }

  Future<String> getEmpLoginAddress() async {
    return prefs.getString('employee_address') ?? '';
  }

  // State
  Future<void> setEmpLoginState(String state) async {
    await prefs.setString('employee_state', state);
  }

  Future<String> getEmpLoginState() async {
    return prefs.getString('employee_state') ?? '';
  }

  // City
  Future<void> setEmpLoginCity(String city) async {
    await prefs.setString('employee_city', city);
  }

  Future<String> getEmpLoginCity() async {
    return prefs.getString('employee_city') ?? '';
  }

  // Qualification
  Future<void> setEmpLoginQualification(String qualification) async {
    await prefs.setString('employee_qualification', qualification);
  }

  Future<String> getEmpLoginQualification() async {
    return prefs.getString('employee_qualification') ?? '';
  }

  // Experience
  Future<void> setEmpLoginExperience(String experience) async {
    await prefs.setString('employee_experience', experience);
  }

  Future<String> getEmpLoginExperience() async {
    return prefs.getString('employee_experience') ?? '';
  }

  // Marital Status
  Future<void> setEmpLoginMaritalStatus(String status) async {
    await prefs.setString('marital_status', status);
  }

  Future<String> getEmpLoginMaritalStatus() async {
    return prefs.getString('marital_status') ?? '';
  }

  // Children
  Future<void> setEmpLoginChildren(String children) async {
    await prefs.setString('employee_children', children);
  }

  Future<String> getEmpLoginChildren() async {
    return prefs.getString('employee_children') ?? '';
  }

  // Emergency Contact
  Future<void> setEmpLoginEmergencyContact(String contact) async {
    await prefs.setString('emergency_contact', contact);
  }

  Future<String> getEmpLoginEmergencyContact() async {
    return prefs.getString('emergency_contact') ?? '';
  }

  // Role
  Future<void> setUserRole(String role) async {
    await prefs.setString('user_role', role);
  }

  Future<String> getUserRole() async {
    return prefs.getString('user_role') ?? '';
  }

  // Token
  Future<void> setEmpLoginToken(String token) async {
    await prefs.setString('user_token', token);
  }

  Future<String> getEmpLoginToken() async {
    return prefs.getString('user_token') ?? '';
  }

  // ID
  Future<void> setEmpLoginId(String id) async {
    await prefs.setString('employee_id', id);
  }

  Future<String> getEmpLoginId() async {
    return prefs.getString('employee_id') ?? '';
  }

  // Registration ID
  Future<void> setEmpLoginRegistrationId(String id) async {
    await prefs.setString('registration_id', id);
  }

  Future<String> getEmpLoginRegistrationId() async {
    return prefs.getString('registration_id') ?? '';
  }

  // Bank ID
  Future<void> setEmpLoginBankId(String id) async {
    await prefs.setString('bank_id', id);
  }

  Future<String> getEmpLoginBankId() async {
    return prefs.getString('bank_id') ?? '';
  }

  // Work ID
  Future<void> setEmpLoginWorkId(String id) async {
    await prefs.setString('work_id', id);
  }

  Future<String> getEmpLoginWorkId() async {
    return prefs.getString('work_id') ?? '';
  }

  // Image URLs
  Future<void> setEmpLoginImageUrl(String url) async {
    await prefs.setString('employee_image_url', url);
  }

  Future<String> getEmpLoginImageUrl() async {
    return prefs.getString('employee_image_url') ?? '';
  }

  Future<void> setEmpLoginIdCardUrl(String url) async {
    await prefs.setString('employee_idcard_url', url);
  }

  Future<String> getEmpLoginCardUrl() async {
    return prefs.getString('employee_idcard_url') ?? '';
  }

  Future<void> setEmpLoginDocumentUrl(String url) async {
    await prefs.setString('employee_document_url', url);
  }

  Future<String> getEmpLoginDocumentUrl() async {
    return prefs.getString('employee_document_url') ?? '';
  }
//////////////// ✅✅✅✅✅✅✅✅✅✅ EMPLOYEE Login  DETAILS  END HERE  ✅✅✅✅✅✅✅✅✅✅


}
