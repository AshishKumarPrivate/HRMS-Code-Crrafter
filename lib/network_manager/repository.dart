import 'package:dio/dio.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/add_employee_admin_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/bank_detail/add_emp_bank_detail_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/bank_detail/emp_bank_detail_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/bank_detail/update_emp_bank_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/employee_list_detail_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/employee_list_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/policy/add_cmp_policy_model_response.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/policy/all_cmp_policy_list_model_response.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/policy/update_cmp_policy_model_response.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/update_employee_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/work_module/add_emp_work_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/work_module/emp_work_detail_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/work_module/update_emp_work_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/leave_module/model/all_emp_leave_requests_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/leave_module/model/emp_leave_approved_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/leave_module/model/emp_leave_rejected_model.dart';
import 'package:hrms_management_code_crafter/admin/home/attendance/model/admin_filter_attendance_model.dart';
import 'package:hrms_management_code_crafter/screen/auth/model/user_and_admin_login_model.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/model/emp_attandance_detail_model_response.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/model/emp_chart_attendance_model.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/model/emp_check_in_model_response.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/model/emp_check_out_model_response.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/model/emp_monthly_attendance_history_model.dart';
import 'package:hrms_management_code_crafter/screen/emp_attandance/model/emp_single_profile_model.dart';
import 'package:hrms_management_code_crafter/screen/emp_leave/model/apply_leave_model.dart';
import 'package:hrms_management_code_crafter/screen/emp_leave/model/my_all_leave_model.dart';

import '../screen/auth/model/user_login_model.dart';
import 'dio_error_handler.dart' show DioErrorHandler;
import 'dio_helper.dart';

class Repository {
  final DioHelper _dioHelper = DioHelper();
  String baseUrl = "https://hr-management-codecrafter-1.onrender.com";

  /// ✅✅✅✅✅✅✅✅✅✅  HRMS EMPLOYEE API   ✅✅✅✅✅✅✅✅✅✅

  // user login
  Future<UserAndAdminLoginModelResponse> userLogin( Map<String, dynamic> requestBody, ) async {
    try {
      Map<String, dynamic>? response = await _dioHelper.post(
        url: '$baseUrl/api/v1/admin/login',
        requestBody: requestBody,
      );
      print("✅ Login API Raw Response: $response");

      if (response == null) {
        return UserAndAdminLoginModelResponse(
          success: false,
          message: "No response from server",
        );
      }

      if (response["success"] == false) {
        String errorMessage = response["message"] ?? "Login failed!";
        return UserAndAdminLoginModelResponse(success: false, message: errorMessage);
      }

      return UserAndAdminLoginModelResponse.fromJson(response);
    } on DioException catch (e) {
      final apiError = DioErrorHandler.handle(e);
      return UserAndAdminLoginModelResponse(success: false, message: apiError.message);
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return UserAndAdminLoginModelResponse(
        success: false,
        message: "Unexpected error occurred",
      );
    }
  }

  Future<ApplyLeaveModelResponse> applyLeave(FormData  requestBody, String empID ) async {
    try {
      Map<String, dynamic>? response = await _dioHelper.post(
        url: '$baseUrl/api/v1/leave/add/$empID',
        requestBody: requestBody,
      );
      print("✅ Add Employee API Response: $response");

      if (response == null) {
        return ApplyLeaveModelResponse(
          success: false,
          message: "No response from server",
        );
      }
      if (response["success"] == false) {
        String errorMessage =
            response["message"] ?? "Employee registration failed!";
        return ApplyLeaveModelResponse(success: false, message: errorMessage);
      }
      return ApplyLeaveModelResponse.fromJson(response);
    } on DioException catch (e) {
      final apiError = DioErrorHandler.handle(e);
      return ApplyLeaveModelResponse(
        success: false,
        message: apiError.message,
      );
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return ApplyLeaveModelResponse(
        success: false,
        message: "Unexpected error occurred",
      );
    }
  }

  Future<EmpAllLeaveListModelResponse> getEmpLeaveList(String empID) async {

    // Map<String, dynamic> response = await _dioHelper.get(
    //   url: '$baseUrl/api/v1/leave/get/myleave/$empID',
    // );
    // // return EmpAllLeaveListModelResponse.fromJson(response);

    try {
      Map<String, dynamic> response = await _dioHelper.get(
        url: '$baseUrl/api/v1/leave/get/myleave/$empID',
      );
      print("✅ Add Employee API Response: $response");

      if (response == null || response.isEmpty) {
        return EmpAllLeaveListModelResponse(
          success: false,
          message: "No response from server",
        );
      }

      if (response["success"] == false) {
        String errorMessage = response["message"] ?? "Failed to Load Data!";
        return EmpAllLeaveListModelResponse(success: false, message: errorMessage);
      }

      return EmpAllLeaveListModelResponse.fromJson(response);
    } on DioException catch (e) {
      final apiError = DioErrorHandler.handle(e);
      return EmpAllLeaveListModelResponse(
        success: false,
        message: apiError.message,
      );
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return EmpAllLeaveListModelResponse(
        success: false,
        message: "Unexpected error occurred",
      );
    }
  }

  Future<Map<String, dynamic>> deleteEmpLeave(String leaveID) async {
    try {
      Map<String, dynamic>? response = await _dioHelper.delete(
        url: '$baseUrl/api/v1/leave/delete/$leaveID',
      );
      print("✅ Delete Employee API Response: $response");
      if (response == null) {
        return {
          'success': false,
          'message': 'No response from server',
        };
      }
      if (response['success'] == false) {
        return {
          'success': false,
          'message': response['message'] ?? 'Employee deletion failed!',
        };
      }
      return response;
    } on DioException catch (e) {
      final apiError = DioErrorHandler.handle(e);
      return {
        'success': false,
        'message': apiError.message,
      };
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return {
        'success': false,
        'message': 'Unexpected error occurred',
      };
    }
  }

  /// Check in out api
  // Future<EmpPunchInModel> empCheckIn(String employeeRegistrationId) async {
  //   Map<String, dynamic> response = await _dioHelper.post(
  //       url: '$baseUrl/api/v1/employee/attendance/checkIn/${employeeRegistrationId}');
  //   return EmpPunchInModel.fromJson(response);
  // }

  /// Check in out api
  Future<EmpPunchInModel> empCheckIn(String employeeRegistrationId ) async {
    try {
      Map<String, dynamic>? response = await _dioHelper.post(
          url: '$baseUrl/api/v1/employee/attendance/checkIn/${employeeRegistrationId}' );
      print("✅ Add Employee API Response: $response");

      if (response == null) {
        return EmpPunchInModel(
          success: false,
          message: "No response from server",
        );
      }
      if (response["success"] == false) {
        String errorMessage =
            response["message"] ?? "Failed to Check In!";
        return EmpPunchInModel(success: false, message: errorMessage);
      }
      return EmpPunchInModel.fromJson(response);
    } on DioException catch (e) {
      final apiError = DioErrorHandler.handle(e);
      return EmpPunchInModel(
        success: false,
        message: apiError.message,
      );
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return EmpPunchInModel(
        success: false,
        message: "Unexpected error occurred",
      );
    }
  }

  Future<EmpCheckOUTModelResponse> empCheckOUT(String employeeRegistrationId ) async {
    try {
      Map<String, dynamic>? response = await _dioHelper.put(
          url: '$baseUrl/api/v1/employee/attendance/checkout/${employeeRegistrationId}' );
      print("✅ Add Employee API Response: $response");

      if (response == null) {
        return EmpCheckOUTModelResponse(
          success: false,
          message: "No response from server",
        );
      }
      if (response["success"] == false) {
        String errorMessage =
            response["message"] ?? "Failed to Check OUT!";
        return EmpCheckOUTModelResponse(success: false, message: errorMessage);
      }
      return EmpCheckOUTModelResponse.fromJson(response);
    } on DioException catch (e) {
      final apiError = DioErrorHandler.handle(e);
      return EmpCheckOUTModelResponse(
        success: false,
        message: apiError.message,
      );
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return EmpCheckOUTModelResponse(
        success: false,
        message: "Unexpected error occurred",
      );
    }
  }

  Future<EmpAttancanceDetailModelResponse> empAttendanceDetail(String empLoginID ) async {
    try {
      Map<String, dynamic>? response = await _dioHelper.get(
          url: '$baseUrl/api/v1/employee/attendance/detail/${empLoginID}' );
      print("✅ Employee Attendance Detail API Response: $response");

      if (response == null) {
        return EmpAttancanceDetailModelResponse(
          success: false,
          message: "No response from server",
        );
      }
      if (response["success"] == false) {
        String errorMessage =
            response["message"] ?? "Failed to Fetch Employee Attendance Detail !";
        return EmpAttancanceDetailModelResponse(success: false, message: errorMessage);
      }
      return EmpAttancanceDetailModelResponse.fromJson(response);
    } on DioException catch (e) {
      final apiError = DioErrorHandler.handle(e);
      return EmpAttancanceDetailModelResponse(
        success: false,
        message: apiError.message,
      );
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return EmpAttancanceDetailModelResponse(
        success: false,
        message: "Unexpected error occurred",
      );
    }
  }

