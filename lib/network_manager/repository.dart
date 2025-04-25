import 'package:dio/dio.dart';

import '../screen/auth/model/user_login_model.dart';
import 'dio_error_handler.dart' show DioErrorHandler;
import 'dio_helper.dart';

class Repository {
   final DioHelper _dioHelper = DioHelper();
    String baseUrl = "https://hr-management-codecrafter-1.onrender.com";



  // ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨  HRMS EMPLOYEE API   ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨

  // user login
   Future<UserLoginModelResponse> userLogin(Map<String, dynamic> requestBody) async {
     try {
       Map<String, dynamic>? response = await _dioHelper.post(
         url: '$baseUrl/api/v1/admin/login',
         requestBody: requestBody,
       );
       print("✅ Login API Raw Response: $response");

       if (response == null) {
         return UserLoginModelResponse(success: false, message: "No response from server");
       }

       if (response["success"] == false) {
         String errorMessage = response["message"] ?? "Login failed!";
         return UserLoginModelResponse(success: false, message: errorMessage);
       }

       return UserLoginModelResponse.fromJson(response);

     } on DioException catch (e) {
       final apiError = DioErrorHandler.handle(e);
       return UserLoginModelResponse(
         success: false,
         message: apiError.message,
       );
     } catch (e) {
       print("❌ Unexpected Error: $e");
       return UserLoginModelResponse(success: false, message: "Unexpected error occurred");
     }
   }

}
