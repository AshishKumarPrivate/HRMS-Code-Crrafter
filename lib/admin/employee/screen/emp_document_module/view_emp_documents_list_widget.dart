import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening URLs

import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/app_text_styles.dart';
import '../../../../util/loading_indicator.dart'; // Assuming you have this for loading
import '../../controller/emp_document_module/emp_doc_api_provider.dart'; // Your document provider
import '../../model/emp_document_module/get_emp_document_list_model.dart'; // YOUR provided model

class ViewEmpDocumentsListWidget extends StatefulWidget {
  final String empId; // Employee ID is crucial to fetch specific documents

  const ViewEmpDocumentsListWidget({super.key, required this.empId});

  @override
  State<ViewEmpDocumentsListWidget> createState() => _ViewEmpDocumentsListWidgetState();
}

class _ViewEmpDocumentsListWidgetState extends State<ViewEmpDocumentsListWidget> {
  @override
  void initState() {
    super.initState();
    // Fetch documents when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DocumentUploadProvider>(context, listen: false).getEmployeeDocumentsList(widget.empId);
    });
  }

  // Helper to map document type keys to user-friendly titles
  String _getDocumentTitle(String docType) {
    switch (docType) {
      case 'pan':
        return 'PAN Card';
      case 'aadhaar':
        return 'Aadhaar Card';
      case 'passbook':
        return 'Bank Passbook';
      case 'highSchool':
        return 'High School Certificate';
      case 'graduation':
        return 'Graduation Certificate';
      case 'salarySlip':
        return 'Salary Slip';
      default:
        return docType; // Fallback for unknown types
    }
  }

  // Function to open URL using url_launcher
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (mounted) { // Check if the widget is still mounted before showing SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open document. Please try again.')),
        );
      }
    }
  }

  // Method to show a confirmation dialog before deleting a document
  Future<void> _confirmDeleteDocument(String docTypeKey, String documentTitle, String fileName) async {
    print("DocType= ${docTypeKey},doctitle= ${documentTitle}");
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title:  Text('Confirm Deletion', style: AppTextStyles.bodyText1(context).copyWith(color: Colors.red)),
          content: Text('Are you sure you want to delete the $documentTitle? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // User confirmed deletion, now call the provider's delete method
      if (mounted) { // Ensure widget is still mounted before accessing context
        Provider.of<DocumentUploadProvider>(context, listen: false).delteEmpSingleDocument(
          documentType: docTypeKey, // Pass the specific document type key (e.g., 'pan')
          fileName: fileName, // Pass the specific document type key (e.g., 'pan')
          empId: widget.empId,
          context: context,
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentUploadProvider>(
      builder: (context, documentProvider, child) {
        if (documentProvider.isLoading) {
          return Center(child: loadingIndicator()); // Show a loader while data is fetching
        } else if (documentProvider.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error: ${documentProvider.errorMessage}',
                style: AppTextStyles.bodyText1(context).copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (documentProvider.getAllEmpDocuemtsListModel == null ||
            documentProvider.getAllEmpDocuemtsListModel!.data == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No documents found for this employee.',
                style: AppTextStyles.bodyText1(context).copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          // Access the 'data' object directly, which is of type 'Data'
          final Data? empDocumentsData = documentProvider.getAllEmpDocuemtsListModel!.data;

          // Create a list of document entries that are available and have valid URLs
          final List<MapEntry<String, Pan?>> availableDocuments = [];

          if (empDocumentsData != null) {
            // Manually check each document type and add it to the list if available
            // and its secure_url is not empty.
            if (empDocumentsData.pan?.secureUrl?.isNotEmpty == true) {
              availableDocuments.add(MapEntry('pan', empDocumentsData.pan));
            }
            if (empDocumentsData.aadhaar?.secureUrl?.isNotEmpty == true) {
              availableDocuments.add(MapEntry('aadhaar', empDocumentsData.aadhaar));
            }
            if (empDocumentsData.passbook?.secureUrl?.isNotEmpty == true) {
              availableDocuments.add(MapEntry('passbook', empDocumentsData.passbook));
            }
            if (empDocumentsData.highSchool?.secureUrl?.isNotEmpty == true) {
              availableDocuments.add(MapEntry('highSchool', empDocumentsData.highSchool));
            }
            if (empDocumentsData.graduation?.secureUrl?.isNotEmpty == true) {
              availableDocuments.add(MapEntry('graduation', empDocumentsData.graduation));
            }
            if (empDocumentsData.salarySlip?.secureUrl?.isNotEmpty == true) {
              availableDocuments.add(MapEntry('salarySlip', empDocumentsData.salarySlip));
            }
          }

          if (availableDocuments.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No documents uploaded for this employee yet.',
                  style: AppTextStyles.bodyText1(context).copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Employee Documents",
                  style: AppTextStyles.heading2(context),
                ),
                const SizedBox(height: 16.0),
                // Use ListView.builder to efficiently display the list of documents
                ListView.builder(
                  shrinkWrap: true, // Important when nesting ListView inside SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                  itemCount: availableDocuments.length,
                  itemBuilder: (context, index) {
                    final docTypeKey = availableDocuments[index].key;
                    final Pan? docInfo = availableDocuments[index].value; // Now this is correctly a Pan object
                    final secureUrl = docInfo?.secureUrl;
                    final publicId = docInfo?.publicId;
                    final fileName =publicId?.split('/').last ?? ""; // Get user-friendly title for dialog

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.insert_drive_file, // A generic document icon
                              color: AppColors.primary,
                              size: 30,
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getDocumentTitle(docTypeKey), // Use helper to get readable title
                                    style: AppTextStyles.heading2(context, overrideStyle: const TextStyle(fontSize: 15)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (publicId != null && publicId.isNotEmpty)
                                    Text(
                                      // Extract just the filename from the public_id
                                      publicId.split('/').last,
                                      style: AppTextStyles.bodyText2(context),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                            // View/Download Icon Button
                            if (secureUrl != null && secureUrl.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                color: AppColors.primary,
                                tooltip: 'View Document',
                                onPressed: () {
                                  _launchURL(secureUrl);
                                },
                              ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors.red,
                              tooltip: 'View Document',
                              onPressed: () {
                                // _launchURL(secureUrl);
                                _confirmDeleteDocument(docTypeKey, _getDocumentTitle(docTypeKey),fileName);
                              },
                            ),
                            // Optionally, add a delete button
                            // IconButton(
                            //   icon: const Icon(Icons.delete),
                            //   color: Colors.red,
                            //   tooltip: 'Delete Document',
                            //   onPressed: () {
                            //     // Implement document deletion logic here
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}