  Future<EmpMonthlyAttancanceHistoryModel> empMonthlyAttendanceHistory(
      Object requestBody) async {
    Map<String, dynamic> response = await _dioHelper.post(
        url: '$baseUrl/api/v1/employee/attendance/monthly/detail', requestBody: requestBody);

    return EmpMonthlyAttancanceHistoryModel.fromJson(response);
    // return LogInModel.fromJson(response);
  }


  Future<EmpSingleProfileModel> empSingleProfile(String empLoginID ) async {
    try {
      Map<String, dynamic>? response = await _dioHelper.get(
          url: '$baseUrl/api/v1/employee/single/all/detail/${empLoginID}' );
      print("✅ Employee Profile Detail API Response: $response");

      if (response == null) {
        return EmpSingleProfileModel(
          success: false,
          message: "No response from server",
        );
      }
      if (response["success"] == false) {
        String errorMessage =
            response["message"] ?? "Failed to Fetch Employee Profile Detail !";
        return EmpSingleProfileModel(success: false, message: errorMessage);
      }
      return EmpSingleProfileModel.fromJson(response);
    } on DioException catch (e) {
      final apiError = DioErrorHandler.handle(e);
      return EmpSingleProfileModel(
        success: false,
        message: apiError.message,
      );
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return EmpSingleProfileModel(
        success: false,
        message: "Unexpected error occurred",
      );
    }
  }


  // ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨  HRMS ADMIN API   ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨

  Future<AddEmployeeModelResponse> addEmployee(
      FormData  requestBody,
  ) async {
    try {
      Map<String, dynamic>? response = await _dioHelper.post(
        url: '$baseUrl/api/v1/employee/add',
        requestBody: requestBody,
      );
      print("✅ Add Employee API Response: $response");

      if (response == null) {
        return AddEmployeeModelResponse(
          success: false,
          message: "No response from server",
        );
      }
      if (response["success"] == false) {
        String errorMessage =
            response["message"] ?? "Employee registration failed!";
        return AddEmployeeModelResponse(success: false, message: errorMessage);
      }
      return AddEmployeeModelResponse.fromJson(response);
    } on DioException catch (e) {
      final apiError = DioErrorHandler.handle(e);
      return AddEmployeeModelResponse(
        success: false,
        message: apiError.message,
      );
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return AddEmployeeModelResponse(
        success: false,
        message: "Unexpected error occurred",
      );
    }
  }

  //GET API
  Future<EmployeeListModelResponse> getAllEmployeeList() async {
    Map<String, dynamic> response = await _dioHelper.get(
      url: '$baseUrl/api/v1/employee/all',
    );
    return EmployeeListModelResponse.fromJson(response);
  }

  Future<EmployeeListDetailModelResponse> getEmployeeDetail( String employeeId) async {
    Map<String, dynamic> response = await _dioHelper.get(
        url: '$baseUrl/api/v1/employee/all/detail/$employeeId');
    return EmployeeListDetailModelResponse.fromJson(response);
  }
  // 🔥 Delete Employee API
  Future<Map<String, dynamic>> deleteEmployee(String employeeId) async {
    try {
      Map<String, dynamic>? response = await _dioHelper.delete(
        url: '$baseUrl/api/v1/employee/delete/$employeeId',
      );
      print("✅ Delete Employee API Response: $response");
      if (response == null) {
        return {
          'success': false,
          'message': 'No response from server',
        };
      }
      if (response['success'] == false) {
        return {
          'success': false,
          'message': response['message'] ?? 'Employee deletion failed!',
        };
      }
      return response;
    } on DioException catch (e) {
      final apiError = DioErrorHandler.handle(e);
      return {
        'success': false,
        'message': apiError.message,
      };
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return {
        'success': false,
        'message': 'Unexpected error occurred',
      };
    }
  }
  /// Update Employee
  Future<UpdateEmployeeModel> updateEmployee(
      FormData  requestBody,String employeeId
      ) async {
    try {
      Map<String, dynamic>? response = await _dioHelper.put(
        url: '$baseUrl/api/v1/employee/update/$employeeId',
        requestBody: requestBody,
      );
      print("✅ Add Employee API Response: $response");

      if (response == null) {
        return UpdateEmployeeModel(
          success: false,
          message: "No response from server",
        );
      }
      if (response["success"] == false) {
        String errorMessage =
            response["message"] ?? "Update failed!";
        return UpdateEmployeeModel(success: false, message: errorMessage);
      }
      return UpdateEmployeeModel.fromJson(response);
    } on DioException catch (e) {
      final apiError = DioErrorHandler.handle(e);
      return UpdateEmployeeModel(
        success: false,
        message: apiError.message,
      );
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return UpdateEmployeeModel(
        success: false,
        message: "Unexpected error occurred",
      );
    }
  }

