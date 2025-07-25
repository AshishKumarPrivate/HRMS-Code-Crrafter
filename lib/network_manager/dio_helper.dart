import 'package:dio/dio.dart';
import 'dart:async';

import '../util/storage_util.dart';
import 'injection_container.dart';

class DioHelper {
  Dio dio = getDio();

  Options options(bool isAuthRequired, {bool isMultipart = true}) {
    if (isAuthRequired) {
      return Options(
        receiveDataWhenStatusError: true,
        // contentType: "application/json",
        contentType: isMultipart ? 'multipart/form-data' : 'application/json',
        sendTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
        headers: {
          "x-api-key": "ayush_don_123",
          // "Authorization": 'Bearer ${StorageHelper().getUserAccessToken()}',
        },




      );
    } else {
      return Options(
        receiveDataWhenStatusError: true,
        // contentType: "application/json",
        contentType: isMultipart ? 'multipart/form-data' : 'application/json',
        sendTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),

        headers: {
        "x-api-key": "ayush_don_123",
        // "Authorization": 'Bearer ${StorageHelper().getUserAccessToken()}',
      },
      );
    }
  }

  /// **GET Pathology Test List API (with Pagination)**
  // Future<dynamic> getNavLabScanResponse({int page = 1, int perPage = 10}) async {
  //   String url = "https://dbsanya.drmanasaggarwal.com/api/v1/pathology";
  //
  //   return await get(
  //     url: url,
  //     isAuthRequired: true,  // Change this based on API requirement
  //     queryParams: {"page": page, "per_page": perPage},
  //   );
  // }

  /// Unified error handler with timeout handling
  dynamic _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      print("⏰ Request Timeout Error: ${e.message}");
      return {
        "status": false,
        "message": "Request timed out. Please try again.",
      };
    }

    if (e.response != null) {
      print("❌ API Error Response: ${e.response?.data}");
      return e.response?.data;
    } else {
      print("❌ Network Error: ${e.message}");
      return {
        "status": false,
        "message": "Network error occurred. Please check your connection.",
      };
    }
  }

  /// GET API
  Future<dynamic> get({
    required String url,
    bool isAuthRequired = false,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      Response response = await dio.get(url,
          queryParameters: queryParams, options: options(isAuthRequired));
      return response.data;
    } on DioException catch (e) {

      return _handleError(e);
      // ❌ If DioException, check if it contains a response
      if (e.response != null) {
        print("❌ API Error Response: ${e.response?.data}");

        return e.response?.data; // ✅ Return error response from API
      } else {
        print("❌ Network Error: ${e.message}");
        return null; // ✅ Return null for network errors
      }
    }
  }

  /// POST API  ye default post api dio helper hai
  // Future<dynamic> post ({required String url, Object? requestBody, bool isAuthRequired = false}) async{
  //   try{
  //     Response response;
  //     if(requestBody == null){
  //      response = await dio.post(url, options: options(isAuthRequired));
  //     }else{
  //       response = await dio.post(url, data: requestBody, options: options(isAuthRequired));
  //     }
  //
  //     return response.data;
  //   }catch (error){
  //     return null;
  //   }
  // }

  /// POST API ye CHAT GPT WALA POST DIO HELPER HAI
  // Future<dynamic> post ({required String url, Object? requestBody, bool isAuthRequired = false}) async{
  //   try{
  //     Response response;
  //     if(requestBody == null){
  //       response = await dio.post(url, options: options(isAuthRequired));
  //     }else{
  //       response = await dio.post(url, data: requestBody, options: options(isAuthRequired));
  //     }
  //
  //     return response.data;
  //   } on DioException catch (e) {
  //     // ❌ If DioException, check if it contains a response
  //     if (e.response != null) {
  //       print("❌ API Error Response: ${e.response?.data}");
  //
  //       return e.response?.data; // ✅ Return error response from API
  //     } else {
  //       print("❌ Network Error: ${e.message}");
  //       return null; // ✅ Return null for network errors
  //     }
  //   }
  // }
  Future<dynamic> post({
    required String url,
    Object? requestBody,
    bool isAuthRequired = false,
  }) async {
    try {
      Response response;
      final isMultipart = requestBody is FormData;

      // final Options reqOptions = options(isAuthRequired).copyWith(
      //   contentType: isMultipart ? 'multipart/form-data' : 'application/json',
      // );
      final Options reqOptions = options(
        isAuthRequired,
        isMultipart: isMultipart,
      );

      if (requestBody == null) {
        response = await dio.post(url, options: reqOptions);
      } else {
        response = await dio.post(url, data: requestBody, options: reqOptions);
      }

      return response.data;
    } on DioException catch (e) {
      return _handleError(e);
      // ❌ If DioException, check if it contains a response
      if (e.response != null) {
        print("❌ API Error Response: ${e.response?.data}");

        return e.response?.data; // ✅ Return error response from API
      } else {
        print("❌ Network Error: ${e.message}");
        return null; // ✅ Return null for network errors
      }
    }
  }

  /// PUT API
  Future<dynamic> put({
    required String url,
    Object? requestBody,
    bool isAuthRequired = false,
  }) async {
    try {
      final isMultipart = requestBody is FormData;
      final Options reqOptions = options(
        isAuthRequired,
        isMultipart: isMultipart,
      );

      Response response;
      if (requestBody == null) {
        response = await dio.put(url, options: reqOptions);
      } else {
        response = await dio.put(url, data: requestBody, options: reqOptions);
      }

      return response.data;
    } on DioException catch (e) {
      return _handleError(e);
      // ❌ If DioException, check if it contains a response
      if (e.response != null) {
        print("❌ API Error Response: ${e.response?.data}");

        return e.response?.data; // ✅ Return error response from API
      } else {
        print("❌ Network Error: ${e.message}");
        return null; // ✅ Return null for network errors
      }
    } catch (error) {
      return null;
    }
  }

  /// PATCH API
  Future<dynamic> patch({
    required String url,
    Object? requestBody,
    bool isAuthRequired = false,
  }) async {
    try {
      final isMultipart = requestBody is FormData;
      final Options reqOptions = options(
        isAuthRequired,
        isMultipart: isMultipart,
      );

      Response response;
      if (requestBody == null) {
        response = await dio.patch(url, options: reqOptions);
      } else {
        response = await dio.patch(url, data: requestBody, options: reqOptions);
      }

      return response.data;
    }
    on DioException catch (e) {
      return _handleError(e);
    }catch (error) {
      return null;
    }
  }

  /// DELETE API
  Future<dynamic> delete({
    required String url,
    Object? requestBody,
    bool isAuthRequired = false,
  }) async {
    try {
      final isMultipart = requestBody is FormData;
      final Options reqOptions = options(
        isAuthRequired,
        isMultipart: isMultipart,
      );

      Response response;
      if (requestBody == null) {
        response = await dio.delete(url, options: reqOptions);
      } else {
        response = await dio.delete(url, data: requestBody, options: reqOptions);
      }

      return response.data;
    } on DioException catch (e) {
      return _handleError(e);
    }catch (error) {
      return null;
    }
  }

  /// MULTIPART API
  Future<dynamic> uploadFile({
    required String url,
    required Object requestBody,
    bool isAuthRequired = false,
  }) async {
    // Options option = Options(headers: {"Content-Type": "multipart/form-data"});
    Options option = options(isAuthRequired, isMultipart: true);

    try {
      Response response = await dio.post(
        url,
        data: requestBody,
        options: option,
      );

      return response.data;
    }on DioException catch (e) {
      return _handleError(e);
    } catch (error) {
      return null;
    }
  }
}
