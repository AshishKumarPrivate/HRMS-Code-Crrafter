import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/emp_document_module/view_emp_documents_list_widget.dart';
import 'package:hrms_management_code_crafter/ui_helper/common_widget/solid_rounded_button.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';
import 'package:provider/provider.dart';
import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/app_text_styles.dart';
import '../../../../util/custom_snack_bar.dart';
import '../../../../util/responsive_helper_util.dart';
import '../../controller/emp_document_module/emp_doc_api_provider.dart';
import '../../model/emp_document_module/get_emp_document_list_model.dart';

class AddEmpDocumentUploadWidget extends StatefulWidget {
  // const AddEmpDocumentUploadWidget(employeeId, {super.key});

  final String empId; // Path to the image file to display

  const AddEmpDocumentUploadWidget({super.key, required this.empId});

  @override
  State<AddEmpDocumentUploadWidget> createState() =>
      _AddEmpDocumentUploadWidgetState();
}

class _AddEmpDocumentUploadWidgetState extends State<AddEmpDocumentUploadWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = const ["Add", "View"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("emploeeid = ${widget.empId}");
    return Column(
      children: [
        SizedBox(height: 10),

        Container(
          color: AppColors.white, // Changed background to white
          child: TabBar(
            // Changed tabAlignment to fill to make tabs take full width
            tabAlignment: TabAlignment.fill,
            controller: _tabController,
            isScrollable: false,
            // Set to false to distribute tabs evenly
            labelColor: AppColors.primary,
            // Darker color for selected label on white background
            unselectedLabelColor: AppColors.primary.withOpacity(0.6),
            // Darker color for unselected
            indicatorColor: Colors.transparent,
            // Make default indicator color transparent
            indicatorWeight: 4.0,

            // Remove the default underline visually
            // indicatorSize: TabBarIndicatorSize.tab, // Make the indicator span the full tab width
            // indicator: BoxDecoration(
            //   color: AppColors.white.withOpacity(0.1), // The color of the full-width highlight
            //   borderRadius: BorderRadius.circular(0.0), // Optional: Add rounded corners to the indicator
            //   // No 'border' property here, specifically no bottom border, to remove the line.
            // ),
            labelStyle: AppTextStyles.heading1(
              context,
              overrideStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            unselectedLabelStyle: AppTextStyles.heading1(
              context,
              overrideStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            tabs: _tabs.map((tabName) => Tab(text: tabName)).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            // disables swipe scroll
            children:
                _tabs.map((tabName) {
                  if (tabName == "Add") {
                    return AddEmpDocumentsContent(empId: widget.empId);
                  } else if (tabName == "View") {
                    return ViewEmpDocumentsListWidget(empId: widget.empId);
                  } else {
                    return Center(
                      child: Text(
                        "$tabName Content (Coming Soon)",
                        style: AppTextStyles.bodyText1(context),
                      ),
                    );
                  }
                }).toList(),
          ),
        ),

        // ..._uploadedDocuments.keys.map((docType) {
        //   final file = _uploadedDocuments[docType];
        //   final fileName = file?.path.split('/').last;
        //   return Card(
        //     margin: const EdgeInsets.symmetric(vertical: 10),
        //     elevation: 4,
        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        //     child: Padding(
        //       padding: const EdgeInsets.all(16.0),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(
        //           _documentTitles[docType] ?? docType,
        //             style: AppTextStyles.heading1(
        //               context,
        //               overrideStyle: TextStyle(
        //                 color: AppColors.primary,
        //                 fontWeight: FontWeight.bold,
        //                 fontSize: ResponsiveHelper.fontSize(context, 16),
        //               ),
        //             ),
        //           ),
        //           const SizedBox(height: 15),
        //           Container(
        //             width: double.infinity,
        //             height: file == null ? 100 : 200,
        //             decoration: BoxDecoration(
        //               color: Colors.grey[200],
        //               borderRadius: BorderRadius.circular(10),
        //               border: Border.all(color: Colors.grey.shade300),
        //             ),
        //             child: file == null
        //                 ? Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Icon(Icons.cloud_upload, size: 40, color: Colors.grey[600]),
        //                 const SizedBox(height: 8),
        //                 Text('No file selected', style: AppTextStyles.bodyText2(context)),
        //               ],
        //             )
        //                 : _isImageFile(fileName)
        //                 ? ClipRRect(
        //               borderRadius: BorderRadius.circular(10),
        //               child: Image.file(
        //                 file,
        //                 fit: BoxFit.cover,
        //                 width: double.infinity,
        //                 height: double.infinity,
        //               ),
        //             )
        //                 : Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Icon(Icons.description, size: 40, color: Colors.grey[600]),
        //                 const SizedBox(height: 8),
        //                 Padding(
        //                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //                   child: Text(
        //                     fileName ?? 'Document',
        //                     textAlign: TextAlign.center,
        //                     style: AppTextStyles.bodyText1(
        //                       context,
        //                       overrideStyle: const TextStyle(fontWeight: FontWeight.bold),
        //                     ),
        //                     maxLines: 2,
        //                     overflow: TextOverflow.ellipsis,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //           const SizedBox(height: 15),
        //           Row(
        //             children: [
        //               Expanded(
        //                 child: CustomButton(
        //                   onPressed: () => _pickFile(docType),
        //                   type: ButtonType.outlined,
        //                   text: 'Select File',
        //                   textColor: AppColors.primary,
        //                 ),
        //               ),
        //               const SizedBox(width: 10),
        //               Expanded(
        //                 child: CustomButton(
        //                   onPressed: file == null ? null : () => _clearFile(docType),
        //
        //                   // onPressed:() {file == null ? null : () => _clearFile(docType);},
        //                   text: 'Clear',
        //                   color: file == null ? Colors.grey : Colors.red,
        //                   textColor: Colors.white,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ],
        //       ),
        //     ),
        //   );
        // }),
        // const SizedBox(height: 20),
        // CustomButton(
        //   onPressed: _uploadedDocuments.values.any((file) => file != null)
        //       ? _submitDocuments
        //       : null, // disabled if no files selected
        //   text: 'Upload Selected Documents',
        //   textColor: Colors.white,
        //   color: _uploadedDocuments.values.any((file) => file != null)
        //       ? AppColors.primary
        //       : Colors.grey, // visual cue for disabled
        //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        // ),
      ],
    );
  }
}

class AddEmpDocumentsContent extends StatefulWidget {
  final String empId;

  const AddEmpDocumentsContent({super.key, required this.empId});

  @override
  State<AddEmpDocumentsContent> createState() => _AddEmpDocumentsContentState();
}

class _AddEmpDocumentsContentState extends State<AddEmpDocumentsContent> {
  final Map<String, dynamic> _uploadedDocuments = {
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

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<DocumentUploadProvider>(context, listen: false).getEmployeeDocumentsList(widget.empId);
    // });
    _fetchAndSetExistingDocuments();
  }

  Future<void> _fetchAndSetExistingDocuments() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final provider = Provider.of<DocumentUploadProvider>(
        context,
        listen: false,
      );
      // final Data? empDocumentsData = provider.getAllEmpDocuemtsListModel!.data;

      // Create a list of document entries that are available and have valid URLs
      final List<MapEntry<String, Pan?>> availableDocuments = [];
      await provider.getEmployeeDocumentsList(widget.empId);

      // Now access the data from the provider's model
      final Data? empDocumentsData = provider.getAllEmpDocuemtsListModel?.data;

      if (empDocumentsData != null) {
        setState(() {
          // Populate _documents with existing data from the API
          // Only if secureUrl is not empty, means the document exists
          if (empDocumentsData.pan?.secureUrl?.isNotEmpty == true) {
            _uploadedDocuments['pan'] = empDocumentsData.pan;
          }
          if (empDocumentsData.aadhaar?.secureUrl?.isNotEmpty == true) {
            _uploadedDocuments['aadhaar'] = empDocumentsData.aadhaar;
          }
          if (empDocumentsData.passbook?.secureUrl?.isNotEmpty == true) {
            _uploadedDocuments['passbook'] = empDocumentsData.passbook;
          }
          if (empDocumentsData.highSchool?.secureUrl?.isNotEmpty == true) {
            _uploadedDocuments['highSchool'] = empDocumentsData.highSchool;
          }
          if (empDocumentsData.graduation?.secureUrl?.isNotEmpty == true) {
            _uploadedDocuments['graduation'] = empDocumentsData.graduation;
          }
          if (empDocumentsData.salarySlip?.secureUrl?.isNotEmpty == true) {
            _uploadedDocuments['salarySlip'] = empDocumentsData.salarySlip;
          }
        });
      } else {
        // Optionally show a message if no documents are found
        // CustomSnackbarHelper.customShowSnackbar(
        //   context: context,
        //   backgroundColor: Colors.orange,
        //   message: "No existing documents found for this employee.",
        // );
      }
    } catch (e) {
      CustomSnackbarHelper.customShowSnackbar(
        context: context,
        backgroundColor: Colors.red,
        message: "Error fetching documents: $e",
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


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
        message: "No file selected",
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
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png');
  }

  void _submitDocuments(bool isUpdate) async {
    // final allSelected = _uploadedDocuments.values.every((file) => file != null);

    final Map<String, File> filesToUpload = {};
    // final selectedDocs = _uploadedDocuments.entries.where(
    //   (entry) => entry.value != null,
    // );
    _uploadedDocuments.forEach((key, value) {
      if (value is File) {
        filesToUpload[key] = value;
      }
    });

    if (filesToUpload.isEmpty) {
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

    final provider = Provider.of<DocumentUploadProvider>(
      context,
      listen: false,
    );
    // final Map<String, File> nonNullableDocs = {
    //   for (var entry in selectedDocs) entry.key: entry.value!,
    // };

    // You can get empId from Provider, SharedPreferences, or pass it down
    // const empId = "684c0b49d47b187e7497fb05"; // Replace with actual logic
    // final empId = await StorageHelper().getEmpLoginRegistrationId();

    if(isUpdate) {
      await provider.updateEmployeeDocuments(
        documents: filesToUpload,
        empId: widget.empId,
        context: context,
      );
    }else{
      await provider.uploadEmployeeDocuments(
        documents: filesToUpload,
        empId: widget.empId,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("emploeeid = ${widget.empId}");
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [

          ..._uploadedDocuments.keys.map((docType) {
            final dynamic document = _uploadedDocuments[docType]; // Can be File, Pan, or null
            String? fileName;
            String? fileUrl;
            bool isLocalFile = false;

            if (document is File) {
              isLocalFile = true;
              fileName = document.path.split('/').last;
            } else if (document is Pan) {
              fileName = document.secureUrl?.split('/').last;
              fileUrl = document.secureUrl;
            }

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
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
                      height: document == null ? 100 : 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: document == null
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload,
                            size: 40,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No file selected',
                            style: AppTextStyles.bodyText2(context),
                          ),
                        ],
                      )
                          : isLocalFile
                          ? _isImageFile(fileName)
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          document as File,
                          fit: BoxFit.contain, // ✅ No crop
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.description,
                            size: 40,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              fileName ?? 'Document',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyText1(
                                context,
                                overrideStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                          : // Display from URL (Pan object)
                      fileUrl != null
                          ? _isImageFile(fileName)
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          fileUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.broken_image, size: 40, color: Colors.red),
                            );
                          },
                        ),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insert_drive_file, // Generic file icon for non-images
                            size: 40,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              fileName ?? 'Document',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyText1(
                                context,
                                overrideStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '(Previously uploaded)',
                            style: AppTextStyles.bodyText2(context)?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      )
                          : const SizedBox.shrink(), // Should not happen if Pan object but secureUrl is null
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector( // Use GestureDetector for tap detection
                            onTap: () => _pickFile(docType),
                            child: Container(
                              // Mimic button padding and border, if needed
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Adjusted padding for smaller size
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8), // Smaller border radius
                                border: Border.all(color: AppColors.primary), // Outlined style
                              ),
                              child: Text(
                                'Select File',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyText2(context)?.copyWith( // Using bodyText2 for smaller font
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold, // Keep bold if desired
                                  fontSize: 12, // Explicitly smaller font size
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector( // Use GestureDetector for tap detection
                            onTap: document == null
                                ? null // Keep null for disabled state
                                : () => _clearFile(docType),
                            child: Container(
                              // Mimic button padding and color
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Adjusted padding for smaller size
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8), // Smaller border radius
                                color: document == null ? Colors.grey : Colors.red, // Background color
                              ),
                              child: Text(
                                'Clear',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyText2(context)?.copyWith( // Using bodyText2 for smaller font
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold, // Keep bold if desired
                                  fontSize: 12, // Explicitly smaller font size
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed:
                      _uploadedDocuments.values.any((file) => file != null)
                          ? () => _submitDocuments(false)
                          : null,
                  // disabled if no files selected
                  text: 'Save',
                  textColor: Colors.white,
                  color:
                      _uploadedDocuments.values.any((file) => file != null)
                          ? AppColors.primary
                          : Colors.grey,
                  // visual cue for disabled
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomButton(
                  onPressed:
                      _uploadedDocuments.values.any((file) => file != null)
                          ? () => _submitDocuments(true)
                          : null,
                  // disabled if no files selected
                  text: 'Update',
                  textColor: Colors.white,
                  color:
                      _uploadedDocuments.values.any((file) => file != null)
                          ? Colors.amber
                          : Colors.grey,
                  // visual cue for disabled
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