  /// !!!!!!!!!!!!!!!!!!!!!!!! ADD BANK DETAIL API  !!!!!!!!!!!!!!!!!!!!!!!!!
  Future<AddEmpBankDetailsModel> addEmployeeBankDetail(Object requestBody,String employeeId) async {
    Map<String, dynamic> response = await _dioHelper.post(
        url: '$baseUrl/api/v1/employee/bank/add/${employeeId}', requestBody: requestBody);
    return AddEmpBankDetailsModel.fromJson(response);
  }
/// Get BANK DETAILS
  Future<EmpBankDetailsModel> getEmployeeBankDetails( String bankId) async {
    Map<String, dynamic> response = await _dioHelper.get(
        url: '$baseUrl/api/v1/employee/bank/detail/$bankId');
    return EmpBankDetailsModel.fromJson(response);
  }
  Future<Map<String, dynamic>> deleteBankDetails(String bankId) async {
    try {
      Map<String, dynamic>? response = await _dioHelper.delete(
        url: '$baseUrl/api/v1/employee/bank/delete/$bankId',
      );
      print("✅ Delete Employee API Response: $response");
      if (response == null) {
        return {
          'success': false,
          'message': 'No response from server',
        };
      }
      if (response['success'] == false) {
        return {
          'success': false,
          'message': response['message'] ?? 'Employee deletion failed!',
        };
      }
      return response;
    } on DioException catch (e) {
      final apiError = DioErrorHandler.handle(e);
      return {
        'success': false,
        'message': apiError.message,
      };
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return {
        'success': false,
        'message': 'Unexpected error occurred',
      };
    }
  }

  Future<UpdateEmpBankDetailsModel> updateBank(Object requestBody,String bankId) async {
    Map<String, dynamic> response = await _dioHelper.put(
        url: '$baseUrl/api/v1/employee/bank/update/${bankId}', requestBody: requestBody);
    return UpdateEmpBankDetailsModel.fromJson(response);
  }
/// !!!!!!!!!!!!!!!!!!!!!!!! ADD BANK DETAIL API END HERE   !!!!!!!!!!!!!!!!!!!!!!!!!


/// !!!!!!!!!!!!!!!!!!!!!!!! ADD EMPLOYEE Work  DETAIL API  HERE   !!!!!!!!!!!!!!!!!!!!!!!!!
  Future<AddEmpWorkModel> addEmployeeWork(Object requestBody,String empId) async {
    Map<String, dynamic> response = await _dioHelper.post(
        url: '$baseUrl/api/v1/employee/work/add/${empId}', requestBody: requestBody);
    return AddEmpWorkModel.fromJson(response);
  }

  Future<EmpWorkDetailModel> getEmployeeWorkDetails( String empId) async {
    Map<String, dynamic> response = await _dioHelper.get(
        url: '$baseUrl/api/v1/employee/work/get/$empId');
    return EmpWorkDetailModel.fromJson(response);
  }

  Future<Map<String, dynamic>> deleteWorkDetails(String empWorkId) async {
    try {
      Map<String, dynamic>? response = await _dioHelper.delete(
        url: '$baseUrl/api/v1/employee/work/delete/$empWorkId',
      );
      print("✅ Delete Employee Work Response: $response");
      if (response == null) {
        return {
          'success': false,
          'message': 'No response from server',
        };
      }
      if (response['success'] == false) {
        return {
          'success': false,
          'message': response['message'] ?? 'Work deletion failed!',
        };
      }
      return response;
    } on DioException catch (e) {
      final apiError = DioErrorHandler.handle(e);
      return {
        'success': false,
        'message': apiError.message,
      };
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return {
        'success': false,
        'message': 'Unexpected error occurred',
      };
    }
  }

  Future<UpdateEmpWorkDetailModel> updateEmpWork(Object requestBody,String empId) async {
    Map<String, dynamic> response = await _dioHelper.put(
        url: '$baseUrl/api/v1/employee/work/update/${empId}', requestBody: requestBody);
    return UpdateEmpWorkDetailModel.fromJson(response);
  }
/// !!!!!!!!!!!!!!!!!!!!!!!! ADD EMPLOYEE Work  DETAIL API END HERE   !!!!!!!!!!!!!!!!!!!!!!!!!

/// !!!!!!!!!!!!!!!!!!!!!!!! ADD POLICY DETAIL API  HERE   !!!!!!!!!!!!!!!!!!!!!!!!!

