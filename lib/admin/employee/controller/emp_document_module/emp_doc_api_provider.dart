import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/network_manager/repository.dart';
import 'package:hrms_management_code_crafter/util/full_screen_loader_utiil.dart';

import '../../../../util/custom_snack_bar.dart';

class DocumentUploadProvider extends ChangeNotifier {
  final Repository _repository = Repository();

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  String? _error;
  String? get error => _error;

  Future<void> uploadEmployeeDocuments({
    required Map<String, File> documents,
    required String empId,
    required BuildContext context,
  }) async {
    // _isUploading = true;
    FullScreenLoader.show(context);
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.uploadDocuments(
        documents: documents,
        empId: empId,
      );

      if (response.success == true) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Documents uploaded successfully")),
        // );

        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          backgroundColor: Colors.green,
          message:response.message ?? "Please select all documents before submitting.",
        );
        FullScreenLoader.hide(context);
      } else {
        _error = "Failed with status code: ${response.success}";
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(_error!)),
        // );
        CustomSnackbarHelper.customShowSnackbar(
          context: context,
          backgroundColor: Colors.red,
          message:response.message ?? "Please select all documents before submitting.",
        );
      }
    } catch (e) {
      _error = "Upload failed: ${e.toString()}";
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(_error!)),
      // );

      CustomSnackbarHelper.customShowSnackbar(
        context: context,
        backgroundColor: Colors.red,
        message:_error ?? "Please select all documents before submitting.",
      );
    } finally {
      FullScreenLoader.hide(context);
      _isUploading = false;
      notifyListeners();
    }
  }
}
