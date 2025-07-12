import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/model/company_profile_data_model.dart';
import '../../../network_manager/api_exception.dart';
import '../../../network_manager/dio_error_handler.dart';
import '../../../network_manager/repository.dart';
import '../../../util/custom_snack_bar.dart';

class CompanyProfileApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String? _errorMessage = "";
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool _isAnnouncementFetched = false;
  bool _hasFetchedOnce = false;

  bool get hasFetchedOnce => _hasFetchedOnce;
  CompanyProfileDataModel? _compProfileDataModel;
  CompanyProfileDataModel? get compProfileDataModel => _compProfileDataModel;

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

  Future<void> addCmpRegisteredAddress(BuildContext context,FormData  requestBody, ) async {

    _setLoadingState(true);
    try {
      // Map<String, dynamic> requestBody = {"email": email, "password": password};
      var response = await _repository.addCompCorporateAddress(requestBody);
      if (response.success == true) {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Company Address Added Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
        Navigator.of(context).pop();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()),);

      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:response.message ?? 'Failed to Add Company Address!',
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

  Future<bool> updateCompanyOverview(BuildContext context,FormData  requestBody,String cmpOverviewId ) async {

    _setLoadingState(true);
    try {
      // Map<String, dynamic> requestBody = {"email": email, "password": password};
      var response = await _repository.updateCompProfileOverview(requestBody,cmpOverviewId);
      if (response.success == true) {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Company Profile Updated Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
        Navigator.pop(context, true);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()),);

        return true;
      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:response.message ?? 'Failed to Update Company Profile!',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
        return false;
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
      return false;
    } finally {
      _setLoadingState(false);
      return false;
    }
  }

  Future<void> addCmpCorporateAddress(BuildContext context,FormData  requestBody, ) async {

    _setLoadingState(true);
    try {
      // Map<String, dynamic> requestBody = {"email": email, "password": password};
      var response = await _repository.addCompCorporateAddress(requestBody);
      if (response.success == true) {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Company Address Added Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
        Navigator.of(context).pop();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()),);

      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:response.message ?? 'Failed to Add Company Address!',
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

  Future<bool> updateCmpRegisteredAddress(BuildContext context,Map<String, dynamic>  requestBody,String cmpOverviewId ) async {

    _setLoadingState(true);
    try {
      // Map<String, dynamic> requestBody = {"email": email, "password": password};
      var response = await _repository.updateCompRegisteredAddress(requestBody,cmpOverviewId);
      if (response.success == true) {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message: response.message ?? 'Company Address Updated Successfully!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
        Navigator.pop(context, true);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()),);

        return true;
      } else {
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          message:response.message ?? 'Failed to Update Company Address!',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
        return false;
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
      return false;
    } finally {
      _setLoadingState(false);
      return false;
    }
  }

  Future<bool> getCompProfileData({bool callFromSplash = false} ) async {
    if ( _hasFetchedOnce) return true;
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
  /// Pull-to-Refresh Handler
  Future<void> refreshCompProfileData() async {
    await getCompProfileData(callFromSplash: true);
  }
}
