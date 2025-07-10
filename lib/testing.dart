// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:hrms_management_code_crafter/screen/nav_home/model/emp_salary_slip_emp_side_model.dart';
// import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
// import 'package:provider/provider.dart';
// import 'package:hrms_management_code_crafter/admin/employee/screen/salary_slip/controller/admin_emp_salary_slip_api_provider.dart';
// import '../../../../ui_helper/app_colors.dart';
// import '../../../../ui_helper/app_text_styles.dart';
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
//     startDate = DateTime(now.year, now.month, 1);
//     endDate = now;
//     loadSalarySlipData();
//   }
//
//   Future<void> loadSalarySlipData() async {
//     employeeRegistrationId = await StorageHelper().getEmpLoginRegistrationId();
//     if (employeeRegistrationId != null) {
//       final String formattedStartDate =
//           "${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}";
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
//         loadSalarySlipData();
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
//         loadSalarySlipData();
//       });
//     }
//   }
//
//   void _clearDateFilters() {
//     setState(() {
//       startDate = DateTime(now.year, now.month, 1);
//       endDate = now;
//       loadSalarySlipData();
//     });
//   }
//
//   String _formatDate(DateTime? date) {
//     if (date == null) return 'Select';
//     return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<AdminEmpSalarySlipApiProvider>();
//     final model = provider.empSalarySlipEmpSideModel?.data;
//     final employee = model?.employeeData;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
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
//             icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
//             onPressed: () {},
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(50),
//           child:   Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 18,
//               vertical: 4,
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: _pickStartDate,
//                     style: OutlinedButton.styleFrom(
//                       // backgroundColor: AppColors.white, // Still want white background
//                       foregroundColor: AppColors.primary,
//                       // Text color
//                       side: const BorderSide(color: AppColors.white),
//                       // Add a border with primary color
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 1),
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           'From',
//                           style: AppTextStyles.heading1(
//                             context,
//                             overrideStyle: TextStyle(
//                               color: Colors.white,
//                               fontSize: ResponsiveHelper.fontSize(
//                                 context,
//                                 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Text(
//                           '${_formatDate(startDate)}',
//                           style: AppTextStyles.heading1(
//                             context,
//                             overrideStyle: TextStyle(
//                               color: Colors.white,
//                               fontSize: ResponsiveHelper.fontSize(
//                                 context,
//                                 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: _pickEndDate,
//                     style: OutlinedButton.styleFrom(
//                       // backgroundColor: AppColors.white, // Still want white background
//                       foregroundColor: AppColors.primary,
//                       // Text color
//                       side: const BorderSide(color: AppColors.white),
//                       // Add a border with primary color
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 1),
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           'To',
//                           style: AppTextStyles.heading1(
//                             context,
//                             overrideStyle: TextStyle(
//                               color: Colors.white,
//                               fontSize: ResponsiveHelper.fontSize(
//                                 context,
//                                 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Text(
//                           '${_formatDate(endDate)}',
//                           style: AppTextStyles.heading1(
//                             context,
//                             overrideStyle: TextStyle(
//                               color: Colors.white,
//                               fontSize: ResponsiveHelper.fontSize(
//                                 context,
//                                 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.clear, color: AppColors.white),
//                   tooltip: 'Clear Date Filters',
//                   onPressed: _clearDateFilters,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body:
//       provider.isLoading
//           ? loadingIndicator()
//           : provider.empSalarySlipEmpSideModel == null
//           ? Center(child: Text("\u274C No salary data available."))
//           : InteractiveViewer(
//         boundaryMargin: const EdgeInsets.all(20),
//         minScale: 0.5,
//         maxScale: 3.0,
//         panEnabled: true,
//         scaleEnabled: true,
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Container(
//             width: 1000,
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Text(
//                     "www.MSOfficeGeek.com",
//                     style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Center(child: Text("Company Address", style: TextStyle(fontSize: 16))),
//                 Center(child: Text("Salary Slip for the month of ${now.month}-${now.year}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
//                 Divider(),
//                 Table(
//                   border: TableBorder.all(),
//                   columnWidths: const {
//                     0: FlexColumnWidth(2),
//                     1: FlexColumnWidth(3),
//                     2: FlexColumnWidth(2),
//                     3: FlexColumnWidth(3),
//                   },
//                   children: [
//                     _buildTableRow(["UID:", employee?.registrationId ?? '', "Designation:", "employee?.designation" ?? '']),
//                     _buildTableRow(["Name:", employee?.name ?? '', "Department:", "employee?.department" ?? '']),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Text("Employee Attendance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 Table(
//                   border: TableBorder.all(),
//                   columnWidths: const {
//                     0: FlexColumnWidth(2),
//                     1: FlexColumnWidth(1.5),
//                     2: FlexColumnWidth(2),
//                     3: FlexColumnWidth(1.5),
//                   },
//                   children: [
//                     _buildTableRow(["Working Days:", "31", "Payable Days:", "28"]),
//                     _buildTableRow(["Leave Allowed:", "2", "Leave Taken:", "5"]),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Text("Salary Transferred To:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 Table(
//                   border: TableBorder.all(),
//                   columnWidths: const {
//                     0: FlexColumnWidth(2),
//                     1: FlexColumnWidth(3),
//                   },
//                   children: [
//                     _buildTableRow(["Bank Name:", "employee?.bankName" ?? '']),
//                     _buildTableRow(["Account No:", "employee?.accountNo" ?? '']),
//                     _buildTableRow(["Branch Name:", "DEF Branch 1"]),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   TableRow _buildTableRow(List<String> cells) {
//     return TableRow(
//       children:
//       cells
//           .map(
//             (cell) => Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(cell, style: TextStyle(fontSize: 14)),
//         ),
//       )
//           .toList(),
//     );
//   }
// }