  Future<AddCompanyPolicyModel> addCompanyPolicy(Object requestBody) async {
    Map<String, dynamic> response = await _dioHelper.post(
        url: '$baseUrl/api/v1/policy/add', requestBody: requestBody);
    return AddCompanyPolicyModel.fromJson(response);
  }
  Future<CompanyPolicyListModelResponse> getAllPolicyList() async {
    Map<String, dynamic> response = await _dioHelper.get(
        url: '$baseUrl/api/v1/policy/all');
    return CompanyPolicyListModelResponse.fromJson(response);
  }
  Future<Map<String, dynamic>> deletePolicy(String policyId) async {
    try {
      Map<String, dynamic>? response = await _dioHelper.delete(
        url: '$baseUrl/api/v1/policy/delete/$policyId',
      );
      print("✅ Delete Policy Response: $response");
      if (response == null) {
        return {
          'success': false,
          'message': 'No response from server',
        };
      }
      if (response['success'] == false) {
        return {
          'success': false,
          'message': response['message'] ?? 'Policy deletion failed!',
        };
      }
      return response;
    } on DioException catch (e) {
      final apiError = DioErrorHandler.handle(e);
      return {
        'success': false,
        'message': apiError.message,
      };
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return {
        'success': false,
        'message': 'Unexpected error occurred',
      };
    }
  }
  Future<UpdateCompanyPolicyModelResponse> updatePolicy(Object requestBody,String policyId) async {
    Map<String, dynamic> response = await _dioHelper.put(
        url: '$baseUrl/api/v1/policy/update/${policyId}', requestBody: requestBody);
    return UpdateCompanyPolicyModelResponse.fromJson(response);
  }

/// !!!!!!!!!!!!!!!!!!!!!!!! ADD POLICY DETAIL API END HERE   !!!!!!!!!!!!!!!!!!!!!!!!!

/// !!!!!!!!!!!!!!!!!!!!!!!! ALL EMP LEAVE REQUESTS  START   !!!!!!!!!!!!!!!!!!!!!!!!!
  //GET API
  Future<AllEmpLeaveRequestsListModel> getAllEmpLeaveRequest() async {
    Map<String, dynamic> response = await _dioHelper.get(
      url: '$baseUrl/api/v1/leave/all/employee',
    );
    return AllEmpLeaveRequestsListModel.fromJson(response);
  }

  Future<LeaveApprovedModel> leaveApproveApi(Object requestBody,String leaveId) async {
    Map<String, dynamic> response = await _dioHelper.put(
        url: '$baseUrl/api/v1/leave/aproved/${leaveId}', requestBody: requestBody);
    return LeaveApprovedModel.fromJson(response);
  }

  Future<LeaveRejectedModel> leaveRejectedApi(Object requestBody,String leaveId) async {
    Map<String, dynamic> response = await _dioHelper.put(
        url: '$baseUrl/api/v1/leave/reject/${leaveId}', requestBody: requestBody);
    return LeaveRejectedModel.fromJson(response);
  }
/// !!!!!!!!!!!!!!!!!!!!!!!! ALL EMP LEAVE REQUESTS  END  !!!!!!!!!!!!!!!!!!!!!!!!!

/// !!!!!!!!!!!!!!!!!!!!!!!! ATTENDANCE CHART START HERE   !!!!!!!!!!!!!!!!!!!!!!!!!
  Future<AttendanceChartModel> getChartAttendance(Map<String, dynamic>? queryParameters,) async {
    Map<String, dynamic> response = await _dioHelper.get(
      url: '$baseUrl/api/v1/employee/attendance/get/chart',queryParams: queryParameters
    );
    return AttendanceChartModel.fromJson(response);
  }

  Future<AdminFilterAttendanceModel> filterAdminAttendanceExcel(Map<String, dynamic>? queryParameters,) async {
    Map<String, dynamic> response = await _dioHelper.get(
        url: '$baseUrl/api/v1/employee/attendance/filter',queryParams: queryParameters
    );
    return AdminFilterAttendanceModel.fromJson(response);
  }
/// !!!!!!!!!!!!!!!!!!!!!!!! ATTENDANCE CHART END HERE   !!!!!!!!!!!!!!!!!!!!!!!!!

}
