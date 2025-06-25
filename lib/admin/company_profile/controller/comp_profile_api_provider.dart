import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/model/announcement_list_model.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/model/company_profile_data_model.dart';
import '../../../network_manager/api_exception.dart';
import '../../../network_manager/dio_error_handler.dart';
import '../../../network_manager/repository.dart';
import '../../../util/custom_snack_bar.dart';
import '../../../util/full_screen_loader_utiil.dart';


class CompanyProfileApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String? _errorMessage = "";
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool _isAnnouncementFetched = false;

  CompanyProfileDataModel? _compProfileDataModel;
  AnnouncementListModel? _compAnnouncementListModel;
  CompanyProfileDataModel? get compProfileDataModel => _compProfileDataModel;
  AnnouncementListModel? get compAnnouncementListModel => _compAnnouncementListModel;

  void _setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set Error State
  void _setErrorState(String message) {
    _errorMessage = message;
    _setLoadingState(false);
  }
  void _clearErrorState() {
    _errorMessage = null;
    _isLoading = false; // Ensure loading is false
    notifyListeners(); // Notify listeners after updating state
  }

  Future<void> addCompanyOverview(BuildContext context,FormData  requestBody, ) async {

    _setLoadingState(true);
    try {
      // Map<String, dynamic> requestBody = {"email": email, "password": password};
      var response = await _repository.addCompProfileOverview(requestBody);
      if (response.success == true) {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Company Profile Added Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
        Navigator.of(context).pop();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()),);

      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:response.message ?? 'Failed to Add Company Profile!',
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
      _handleUnexpectedErrors(
        context,
        e,
        "Something went wrong! Please try again later.",
      );
    } finally {
      _setLoadingState(false);
    }
  }

  Future<bool> getCompProfileData({bool callFromSplash = false} ) async {
   if(callFromSplash == false){
     _setLoadingState(true);
   }else{
     _setLoadingState(false);
   }
    _errorMessage = null;
    _compProfileDataModel = null;

    try {
      final response = await _repository.getCompanyProfileData();

      if (response.success == true ) {
        print("✅ Company Profile Detail Fetched Successfully");
        _compProfileDataModel = response;
        _setLoadingState(false);
        _clearErrorState();
        return true;
      } else {
        _setErrorState("Failed to Fetch Company Profile Details");
      }
    }on DioException catch (e) {
      final ApiException apiError = DioErrorHandler.handle(e);
      _setErrorState(apiError.message); // Set error message and stop loading
      return false;
    }  catch (error) {
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }

  Future<void> addCompanyAnnouncement(BuildContext context,Object  requestBody, ) async {

    _setLoadingState(true);
    try {
      // Map<String, dynamic> requestBody = {"email": email, "password": password};
      var response = await _repository.addCompAnnouncement(requestBody);
      if (response.success == true) {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Company Announcement Added Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
        Navigator.of(context).pop();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()),);

      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:response.message ?? 'Failed to Add Company Announcement!',
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
      _handleUnexpectedErrors(
        context,
        e,
        "Something went wrong! Please try again later.",
      );
    } finally {
      _setLoadingState(false);
    }
  }

  Future<bool> getCompAnnouncementListData(BuildContext context,{bool callFromSplash = false} ) async {
    // if(callFromSplash == false){
    //   _setLoadingState(true);
    // }else{
    //   _setLoadingState(false);
    // }

    // _setLoadingState(true);
    // Prevent unnecessary reloads if already fetched
    if (_isAnnouncementFetched && _compAnnouncementListModel?.data?.isNotEmpty == true) {
      return true;
    }

    FullScreenLoader.show(context);
    try {
      _setLoadingState(true); // Use proper loader for announcement call (optional)
      _errorMessage = null;
      final response = await _repository.getAllAnnouncementData();

      if (response.success == true ) {

        print("✅ Company Announcement Fetched Successfully");
        _compAnnouncementListModel = response;
        _isAnnouncementFetched = true;
        _setLoadingState(false);
        FullScreenLoader.hide(context);
        return true;
      } else {
        _setErrorState("Failed to Fetch Company Announcement List");
      }
    }on DioException catch (e) {
      final ApiException apiError = DioErrorHandler.handle(e);
      _setErrorState(apiError.message); // Set error message and stop loading
      return false;
    }  catch (error) {
      _setErrorState("⚠️ API Error: $error");
    }

    _setLoadingState(false);
    FullScreenLoader.hide(context);
    return false;
  }

  void _handleUnexpectedErrors(
      BuildContext context,
      dynamic e,
      String message,
      ) {
    CustomSnackbarHelper.customShowSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    );
  }
}
