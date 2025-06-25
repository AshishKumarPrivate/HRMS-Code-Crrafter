// import 'dart:io';
//
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:hrms_management_code_crafter/screen/nav_home/model/emp_salary_slip_emp_side_model.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
//
// import 'package:hrms_management_code_crafter/admin/employee/screen/salary_slip/controller/admin_emp_salary_slip_api_provider.dart';
// import '../../../../ui_helper/app_colors.dart';
// import '../../../../ui_helper/app_text_styles.dart';
// import '../../../../ui_helper/common_widget/default_common_app_bar.dart';
// import '../../../util/responsive_helper_util.dart';
// import '../../../util/storage_util.dart';
//
// class SalarySlipEmpSideScreen extends StatefulWidget {
//   const SalarySlipEmpSideScreen({super.key});
//
//   @override
//   State<SalarySlipEmpSideScreen> createState() =>
//       _SalarySlipEmpSideScreenState();
// }
//
// class _SalarySlipEmpSideScreenState extends State<SalarySlipEmpSideScreen> {
//   DateTime? startDate;
//   DateTime? endDate;
//   late DateTime now;
//   String? employeeRegistrationId;
//
//   @override
//   void initState() {
//     super.initState();
//     now = DateTime.now();
//     startDate = DateTime(now.year, now.month, 1); // First day of current month
//     endDate = now; // Today's date
//     loadSalarySlipData();
//   }
//
//   Future<void> loadSalarySlipData() async {
//     employeeRegistrationId = await StorageHelper().getEmpLoginRegistrationId();
//
//     if (employeeRegistrationId != null) {
//       final String formattedStartDate =
//           "${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}";
//
//       final String formattedEndDate =
//           "${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}";
//
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         final provider = Provider.of<AdminEmpSalarySlipApiProvider>(
//           context,
//           listen: false,
//         );
//         provider.empSalarySlipEmpSide(
//           startDate: formattedStartDate,
//           endDate: formattedEndDate,
//         );
//       });
//     }
//   }
//
//   Future<void> _pickStartDate() async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: startDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: endDate ?? DateTime.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         startDate = picked;
//         if (endDate != null && picked.isAfter(endDate!)) {
//           endDate = null;
//         }
//         loadSalarySlipData(); // Reload data with new start date
//       });
//     }
//   }
//
//   Future<void> _pickEndDate() async {
//     DateTime initialDate = endDate ?? DateTime.now();
//     DateTime firstDate = startDate ?? DateTime(2000);
//
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: firstDate,
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         endDate = picked;
//         if (startDate != null && picked.isBefore(startDate!)) {
//           startDate = null;
//         }
//         loadSalarySlipData(); // Reload data with new end date
//       });
//     }
//   }
//
//   void _clearDateFilters() {
//     setState(() {
//       startDate = DateTime(now.year, now.month, 1);
//       endDate = now;
//       loadSalarySlipData(); // Reload data after clearing filters
//     });
//   }
//
//   String _formatDate(DateTime? date) {
//     if (date == null) return 'Select';
//     return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
//   }
//
//   Future<bool> checkStoragePermission() async {
//     if (Platform.isAndroid) {
//       final androidInfo = await DeviceInfoPlugin().androidInfo;
//       final sdkInt = androidInfo.version.sdkInt;
//
//       if (sdkInt >= 30) {
//         final status = await Permission.manageExternalStorage.request();
//         return status.isGranted;
//       } else {
//         final status = await Permission.storage.request();
//         return status.isGranted;
//       }
//     }
//     return true;
//   }
//
//   // Future<void> exportToPDF(List<EmpSalarySlipEmpSideModel> data) async {
//   //
//   //   if (!await checkStoragePermission()) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text("Storage permission denied")),
//   //     );
//   //     return;
//   //   }
//   //
//   //   final pdf = pw.Document();
//   //   pdf.addPage(
//   //     pw.MultiPage(
//   //       build:
//   //           (context) => [
//   //             pw.Center(
//   //               child: pw.Text(
//   //                 'Attendance Report',
//   //                 style: pw.TextStyle(
//   //                   fontSize: 22,
//   //                   fontWeight: pw.FontWeight.bold,
//   //                 ),
//   //               ),
//   //             ),
//   //             pw.SizedBox(height: 20),
//   //             pw.Table.fromTextArray(
//   //               headers: [
//   //                 'S.No',
//   //                 'Name',
//   //                 'Email',
//   //                 'Mobile',
//   //                 'Date',
//   //                 'CheckIn',
//   //                 'CheckOut',
//   //                 'Working Hours',
//   //                 'Over Time Hrs',
//   //                 'Status',
//   //               ],
//   //               data: List<List<String>>.generate(
//   //                 data.length,
//   //                 (i) => [
//   //                   '${i + 1}',
//   //                   data[i].name,
//   //                   data[i].email,
//   //                   data[i].mobile,
//   //                   data[i].date,
//   //                   data[i].checkIn,
//   //                   data[i].checkOut,
//   //                   data[i].totalWorkingHours,
//   //                   data[i].otTime,
//   //                   data[i].status,
//   //                 ],
//   //               ),
//   //             ),
//   //           ],
//   //     ),
//   //   );
//   //
//   //   final dir = await getDownloadDirectory();
//   //   final filePath = '${dir?.path}/attendance_report.pdf';
//   //   final file =
//   //       File(filePath!)
//   //         ..createSync(recursive: true)
//   //         ..writeAsBytesSync(await pdf.save());
//   //
//   //   await Share.shareXFiles([XFile(file.path)], text: 'Attendance PDF Report');
//   //   ScaffoldMessenger.of(
//   //     context,
//   //   ).showSnackBar(SnackBar(content: Text('PDF saved to: $filePath')));
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<AdminEmpSalarySlipApiProvider>();
//     final model = provider.empSalarySlipEmpSideModel?.data;
//     final employee = model?.employeeData;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6FA),
//
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         // Set AppBar background color
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white), // Back button
//           onPressed: () {
//             Navigator.of(context).pop(); // Navigate back
//           },
//         ),
//         title: Text(
//           'Salary Slip',
//           style: AppTextStyles.heading1(
//             context,
//             overrideStyle: TextStyle(
//               color: Colors.white,
//               fontSize: ResponsiveHelper.fontSize(context, 14),
//             ),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.picture_as_pdf, color: AppColors.white),
//             onPressed: () => (),
//             // onPressed: () => exportToPDF(filteredData),
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(50),
//           child: Column(
//             children: [
//               const SizedBox(height: 5),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 18,
//                   vertical: 4,
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: _pickStartDate,
//                         style: OutlinedButton.styleFrom(
//                           // backgroundColor: AppColors.white, // Still want white background
//                           foregroundColor: AppColors.primary,
//                           // Text color
//                           side: const BorderSide(color: AppColors.white),
//                           // Add a border with primary color
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 1),
//                         ),
//                         child: Column(
//                           children: [
//                             Text(
//                               'Start Date',
//                               style: AppTextStyles.heading1(
//                                 context,
//                                 overrideStyle: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: ResponsiveHelper.fontSize(
//                                     context,
//                                     12,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               '${_formatDate(startDate)}',
//                               style: AppTextStyles.heading1(
//                                 context,
//                                 overrideStyle: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: ResponsiveHelper.fontSize(
//                                     context,
//                                     12,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: OutlinedButton(
//                         onPressed: _pickEndDate,
//                         style: OutlinedButton.styleFrom(
//                           // backgroundColor: AppColors.white, // Still want white background
//                           foregroundColor: AppColors.primary,
//                           // Text color
//                           side: const BorderSide(color: AppColors.white),
//                           // Add a border with primary color
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 1),
//                         ),
//                         child: Column(
//                           children: [
//                             Text(
//                               'End Date',
//                               style: AppTextStyles.heading1(
//                                 context,
//                                 overrideStyle: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: ResponsiveHelper.fontSize(
//                                     context,
//                                     12,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               '${_formatDate(endDate)}',
//                               style: AppTextStyles.heading1(
//                                 context,
//                                 overrideStyle: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: ResponsiveHelper.fontSize(
//                                     context,
//                                     12,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     // const SizedBox(width: 8),
//                     IconButton(
//                       icon: const Icon(Icons.clear, color: AppColors.white),
//                       tooltip: 'Clear Date Filters',
//                       onPressed: _clearDateFilters,
//                     ),
//                   ],
//                 ),
//               ),
//
//               // const SizedBox(height: 5),
//             ],
//           ),
//         ),
//       ),
//       body:
//       provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : provider.empSalarySlipEmpSideModel == null
//           ? const Center(child: Text("❌ Failed to load salary data."))
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _header(context),
//             const SizedBox(height: 16),
//             _employeeInfoCard(context, employee),
//             const SizedBox(height: 16),
//             _ctcBreakdownCard(context, model?.salary ?? 0),
//             const SizedBox(height: 16),
//             _salaryDetailsCard(context),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _header(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.primary,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.attach_money, color: Colors.white, size: 40),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Comprehensive\nCTC Details",
//                   style: AppTextStyles.bodyText1(
//                     context,
//                     overrideStyle: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   "Easily access detailed CTC breakdowns and insights.",
//                   style: AppTextStyles.bodyText2(
//                     context,
//                     overrideStyle: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _employeeInfoCard(BuildContext context, dynamic employee) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _cardDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Employee Info",
//             style: AppTextStyles.heading1(
//               context,
//               overrideStyle: const TextStyle(fontSize: 16),
//             ),
//           ),
//           const SizedBox(height: 12),
//           _infoRow(context, "Name", employee?.name ?? "N/A"),
//           _infoRow(context, "Email", employee?.email ?? "N/A"),
//         ],
//       ),
//     );
//   }
//
//   Widget _ctcBreakdownCard(BuildContext context, int totalSalary) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _cardDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Total Gross Pay",
//                 style: AppTextStyles.heading1(
//                   context,
//                   overrideStyle: const TextStyle(fontSize: 16),
//                 ),
//               ),
//               Text(
//                 "₹ $totalSalary",
//                 style: AppTextStyles.heading2(
//                   context,
//                   overrideStyle: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Text(
//             "Effective from: Apr 2025",
//             style: AppTextStyles.bodyText2(
//               context,
//               overrideStyle: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           const Divider(height: 24),
//           _ctcRow(context, "Gross benefits", totalSalary ~/ 2, Colors.green),
//           _ctcRow(context, "Other benefits", totalSalary ~/ 4, Colors.orange),
//           _ctcRow(context, "Contributions", totalSalary ~/ 8, Colors.yellow),
//           _ctcRow(
//             context,
//             "Recurring Deduction",
//             totalSalary ~/ 8,
//             Colors.purple,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _ctcRow(
//       BuildContext context,
//       String label,
//       int? value,
//       Color dotColor,
//       ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               label,
//               style: AppTextStyles.heading2(
//                 context,
//                 overrideStyle: const TextStyle(fontSize: 14),
//               ),
//             ),
//           ),
//           Text(
//             "₹ ${value ?? 0}",
//             style: AppTextStyles.heading2(
//               context,
//               overrideStyle: const TextStyle(fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _salaryDetailsCard(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _cardDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: const [
//           Text(
//             "Salary Details",
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//           SizedBox(height: 12),
//           _StaticInfoRow("Salary revision month", "April"),
//           _StaticInfoRow("Arrear effect from", "April"),
//           _StaticInfoRow("Pay group", "A1"),
//         ],
//       ),
//     );
//   }
//
//   Widget _infoRow(BuildContext context, String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: AppTextStyles.bodyText1(
//               context,
//               overrideStyle: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           Text(
//             value,
//             style: AppTextStyles.bodyText1(
//               context,
//               overrideStyle: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   BoxDecoration _cardDecoration() {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       boxShadow: const [
//         BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
//       ],
//     );
//   }
// }
//
// class _StaticInfoRow extends StatelessWidget {
//   final String title;
//   final String value;
//
//   const _StaticInfoRow(this.title, this.value);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: AppTextStyles.bodyText2(
//               context,
//               overrideStyle: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           Text(
//             value,
//             style: AppTextStyles.heading2(
//               context,
//               overrideStyle: const TextStyle(fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
