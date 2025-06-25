import 'dart:async';
import 'dart:io' as IO;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../network_manager/repository.dart';
import '../util/storage_util.dart';

class FirebaeApiProvider extends ChangeNotifier {
  final Repository _repository = Repository();
  late IO.Socket _socket;
  DateTime? _selectedDate;

  bool _isLoading = false;
  String _errorMessage = "";
  bool _newOrderAssigned = false; // Flag to show shimmer notification

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage; bool get newOrderAssigned => _newOrderAssigned;
  DateTime? get selectedDate => _selectedDate;

  /// **Set Loading State for UI**
  void setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// **Set Error State for UI**
  void _setErrorState(String message) {
    _errorMessage = message;
    setLoadingState(false);
    notifyListeners(); // Ensure UI rebuilds
  }

  void callEmit() {
    notifyListeners();
  }

  /// **Reset New Order Notification**
  void resetNewOrderNotification() {
    _newOrderAssigned = false;
    notifyListeners();
  }


  Future<void> sendFcmToken(  String fcmToken) async {
    setLoadingState(true);
    try {

      String empLoginID =await StorageHelper().getEmpLoginId();

      print("📤 Token send to Backend: $fcmToken");
      Map<String, dynamic> requestBody = {
        "id": empLoginID,
        "token":fcmToken ,

      };

      var response = await _repository.sendFcmToken(requestBody);
      if (response["success"] == true) {
        print("Token send successfully");

      } else {

        print("Token failed ");

        // showCustomSnackbarHelper.showSnackbar(
        //   context: context,
        //   message: response["message"] ?? "Failed to send token!",
        //   backgroundColor: Colors.red,
        //   duration: Duration(seconds: 2),
        // );


      }
    } on DioException {
      // _handleDioErrors(context, e);
      print("Token failed ");
    } catch (e) {
      // _handleUnexpectedErrors(context, e, "Something went wrong!");
      print("Token failed ");
    } finally {
      setLoadingState(false);
    }
  }
}
