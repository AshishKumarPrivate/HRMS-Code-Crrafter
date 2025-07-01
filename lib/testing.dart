// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:hrms_management_code_crafter/admin/employee/screen/emp_document_module/view_emp_documents_list_widget.dart';
// import 'package:hrms_management_code_crafter/ui_helper/common_widget/solid_rounded_button.dart';
// import 'package:hrms_management_code_crafter/util/storage_util.dart'; // Make sure this path is correct
// import 'package:provider/provider.dart';
// import '../../../../ui_helper/app_colors.dart';
// import '../../../../ui_helper/app_text_styles.dart';
// import '../../../../util/custom_snack_bar.dart';
// import '../../../../util/responsive_helper_util.dart';
// import '../../controller/emp_document_module/emp_doc_api_provider.dart';
// import '../../model/emp_document_module/get_emp_document_list_model.dart'; // Make sure this path is correct for your models
//
// // Ensure your models (GetAllEmpDocuemtsListModel, Data, Pan) are correctly defined and imported
// // For demonstration, I'm assuming they are in 'get_emp_document_list_model.dart' as per your import.
//
// class AddEmpDocumentsContent extends StatefulWidget {
//   final String empId;
//
//   const AddEmpDocumentsContent({super.key, required this.empId});
//
//   @override
//   State<AddEmpDocumentsContent> createState() => _AddEmpDocumentsContentState();
// }
//
// class _AddEmpDocumentsContentState extends State<AddEmpDocumentsContent> {
//   // This map will now hold either a File (for newly selected) or a Pan object (for existing from API)
//   final Map<String, dynamic?> _documents = {
//     'pan': null,
//     'aadhaar': null,
//     'passbook': null,
//     'highSchool': null,
//     'graduation': null,
//     'salarySlip': null, // Make sure to include all document types from your Data model
//   };
//
//   final Map<String, String> _documentTitles = {
//     'pan': 'PAN Card',
//     'aadhaar': 'Aadhaar Card',
//     'passbook': 'Bank Passbook',
//     'highSchool': 'High School Certificate',
//     'graduation': 'Graduation Certificate',
//     'salarySlip': 'Salary Slip', // Add title for salary slip
//   };
//
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchAndSetExistingDocuments(); // Call this to fetch and populate documents on initialization
//   }
//
//   Future<void> _fetchAndSetExistingDocuments() async {
//     setState(() {
//       _isLoading = true; // Show loading indicator
//     });
//     try {
//       final provider = Provider.of<DocumentUploadProvider>(
//         context,
//         listen: false,
//       );
//
//       // Call the API to get documents. Assuming getEmployeeDocumentsList updates a model in the provider.
//       await provider.getEmployeeDocumentsList(widget.empId);
//
//       // Now access the data from the provider's model
//       final Data? empDocumentsData = provider.getAllEmpDocuemtsListModel?.data;
//
//       if (empDocumentsData != null) {
//         setState(() {
//           // Populate _documents with existing data from the API
//           // Only if secureUrl is not empty, means the document exists
//           if (empDocumentsData.pan?.secureUrl?.isNotEmpty == true) {
//             _documents['pan'] = empDocumentsData.pan;
//           }
//           if (empDocumentsData.aadhaar?.secureUrl?.isNotEmpty == true) {
//             _documents['aadhaar'] = empDocumentsData.aadhaar;
//           }
//           if (empDocumentsData.passbook?.secureUrl?.isNotEmpty == true) {
//             _documents['passbook'] = empDocumentsData.passbook;
//           }
//           if (empDocumentsData.highSchool?.secureUrl?.isNotEmpty == true) {
//             _documents['highSchool'] = empDocumentsData.highSchool;
//           }
//           if (empDocumentsData.graduation?.secureUrl?.isNotEmpty == true) {
//             _documents['graduation'] = empDocumentsData.graduation;
//           }
//           if (empDocumentsData.salarySlip?.secureUrl?.isNotEmpty == true) {
//             _documents['salarySlip'] = empDocumentsData.salarySlip;
//           }
//         });
//       } else {
//         // Optionally show a message if no documents are found
//         // CustomSnackbarHelper.customShowSnackbar(
//         //   context: context,
//         //   backgroundColor: Colors.orange,
//         //   message: "No existing documents found for this employee.",
//         // );
//       }
//     } catch (e) {
//       CustomSnackbarHelper.customShowSnackbar(
//         context: context,
//         backgroundColor: Colors.red,
//         message: "Error fetching documents: $e",
//       );
//     } finally {
//       setState(() {
//         _isLoading = false; // Hide loading indicator
//       });
//     }
//   }
//
//   Future<void> _pickFile(String docType) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
//     );
//
//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         _documents[docType] = File(result.files.single.path!); // Store as File object
//       });
//     } else {
//       CustomSnackbarHelper.customShowSnackbar(
//         context: context,
//         backgroundColor: Colors.orange,
//         message: "No file selected for ${docType.toUpperCase()}.",
//       );
//     }
//   }
//
//   void _clearFile(String docType) {
//     setState(() {
//       _documents[docType] = null; // Set to null to clear
//     });
//   }
//
//   bool _isImageFile(String? fileName) {
//     if (fileName == null) return false;
//     final lower = fileName.toLowerCase();
//     return lower.endsWith('.jpg') ||
//         lower.endsWith('.jpeg') ||
//         lower.endsWith('.png');
//   }
//
//   void _submitDocuments(bool isUpdate) async {
//     final Map<String, File> filesToUpload = {};
//
//     // Iterate through the _documents map and collect only the File objects
//     _documents.forEach((key, value) {
//       if (value is File) {
//         filesToUpload[key] = value;
//       }
//     });
//
//     if (filesToUpload.isEmpty) {
//       CustomSnackbarHelper.customShowSnackbar(
//         context: context,
//         backgroundColor: Colors.red,
//         message: "Please select at least one new document to upload/update.",
//       );
//       return;
//     }
//
//     final provider = Provider.of<DocumentUploadProvider>(
//       context,
//       listen: false,
//     );
//
//     if (isUpdate) {
//       await provider.updateEmployeeDocuments(
//         documents: filesToUpload,
//         empId: widget.empId,
//         context: context,
//       );
//     } else {
//       await provider.uploadEmployeeDocuments(
//         documents: filesToUpload,
//         empId: widget.empId,
//         context: context,
//       );
//     }
//     // After successful upload/update, re-fetch documents to update the UI
//     await _fetchAndSetExistingDocuments();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("employeeId = ${widget.empId}");
//
//     // Show loading indicator while fetching documents
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(15.0),
//       child: Column(
//         children: [
//           // Iterate through all possible document types
//           ..._documents.keys.map((docType) {
//             final dynamic document = _documents[docType]; // Can be File, Pan, or null
//             String? fileName;
//             String? fileUrl;
//             bool isLocalFile = false;
//
//             if (document is File) {
//               isLocalFile = true;
//               fileName = document.path.split('/').last;
//             } else if (document is Pan) {
//               fileName = document.secureUrl?.split('/').last;
//               fileUrl = document.secureUrl;
//             }
//
//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               elevation: 0,
//               color: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _documentTitles[docType] ?? docType,
//                       style: AppTextStyles.heading1(
//                         context,
//                         overrideStyle: TextStyle(
//                           color: AppColors.primary,
//                           fontWeight: FontWeight.bold,
//                           fontSize: ResponsiveHelper.fontSize(context, 16),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     Container(
//                       width: double.infinity,
//                       height: document == null ? 100 : 200,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: document == null
//                           ? Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.cloud_upload,
//                             size: 40,
//                             color: Colors.grey[600],
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'No file selected',
//                             style: AppTextStyles.bodyText2(context),
//                           ),
//                         ],
//                       )
//                           : isLocalFile
//                           ? _isImageFile(fileName)
//                           ? ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Image.file(
//                           document as File,
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           height: double.infinity,
//                         ),
//                       )
//                           : Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.description,
//                             size: 40,
//                             color: Colors.grey[600],
//                           ),
//                           const SizedBox(height: 8),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8.0,
//                             ),
//                             child: Text(
//                               fileName ?? 'Document',
//                               textAlign: TextAlign.center,
//                               style: AppTextStyles.bodyText1(
//                                 context,
//                                 overrideStyle: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       )
//                           : // Display from URL (Pan object)
//                       fileUrl != null
//                           ? _isImageFile(fileName)
//                           ? ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Image.network(
//                           fileUrl,
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           height: double.infinity,
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) return child;
//                             return Center(
//                               child: CircularProgressIndicator(
//                                 value: loadingProgress.expectedTotalBytes != null
//                                     ? loadingProgress.cumulativeBytesLoaded /
//                                     loadingProgress.expectedTotalBytes!
//                                     : null,
//                               ),
//                             );
//                           },
//                           errorBuilder: (context, error, stackTrace) {
//                             return const Center(
//                               child: Icon(Icons.broken_image, size: 40, color: Colors.red),
//                             );
//                           },
//                         ),
//                       )
//                           : Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.insert_drive_file, // Generic file icon for non-images
//                             size: 40,
//                             color: Colors.grey[600],
//                           ),
//                           const SizedBox(height: 8),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8.0,
//                             ),
//                             child: Text(
//                               fileName ?? 'Document',
//                               textAlign: TextAlign.center,
//                               style: AppTextStyles.bodyText1(
//                                 context,
//                                 overrideStyle: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           Text(
//                             '(Previously uploaded)',
//                             style: AppTextStyles.bodyText2(context)?.copyWith(
//                               fontStyle: FontStyle.italic,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                         ],
//                       )
//                           : const SizedBox.shrink(), // Should not happen if Pan object but secureUrl is null
//                     ),
//                     const SizedBox(height: 15),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: CustomButton(
//                             onPressed: () => _pickFile(docType),
//                             type: ButtonType.outlined,
//                             text: 'Select File',
//                             textColor: AppColors.primary,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: CustomButton(
//                             onPressed: document == null
//                                 ? null
//                                 : () => _clearFile(docType),
//                             text: 'Clear',
//                             color: document == null ? Colors.grey : Colors.red,
//                             textColor: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               Expanded(
//                 child: CustomButton(
//                   onPressed: _documents.values.any((doc) => doc is File)
//                       ? () => _submitDocuments(false)
//                       : null,
//                   text: 'Save',
//                   textColor: Colors.white,
//                   color: _documents.values.any((doc) => doc is File)
//                       ? AppColors.primary
//                       : Colors.grey,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 15,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10), // Add some space between buttons
//               Expanded(
//                 child: CustomButton(
//                   onPressed: _documents.values.any((doc) => doc is File) ||
//                       _documents.values.any((doc) => doc is Pan)
//                       ? () => _submitDocuments(true)
//                       : null, // Allow update if any document (new or existing) is present
//                   text: 'Update',
//                   textColor: Colors.white,
//                   color: _documents.values.any((doc) => doc is File) ||
//                       _documents.values.any((doc) => doc is Pan)
//                       ? AppColors.primary
//                       : Colors.grey,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 15,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }