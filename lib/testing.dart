// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:hrms_management_code_crafter/admin/employee/controller/employee_api_provider.dart';
// import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
// import 'package:provider/provider.dart';
//
// import '../../../ui_helper/app_colors.dart';
// import '../../../ui_helper/app_text_styles.dart';
// import '../../../ui_helper/common_widget/default_common_app_bar.dart';
// import '../../../util/responsive_helper_util.dart';
// import '../model/employee_list_model.dart';
//
// class EmployeeDetailScreen extends StatefulWidget {
//   const EmployeeDetailScreen({super.key});
//
//   @override
//   State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
// }
//
// class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch employee list when screen opens
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<EmployeeApiProvider>(
//         context,
//         listen: false,
//       ).getEmployeeList();
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.lightBgColor,
//       appBar: DefaultCommonAppBar(
//         activityName: "Employee Profile",
//         backgroundColor: AppColors.primary,
//       ),
//       body: Consumer<EmployeeApiProvider>(
//         builder: (context, provider, child) {
//           if (provider.isLoading) {
//             return loadingIndicator();
//           }
//           if (provider.errorMessage.isNotEmpty) {
//             return Center(child: Text(provider.errorMessage));
//           }
//           if (provider.filteredEmployees.isEmpty) {
//             return const Center(child: Text('No employees found.'));
//           }
//           return RefreshIndicator(
//             onRefresh: () => provider.refreshEmployeeList(),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   // Header section
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 20),
//                     child: Column(
//                       children: [
//                         const CircleAvatar(
//                           radius: 45,
//                           backgroundColor: Colors.white,
//                           child: Icon(Icons.person, size: 50, color: Colors.grey),
//                         ),
//                         const SizedBox(height: 10),
//                         const Text(
//                           'GOLD CLUB',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         const Text(
//                           'drvghargharbazar65@gmail.com',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Card with info icons
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 20),
//                     padding: const EdgeInsets.symmetric(vertical: 20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 10,
//                           offset: Offset(0, 4),
//                         )
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: const [
//                         _InfoItem(icon: Icons.phone_android, title: "Phone", value: "9876543210"),
//                         _InfoItem(icon: Icons.person_outline, title: "User Type", value: "Associate"),
//                         _InfoItem(icon: Icons.group, title: "Ref Code", value: "GLDGGB"),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Details section
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     decoration: const BoxDecoration(color: Colors.white),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         _ProfileField(label: "User Id", value: "5"),
//                         _ProfileField(label: "Aadhar", value: "8888888"),
//                         _ProfileField(label: "PAN Number", value: "CMUPM5389Q"),
//                         _ProfileField(label: "Relation", value: "NA"),
//                         _ProfileField(label: "Relation Name", value: "DRVGBG"),
//                         _ProfileField(label: "State", value: "UTTAR PRADESH"),
//                         _ProfileField(label: "City", value: "LUCKNOW"),
//                         _ProfileField(label: "Address", value: "H-37"),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Update button
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: OutlinedButton(
//                       onPressed: () {
//                         // Handle update
//                       },
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         side: const BorderSide(color: Colors.blue),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         foregroundColor: Colors.blue,
//                       ),
//                       child: const Center(
//                         child: Text(
//                           "Update Profile",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class _InfoItem extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String value;
//
//   const _InfoItem({
//     required this.icon,
//     required this.title,
//     required this.value,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: Colors.blue.shade50,
//           child: Icon(icon, color: Colors.blue),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           title,
//           style: const TextStyle(fontSize: 12, color: Colors.black54),
//         ),
//         Text(
//           value,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }
//
// class _ProfileField extends StatelessWidget {
//   final String label;
//   final String value;
//
//   const _ProfileField({
//     required this.label,
//     required this.value,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Expanded(
//               flex: 2,
//               child: Text(label,
//                   style: const TextStyle(fontWeight: FontWeight.w500))),
//           Expanded(flex: 3, child: Text(value)),
//         ],
//       ),
//     );
//   }
// }
