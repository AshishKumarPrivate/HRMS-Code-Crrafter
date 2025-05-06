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

import '../screen/auth/model/user_login_model.dart';
import 'dio_error_handler.dart' show DioErrorHandler;
import 'dio_helper.dart';

class Repository {
  final DioHelper _dioHelper = DioHelper();
  String baseUrl = "https://hr-management-codecrafter-1.onrender.com";

  // ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨  HRMS EMPLOYEE API   ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨

  // user login
  Future<UserLoginModelResponse> userLogin( Map<String, dynamic> requestBody, ) async {
    try {
      Map<String, dynamic>? response = await _dioHelper.post(
        url: '$baseUrl/api/v1/admin/login',
        requestBody: requestBody,
      );
      print("✅ Login API Raw Response: $response");

      if (response == null) {
        return UserLoginModelResponse(
          success: false,
          message: "No response from server",
        );
      }

      if (response["success"] == false) {
        String errorMessage = response["message"] ?? "Login failed!";
        return UserLoginModelResponse(success: false, message: errorMessage);
      }

      return UserLoginModelResponse.fromJson(response);
    } on DioException catch (e) {
      final apiError = DioErrorHandler.handle(e);
      return UserLoginModelResponse(success: false, message: apiError.message);
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return UserLoginModelResponse(
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

}
