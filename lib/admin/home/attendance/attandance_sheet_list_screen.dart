import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/ui_helper/app_colors.dart';
import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../screen/emp_attandance/controller/emp_attendance_chart_provider.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../util/responsive_helper_util.dart';
import '../../../util/storage_util.dart';

class AttendanceSheetTableScreen extends StatefulWidget {
  const AttendanceSheetTableScreen({super.key});

  @override
  State<AttendanceSheetTableScreen> createState() =>
      _AttendanceSheetTableScreenState();
}

class AttendanceModel {
  final String name,
      email,
      mobile,
      date,
      checkIn,
      checkOut,
      totalWorkingHours,
      otTime,
      status;

  AttendanceModel({
    required this.name,
    required this.email,
    required this.mobile,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.totalWorkingHours,
    required this.otTime,
    required this.status,
  });
}

class _AttendanceSheetTableScreenState
    extends State<AttendanceSheetTableScreen> {
  String selectedStatus = 'All';
  String searchQuery = '';
  String selectedDate = 'All';

  DateTime? startDate;
  DateTime? endDate;

  late DateTime now;
  String? employeeId;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    // startDate = DateTime(now.year, now.month, 1); // First day of current month
    startDate = now; // First day of current month
    endDate = now; // Today's date
    loadAttendanceData();
  }

  Future<void> loadAttendanceData() async {
    employeeId = await StorageHelper().getEmpLoginId();

    if (employeeId != null) {
      final String formattedStartDate =
          "${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}";
      final String formattedEndDate =
          "${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}";

      Provider.of<AttendanceChartProvider>(
        context,
        listen: false,
      ).filterAttendanceExcel(
        startDate: formattedStartDate,
        endDate: formattedEndDate,
      );
    }
  }

  // Helper function to format date from API (assuming YYYY-MM-DD or similar)
  String _formatDateFromApi(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
    } catch (e) {
      return dateString; // Return as is if parsing fails
    }
  }

  // Helper function to parse date from dd/MM/yyyy format
  DateTime _parseDate(String dateStr) {
    final parts = dateStr.split('/');
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  List<String> get allDates {
    final provider = Provider.of<AttendanceChartProvider>(
      context,
      listen: false,
    );
    final apiData = provider.adminFilterAttendanceModel?.attendanceData ?? [];
    final dates =
    apiData.map((e) => _formatDateFromApi(e.date)).toSet().toList();
    dates.sort((a, b) {
      final d1 = _parseDate(a);
      final d2 = _parseDate(b);
      return d1.compareTo(d2);
    });
    return ['All'] + dates;
  }

  List<AttendanceModel> get filteredData {
    final provider = Provider.of<AttendanceChartProvider>(
      context,
      listen: false,
    );
    final apiData = provider.adminFilterAttendanceModel?.attendanceData ?? [];

    // Helper function to convert UTC DateTime to IST formatted string
    String _formatISTTime(DateTime utcTime) {
      // Convert to UTC first, then add the IST offset.
      // This ensures consistent conversion even if DateTime.parse
      // initially interprets it differently based on local timezone.
      final istTime = utcTime.toUtc().add(Duration(hours: 5, minutes: 30));
      return DateFormat('hh:mm a').format(istTime);
    }

    final List<AttendanceModel> attendanceList =
    apiData.map((entry) {
      return AttendanceModel(
        name: entry.employeeId?.name ?? '',
        email: entry.employeeId?.email ?? '',
        mobile: entry.employeeId?.mobile ?? '',
        date: _formatDateFromApi(entry.date),
        checkIn:
        entry.loginTime != null
            ? _formatISTTime(DateTime.parse(entry.loginTime.toString()))
            : '-',
        // checkIn:  entry.loginTime ?? 'N/A',
        // checkOut: entry.logoutTime ?? 'N/A',
        checkOut:
        entry.logoutTime != null
            ? _formatISTTime(
          DateTime.parse(entry.logoutTime.toString()),
        )
            : '-',
        totalWorkingHours: entry.workingHours ?? '-',
        otTime: entry.otTime ?? '-',
        status:
        entry.status == "present"
            ? "Present"
            : entry.status == "absent"
            ? "Absent"
            : entry.status == "wfh"
            ? "WFH"
            : "-",
      );
    }).toList();

    return attendanceList.where((item) {
      final matchesStatus =
          selectedStatus == 'All' ||
              item.status.toLowerCase() == selectedStatus.toLowerCase();

      final matchesDate = selectedDate == 'All' || item.date == selectedDate;

      final matchesSearch =
          searchQuery.isEmpty ||
              item.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              item.email.toLowerCase().contains(searchQuery.toLowerCase()) ||
              item.mobile.contains(searchQuery);

      bool matchesDateRange = true;
      if (startDate != null) {
        matchesDateRange = _parseDate(
          item.date,
        ).isAfter(startDate!.subtract(const Duration(days: 1)));
      }
      if (matchesDateRange && endDate != null) {
        matchesDateRange = _parseDate(
          item.date,
        ).isBefore(endDate!.add(const Duration(days: 1)));
      }

      return matchesStatus && matchesDate && matchesSearch && matchesDateRange;
    }).toList();
  }

  Future<Directory?> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      Directory dir = Directory('/storage/emulated/0/Download');
      if (await dir.exists()) return dir;
    }
    return await getApplicationDocumentsDirectory();
  }

  Future<bool> checkStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 30) {
        final status = await Permission.manageExternalStorage.request();
        return status.isGranted;
      } else {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    return true;
  }

  Future<void> exportToExcel(List<AttendanceModel> data) async {
    if (!await checkStoragePermission()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission denied")),
      );
      return;
    }

    final excel = Excel.createExcel();
    final sheet = excel['Attendance'];

    sheet.appendRow([
      'S.No',
      'Name',
      'Email',
      'Mobile',
      'Date',
      'CheckIn',
      'CheckOut',
      'Working Hrs',
      'Over Time Hrs',
      'Status',
    ]);

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      sheet.appendRow([
        '${i + 1}',
        item.name,
        item.email,
        item.mobile,
        item.date,
        item.checkIn,
        item.checkOut,
        item.totalWorkingHours,
        item.otTime,
        item.status,
      ]);
    }

    final dir = await getDownloadDirectory();
    final filePath = '${dir?.path}/attendance_report.xlsx';
    final file =
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'Attendance Excel Report');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Excel saved to: $filePath')));
  }

  Future<void> exportToPDF(List<AttendanceModel> data) async {
    if (!await checkStoragePermission()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission denied")),
      );
      return;
    }

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build:
            (context) => [
          pw.Center(
            child: pw.Text(
              'Attendance Report',
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: [
              'S.No',
              'Name',
              'Email',
              'Mobile',
              'Date',
              'CheckIn',
              'CheckOut',
              'Working Hours',
              'Over Time Hrs',
              'Status',
            ],
            data: List<List<String>>.generate(
              data.length,
                  (i) => [
                '${i + 1}',
                data[i].name,
                data[i].email,
                data[i].mobile,
                data[i].date,
                data[i].checkIn,
                data[i].checkOut,
                data[i].totalWorkingHours,
                data[i].otTime,
                data[i].status,
              ],
            ),
          ),
        ],
      ),
    );

    final dir = await getDownloadDirectory();
    final filePath = '${dir?.path}/attendance_report.pdf';
    final file =
    File(filePath!)
      ..createSync(recursive: true)
      ..writeAsBytesSync(await pdf.save());

    await Share.shareXFiles([XFile(file.path)], text: 'Attendance PDF Report');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('PDF saved to: $filePath')));
  }

  Future<void> _pickStartDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: endDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
        if (endDate != null && picked.isAfter(endDate!)) {
          endDate = null;
        }
        loadAttendanceData(); // Reload data with new start date
      });
    }
  }

  Future<void> _pickEndDate() async {
    DateTime initialDate = endDate ?? DateTime.now();
    DateTime firstDate = startDate ?? DateTime(2000);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        endDate = picked;
        if (startDate != null && picked.isBefore(startDate!)) {
          startDate = null;
        }
        loadAttendanceData(); // Reload data with new end date
      });
    }
  }

  void _clearDateFilters() {
    setState(() {
      // startDate = DateTime(now.year, now.month, 1);
      startDate = now;
      endDate = now;
      loadAttendanceData(); // Reload data after clearing filters
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AttendanceChartProvider>(context);
    final data = provider.adminFilterAttendanceModel?.data ?? [];

    if (provider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary, // Set AppBar background color
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            // Back button
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back
            },
          ),
          title: Text(
            'Attendance Table',
            style: AppTextStyles.heading1(
              context,
              overrideStyle: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(context, 14),
              ),
            ),
          ),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.file_download, color: AppColors.white),
          //     tooltip: 'Export to Excel',
          //     onPressed: () => exportToExcel(filteredData),
          //   ),
          //   IconButton(
          //     icon: const Icon(Icons.picture_as_pdf, color: AppColors.white),
          //     tooltip: 'Export to PDF',
          //     onPressed: () => exportToPDF(filteredData),
          //   ),
          //   // Removed the filter icons from here, they will be part of the bottom section
          // ],
        ),
        body: loadingIndicator(),
      );
    }

    if (data.isEmpty && !provider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary, // Set AppBar background color
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            // Back button
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back
            },
          ),
          title: Text(
            'Attendance Table',
            style: AppTextStyles.heading1(
              context,
              overrideStyle: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(context, 14),
              ),
            ),
          ),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.file_download, color: AppColors.white),
          //     tooltip: 'Export to Excel',
          //     onPressed: () => exportToExcel(filteredData),
          //   ),
          //   IconButton(
          //     icon: const Icon(Icons.picture_as_pdf, color: AppColors.white),
          //     tooltip: 'Export to PDF',
          //     onPressed: () => exportToPDF(filteredData),
          //   ),
          //   // Removed the filter icons from here, they will be part of the bottom section
          // ],
        ),
        body: Center(
          child: Text(
            'No attendance data found for the selected filters.',
            style: AppTextStyles.heading2(
              context,
              overrideStyle: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 12),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        // Set AppBar background color
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Back button
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
        title: Text(
          'Attendance Table',
          style: AppTextStyles.heading1(
            context,
            overrideStyle: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(context, 14),
            ),
          ),
        ),
        actions: [
          // Dropdown for Status Filter
          DropdownButton<String>(
            value: selectedStatus,
            underline: Container(),
            // Remove default underline
            icon: const Icon(Icons.filter_list, color: AppColors.white),
            // Filter icon for status
            items:
            ['All', 'present', 'Absent'].map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(
                  status,
                  style: AppTextStyles.heading1(
                    context,
                    overrideStyle: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.fontSize(context, 12),
                    ),
                  ), // Text color for dropdown items
                ),
              );
            }).toList(),
            onChanged: (val) => setState(() => selectedStatus = val!),
            dropdownColor:
            AppColors.primary, // Background color of the dropdown menu
          ),
          // Dropdown for Date Filter
          // DropdownButton<String>(
          //   value: selectedDate,
          //   underline: Container(), // Remove default underline
          //   icon: const Icon(Icons.calendar_today, color: AppColors.white), // Calendar icon for date
          //   items: allDates.map((d) => DropdownMenuItem(
          //     value: d,
          //     child: Text(
          //       d,
          //       style: const TextStyle(color: AppColors.black), // Text color for dropdown items
          //     ),
          //   )).toList(),
          //   onChanged: (val) => setState(() => selectedDate = val!),
          //   dropdownColor: AppColors.white, // Background color of the dropdown menu
          // ),
          // Export to Excel Button
          IconButton(
            icon: const Icon(Icons.file_download, color: AppColors.white),
            onPressed: () => exportToExcel(filteredData),
          ),
          // Export to PDF Button
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: AppColors.white),
            onPressed: () => exportToPDF(filteredData),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 0.0,
                ),
                // Reduced vertical padding
                child: TextField(
                  style: TextStyle(color: AppColors.black),
                  // Text color for input
                  decoration: InputDecoration(
                    hintText: 'Search by name/email/mobile',
                    hintStyle: TextStyle(
                      color: AppColors.black.withOpacity(0.6),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.black,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    // Background color of the search field
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                      BorderSide.none, // Remove border for a cleaner look
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ), // Highlight on focus
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ), // Reduced content padding
                  ),
                  onChanged: (val) => setState(() => searchQuery = val),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _pickStartDate,
                        style: OutlinedButton.styleFrom(
                          // backgroundColor: AppColors.white, // Still want white background
                          foregroundColor: AppColors.primary,
                          // Text color
                          side: const BorderSide(color: AppColors.white),
                          // Add a border with primary color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 1),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Start Date',
                              style: AppTextStyles.heading1(
                                context,
                                overrideStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    12,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${_formatDate(startDate)}',
                              style: AppTextStyles.heading1(
                                context,
                                overrideStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _pickEndDate,
                        style: OutlinedButton.styleFrom(
                          // backgroundColor: AppColors.white, // Still want white background
                          foregroundColor: AppColors.primary,
                          // Text color
                          side: const BorderSide(color: AppColors.white),
                          // Add a border with primary color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 1),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'End Date',
                              style: AppTextStyles.heading1(
                                context,
                                overrideStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    12,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '${_formatDate(endDate)}',
                              style: AppTextStyles.heading1(
                                context,
                                overrideStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: ResponsiveHelper.fontSize(
                                    context,
                                    12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.white),
                      tooltip: 'Clear Date Filters',
                      onPressed: _clearDateFilters,
                    ),
                  ],
                ),
              ),

              // const SizedBox(height: 5),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 15),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              dataRowColor: MaterialStateProperty.resolveWith<Color?>((
                  Set<MaterialState> states,
                  ) {
                if (states.contains(MaterialState.selected)) {
                  return Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.08);
                }
                // No need to calculate index here, as it's passed in the DataRow builder
                return null; // Let the DataRow's color property handle the alternating colors
              }),
              headingRowColor: MaterialStateProperty.resolveWith<Color?>((
                  Set<MaterialState> states,
                  ) {
                return Colors.black; // Header color
              }),
              columns: [
                DataColumn(
                  label: Text(
                    'S.No',
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Name',
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Email',
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Mobile',
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Date',
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'CheckIn',
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'CheckOut',
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Working Hrs',
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Over Time Hrs',
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                      ),
                    ),
                  ),
                ),
              ],
              rows: List.generate(filteredData.length, (i) {
                final item = filteredData[i];
                final bool isHighlighted =
                    searchQuery.isNotEmpty &&
                        (item.name.toLowerCase().contains(
                          searchQuery.toLowerCase(),
                        ) ||
                            item.email.toLowerCase().contains(
                              searchQuery.toLowerCase(),
                            ) ||
                            item.mobile.contains(searchQuery));

                Color statusColor;
                Color textColor;
                if (item.status == "Present") {
                  statusColor = Colors.green;
                  textColor = Colors.white;
                } else if (item.status == "Absent") {
                  statusColor = Colors.red;
                  textColor = Colors.white;
                } else {
                  statusColor = Colors.transparent; // No background color
                  textColor = Colors.black; // Default text color
                }
                return DataRow(
                  color: MaterialStateProperty.resolveWith<Color?>((
                      Set<MaterialState> states,
                      ) {
                    if (isHighlighted) {
                      return AppColors.primary.withOpacity(
                        0.1,
                      ); // Light background for highlighted rows
                    }
                    // Use the index 'i' to alternate row colors
                    if (i % 2 == 0) {
                      return Colors.grey[100]; // Light grey for even rows
                    }
                    return null; // Use default row color
                  }),
                  cells: [
                    DataCell(
                      Text(
                        '${i + 1}',
                        style: AppTextStyles.heading2(
                          context,
                          overrideStyle: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        item.name,
                        style: AppTextStyles.heading2(
                          context,
                          overrideStyle: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        item.email,
                        style: AppTextStyles.heading3(
                          context,
                          overrideStyle: TextStyle(
                            color: AppColors.txtGreyColor,
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        item.mobile,
                        style: AppTextStyles.heading3(
                          context,
                          overrideStyle: TextStyle(
                            color: AppColors.txtGreyColor,
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        item.date,
                        style: AppTextStyles.heading3(
                          context,
                          overrideStyle: TextStyle(
                            color: AppColors.txtGreyColor,
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        item.checkIn,
                        style: AppTextStyles.heading3(
                          context,
                          overrideStyle: TextStyle(
                            color: AppColors.txtGreyColor,
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        item.checkOut,
                        style: AppTextStyles.heading3(
                          context,
                          overrideStyle: TextStyle(
                            color: AppColors.txtGreyColor,
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        item.totalWorkingHours,
                        style: AppTextStyles.heading3(
                          context,
                          overrideStyle: TextStyle(
                            color: AppColors.txtGreyColor,
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        item.otTime,
                        style: AppTextStyles.heading3(
                          context,
                          overrideStyle: TextStyle(
                            color: AppColors.txtGreyColor,
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ),
                    ),
                    // DataCell(Text(item.status)),
                    DataCell(
                      Container(
                        color: statusColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        child: Text(
                          item.status,
                          style: AppTextStyles.heading2(
                            context,
                            overrideStyle: TextStyle(
                              color: textColor,
                              fontSize: ResponsiveHelper.fontSize(context, 12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// Ensure you have the AdminFilterAttendanceModel, Data, and Employee classes
// either in a separate file and imported, or defined directly here.
// For example, if it's in 'lib/path_to_your_models/admin_filter_attendance_model.dart':
// then the import at the top should be:
// import 'package:your_project_name/path_to_your_models/admin_filter_attendance_model.dart';
