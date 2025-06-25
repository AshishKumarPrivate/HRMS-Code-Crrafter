import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/ui_helper/common_widget/solid_rounded_button.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';
import 'package:provider/provider.dart';
import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/app_text_styles.dart';
import '../../../../util/custom_snack_bar.dart';
import '../../../../util/responsive_helper_util.dart';
import '../../controller/emp_document_module/emp_doc_api_provider.dart';

class AddEmpDocumentUploadWidget extends StatefulWidget {
  // const AddEmpDocumentUploadWidget(employeeId, {super.key});

  final String empId; // Path to the image file to display

  const AddEmpDocumentUploadWidget({super.key, required this.empId});

  @override
  State<AddEmpDocumentUploadWidget> createState() => _AddEmpDocumentUploadWidgetState();
}

class _AddEmpDocumentUploadWidgetState extends State<AddEmpDocumentUploadWidget> {
  final Map<String, File?> _uploadedDocuments = {
    'pan': null,
    'aadhaar': null,
    'passbook': null,
    'highSchool': null,
    'graduation': null,
  };
  final Map<String, String> _documentTitles = {
    'pan': 'PAN Card',
    'aadhaar': 'Aadhaar Card',
    'passbook': 'Bank Passbook',
    'highSchool': 'High School Certificate',
    'graduation': 'Graduation Certificate',
  };

  Future<void> _pickFile(String docType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _uploadedDocuments[docType] = File(result.files.single.path!);
      });
    } else {
      CustomSnackbarHelper.customShowSnackbar(
        context: context,
        backgroundColor: Colors.orange,
        message: "No file selected for $docType.",
      );
    }
  }

  void _clearFile(String docType) {
    setState(() {
      _uploadedDocuments[docType] = null;
    });
  }

  bool _isImageFile(String? fileName) {
    if (fileName == null) return false;
    final lower = fileName.toLowerCase();
    return lower.endsWith('.jpg') || lower.endsWith('.jpeg') || lower.endsWith('.png');
  }

  void _submitDocuments() async  {
    // final allSelected = _uploadedDocuments.values.every((file) => file != null);
    final selectedDocs = _uploadedDocuments.entries.where((entry) => entry.value != null);

    if (selectedDocs.isEmpty) {
      CustomSnackbarHelper.customShowSnackbar(
        context: context,
        backgroundColor: Colors.red,
        message: "Please select all documents before submitting.",
      );
      return;
    }
    // Convert Map<String, File?> to Map<String, File>
    // final Map<String, File> nonNullableDocs = {};
    // _uploadedDocuments.forEach((key, value) {
    //   if (value != null) nonNullableDocs[key] = value;
    // });

    final Map<String, File> nonNullableDocs = {
      for (var entry in selectedDocs) entry.key: entry.value!
    };

    // You can get empId from Provider, SharedPreferences, or pass it down
    // const empId = "684c0b49d47b187e7497fb05"; // Replace with actual logic
    // final empId = await StorageHelper().getEmpLoginRegistrationId();

    final provider = Provider.of<DocumentUploadProvider>(context, listen: false);
    await provider.uploadEmployeeDocuments(
      documents: nonNullableDocs,
      empId: widget.empId,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          ..._uploadedDocuments.keys.map((docType) {
            final file = _uploadedDocuments[docType];
            final fileName = file?.path.split('/').last;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                    _documentTitles[docType] ?? docType,
                      style: AppTextStyles.heading1(
                        context,
                        overrideStyle: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveHelper.fontSize(context, 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      height: file == null ? 100 : 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: file == null
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload, size: 40, color: Colors.grey[600]),
                          const SizedBox(height: 8),
                          Text('No file selected', style: AppTextStyles.bodyText2(context)),
                        ],
                      )
                          : _isImageFile(fileName)
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          file,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.description, size: 40, color: Colors.grey[600]),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              fileName ?? 'Document',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyText1(
                                context,
                                overrideStyle: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () => _pickFile(docType),
                            type: ButtonType.outlined,
                            text: 'Select File',
                            textColor: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomButton(
                            onPressed: file == null ? null : () => _clearFile(docType),

                            // onPressed:() {file == null ? null : () => _clearFile(docType);},
                            text: 'Clear',
                            color: file == null ? Colors.grey : Colors.red,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          CustomButton(
            onPressed: _uploadedDocuments.values.any((file) => file != null)
                ? _submitDocuments
                : null, // disabled if no files selected
            text: 'Upload Selected Documents',
            textColor: Colors.white,
            color: _uploadedDocuments.values.any((file) => file != null)
                ? AppColors.primary
                : Colors.grey, // visual cue for disabled
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),

        ],
      ),
    );
  }
}
