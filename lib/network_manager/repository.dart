import 'package:dio/dio.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/add_employee_admin_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/employee_list_detail_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/employee_list_model.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/update_employee_model.dart';

import '../screen/auth/model/user_login_model.dart';
import 'dio_error_handler.dart' show DioErrorHandler;
import 'dio_helper.dart';

class Repository {
  final DioHelper _dioHelper = DioHelper();
  String baseUrl = "https://hr-management-codecrafter-1.onrender.com";

  // ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨  HRMS EMPLOYEE API   ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨

  // user login
  Future<UserLoginModelResponse> userLogin(
    Map<String, dynamic> requestBody,
  ) async {
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


}
