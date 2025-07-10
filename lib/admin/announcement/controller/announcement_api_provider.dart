import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/model/add_cmp_announcement_model.dart';
import 'package:hrms_management_code_crafter/admin/company_terms_conditions/model/add_terms_conditions_model.dart';
import 'package:hrms_management_code_crafter/admin/company_terms_conditions/model/all_terms_conditions_model.dart';
import 'package:hrms_management_code_crafter/admin/company_terms_conditions/model/delete_terms_conditions_model.dart';
import 'package:hrms_management_code_crafter/admin/company_terms_conditions/model/update_terms_conditions_model.dart';

import 'package:hrms_management_code_crafter/util/storage_util.dart';
import '../../../../../network_manager/api_exception.dart';
import '../../../../../network_manager/dio_error_handler.dart';
import '../../../../../network_manager/repository.dart';
import '../../../../../util/custom_snack_bar.dart';
import '../../../../../util/full_screen_loader_utiil.dart';
import '../../company_profile/model/announcement_list_model.dart';
import '../../home/admin_home_screen.dart';

class CompanyAnnouncementApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String? _errorMessage = "";
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool _isAnnouncementFetched = false;

  AnnouncementListModel? _compAnnouncementListModel;
  AddCompanyAnnouncementModel? _addAnnouncementModel;
  AnnouncementListModel? get compAnnouncementListModel => _compAnnouncementListModel;
  AddCompanyAnnouncementModel? get addAnnouncementModel => _addAnnouncementModel;

  var employeeId ;
  /// Set Loading State
  void _setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set Error State
  void _setErrorState(String message) {
    _errorMessage = message;
    _setLoadingState(false);
  }
  void _handleUnexpectedErrors( BuildContext context,   dynamic e,  String message,  ) {
    CustomSnackbarHelper.customShowSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    );
  }

  /// TERMS AND CONDITIONS
  ///

  Future<void> addAnnouncement(BuildContext context,Map<String, dynamic>  requestBody, ) async {

    _setLoadingState(true);
    try {
      employeeId = await StorageHelper().getEmployeeId();
      print("EmployeeId=>${employeeId}");

      var response = await _repository.addCompAnnouncement(requestBody);
      if (response.success == true) {
        _addAnnouncementModel = response;
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Announcement Details Added Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
        Navigator.of(context).pop();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()),);

      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:response.message ?? 'Failed to Add Policy Details!',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
    } on DioException catch (e) {
      final ApiException apiError = DioErrorHandler.handle(e);
      CustomSnackbarHelper.customShowSnackbar(
        context: context,
        message: apiError.message,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      _handleUnexpectedErrors(   context,  e, "Something went wrong! Please try again later.", );
    } finally {
      _setLoadingState(false);
    }
  }
  Future<bool> getAllAnnouncementList({bool forceRefresh = false}) async {
    _setLoadingState(true);
    _errorMessage = "";
    _compAnnouncementListModel = null;

    try {
      final response = await _repository.getAllAnnouncementData();

      if (response.data != null && response.success == true ) {
        print("✅ Terms Conditions List fetched successfully");
        _compAnnouncementListModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _setErrorState(response.message ?? "Failed to fetch Terms Conditions List");
      }
    } catch (error) {
      _setErrorState("⚠️ API Error: $error");
    }

    _setLoadingState(false);
    return false;
  }
  Future<bool> deleteAnnouncement( BuildContext context ,String policyID) async {
    // _setLoadingState(true);
    FullScreenLoader.show(context, message: "Deleting...");
    _errorMessage = "";

    try {
      final Map<String, dynamic> response = await _repository.deleteAnnouncement(policyID);

      final bool success = response['success'] == true;
      final String message = response['message'] ?? "Unknown error";
      // 👇 Hide loader
      FullScreenLoader.hide(context);
      if (success) {
        print("✅ $message");
        // Close the bottom sheet first (safely)
        getAllAnnouncementList(forceRefresh: true);

        // Then navigate to AdminHomeScreen and clear all back stack
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
        //         (Route<dynamic> route) => false,
        //   );
        // });

        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: message ?? 'Employee Deleted Successful!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
        return true;
      } else {
        _setErrorState(message);
      }
    } catch (error) {
      FullScreenLoader.hide(context);
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }

  Future<void> updateAnnouncement(BuildContext context,Map<String, dynamic>  requestBody, String policyId) async {

    _setLoadingState(true);
    try {
      print("policyId=>${policyId}");
      var response = await _repository.updateAnnouncement(requestBody,policyId);
      if (response.success == true) {
        // _updateBankModel = response;
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Policy Details Updated Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
        // Navigator.of(context).pop();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AdminHomeScreen()),
              (Route<dynamic> route) => false, // Remove all previous routes
        );
      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:response.message ?? 'Failed to Update Policy Details!',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
    } on DioException catch (e) {
      final ApiException apiError = DioErrorHandler.handle(e);
      CustomSnackbarHelper.customShowSnackbar(
        context: context,
        message: apiError.message,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      _handleUnexpectedErrors(   context,  e, "Something went wrong! Please try again later.", );
    } finally {
      _setLoadingState(false);
    }
  }




}
