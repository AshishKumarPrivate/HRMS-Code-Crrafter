import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms_management_code_crafter/network_manager/repository.dart';
import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/common_widget/default_common_app_bar.dart';
import '../../../util/responsive_helper_util.dart';
import '../../nav_home/controller/punch_in_out_provider.dart';

// Define an enum for clearer attendance status
enum AttendanceStatus { present, absent, leave, weekOff, halfDay, unknown }

class CalendarAttendanceScreen extends StatefulWidget {
  final String employeeId;

  const CalendarAttendanceScreen({Key? key, required this.employeeId}) : super(key: key);

  @override
  State<CalendarAttendanceScreen> createState() => _CalendarAttendanceScreenState();
}

class _CalendarAttendanceScreenState extends State<CalendarAttendanceScreen> {
  late int currentYear;
  late int currentMonth;
  List<AttendanceData> data = [];
  bool isLoading = true;
  // State variable to hold the selected day's attendance data
  AttendanceData? _selectedAttendanceData;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    currentYear = now.year;
    currentMonth = now.month;
    // Defer the call until after the current frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAndGenerateData();
    });
  }

  // Helper function to convert UTC DateTime to IST formatted string
  String _formatISTTime(DateTime utcTime) {
    final istTime = utcTime.toUtc().add(const Duration(hours: 5, minutes: 30));
    return DateFormat('hh:mm a').format(istTime);
  }

  Future<void> _fetchAndGenerateData() async {
    setState(() => isLoading = true);

    try {
      // Use provider to fetch data
      await Provider.of<PunchInOutProvider>(
        context,
        listen: false,
      ).empMonthlyAttendanceHistory(
        context,
        widget.employeeId,
        currentMonth.toString().padLeft(2, '0'),
        currentYear.toString(),
      );

      final provider = Provider.of<PunchInOutProvider>(context, listen: false);
      final responseData = provider.empMonthlyAttendanceModel?.data ?? [];

      // Parse response to AttendanceData
      final List<AttendanceData> actualData = responseData.map<AttendanceData>((item) {
        final dateTime = DateTime.parse(item.date ?? '');
        final loginTime = item.loginTime != null ? DateTime.parse(item.loginTime!) : null;
        final logoutTime = item.logoutTime != null ? DateTime.parse(item.logoutTime!) : null;

        AttendanceStatus status;
        if (item.leave == true) {
          // On leave regardless of check-in
          status = AttendanceStatus.leave;
        } else if (item.checkIn == false) {
          // Not on leave and didn't check in
          status = AttendanceStatus.absent;
        } else if (item.isHalfDay == true) {
          // Checked in late
          status = AttendanceStatus.halfDay;
        } else if (item.isFullDay == true && item.checkIn == true) {
          // Checked in before 11:00 AM
          status = AttendanceStatus.present;
        } else if (item.status =="present") {
          // Checked in before 11:00 AM
          status = AttendanceStatus.present;
        } else if (item.status != null) {
          final String apiStatus = item.status!.toLowerCase();
          if (apiStatus == "present" || (item.checkIn == true)) {
            status = AttendanceStatus.present;
          } else if (apiStatus == "absent" || item.checkIn == false) {
            status = AttendanceStatus.absent;
          } else if (apiStatus == "leave" || item.leave == true) {
            status = AttendanceStatus.leave;
          } else {
            status = AttendanceStatus.unknown;
          }
        }
        // else if ((item.status?.toLowerCase().contains('leave') ?? false)) {
        //   // Fallback to leave if string contains it
        //   status = AttendanceStatus.leave;
        // }
        else {
          status = AttendanceStatus.unknown;
        }
        // if (item.checkIn == false) {
        //   status = AttendanceStatus.absent;
        // } else if (item.leave == true) { // Assuming isHalfDay covers both halves for simplicity
        //   status = AttendanceStatus.leave;
        // }else if (item.isHalfDay == true) { // Assuming isHalfDay covers both halves for simplicity
        //   status = AttendanceStatus.halfDay;
        // } else if (item.isFullDay == true && item.checkIn == false) {
        //   status = AttendanceStatus.present;
        // } else if (item.status?.toLowerCase().contains('leave') == true) { // Check for "leave" in status
        //   status = AttendanceStatus.leave;
        // }
        // else {
        //   status = AttendanceStatus.unknown;
        // }


        return AttendanceData(
          date: dateTime.day.toString(),
          day: DateFormat('EEE').format(dateTime).toUpperCase(),
          loginTime: loginTime != null ? _formatISTTime(loginTime) : '-',
          logOutTime: logoutTime != null ? _formatISTTime(logoutTime) : '-',
          workingHours: item.workingHours ?? '-',
          status: status, // Use the new enum
          isFullDay: item.isFullDay ?? false,
          isHalfDay: item.isHalfDay ?? false,
          isCheckIN: item.checkIn ?? false,
        );
      }).toList();

      final fullData = generateMonthlyAttendanceList(
        currentYear,
        currentMonth,
        actualData,
      );

      setState(() {
        data = fullData;
        // Reset selected data when month changes
        _selectedAttendanceData = null;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() => isLoading = false);
  }

  List<AttendanceData> generateMonthlyAttendanceList(
      int year,
      int month,
      List<AttendanceData> actualData,
      ) {
    List<AttendanceData> fullList = [];
    int totalDays = DateUtils.getDaysInMonth(year, month);

    for (int i = 1; i <= totalDays; i++) {
      DateTime currentDate = DateTime(year, month, i);
      String date = i.toString();
      String day = DateFormat('EEE').format(currentDate).toUpperCase();

      AttendanceData? match = actualData.firstWhere(
            (item) => item.date == date,
        orElse: () {
          if (day == "SUN") {
            return AttendanceData(
              date: date,
              day: day,
              status: AttendanceStatus.weekOff,
            );
          }
          return AttendanceData(date: date, day: day, status: AttendanceStatus.unknown);
        },
      );

      // If a match is found for the date, add it. Otherwise, add the default (Week Off or Unknown)
      if (match.date == date) {
        fullList.add(match);
      } else {
        if (day == "SUN") {
          fullList.add(AttendanceData(date: date, day: day, status: AttendanceStatus.weekOff));
        } else {
          fullList.add(AttendanceData(date: date, day: day, status: AttendanceStatus.unknown));
        }
      }
    }
    return fullList;
  }

  Widget _buildMonthSelector(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      child: Container(
        color: AppColors.primary,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (currentMonth == 1) {
                      currentMonth = 12;
                      currentYear--;
                    } else {
                      currentMonth--;
                    }
                    _fetchAndGenerateData();
                  },
                ),
                Text(title, style: AppTextStyles.heading3(context,overrideStyle: TextStyle(color: Colors.white))),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () {
                    if (currentMonth == 12) {
                      currentMonth = 1;
                      currentYear++;
                    } else {
                      currentMonth++;
                    }
                    _fetchAndGenerateData();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCellBackgroundColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Colors.green.shade100; // Light green for present
      case AttendanceStatus.absent:
        return Colors.red.shade100; // Light red for absent
      case AttendanceStatus.leave:
        return Colors.yellow.shade100; // Light yellow for leave
      case AttendanceStatus.weekOff:
        return Colors.grey.shade200; // Grey for week off
      case AttendanceStatus.halfDay: // Half day can be present but with specific color
        return Colors.orange.shade100;
      case AttendanceStatus.unknown:
      default:
        return Colors.white; // Default for no data or unknown
    }
  }

  Color _getCellTextColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.absent:
      case AttendanceStatus.weekOff:
      case AttendanceStatus.leave:
        return Colors.red; // Red for absent/weekoff/leave
      case AttendanceStatus.present:
      case AttendanceStatus.halfDay:
        return Colors.black; // Black for present/halfday
      case AttendanceStatus.unknown:
      default:
        return Colors.grey;
    }
  }

  Widget _buildCalendarLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.bodyText1(
            context,
            overrideStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.fontSize(context, 10),
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String monthYearTitle = DateFormat('MMMM yyyy').format(DateTime(currentYear, currentMonth));

    final DateTime firstDayOfMonth = DateTime(currentYear, currentMonth, 1);
    final int daysInMonth = DateUtils.getDaysInMonth(currentYear, currentMonth);
    // Adjust firstWeekday to be 0 for Sunday, 1 for Monday... 6 for Saturday
    // final int firstWeekday = firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;
    final int firstWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0, Monday = 1, ..., Saturday = 6

    List<Widget> dayWidgets = [];

    // Add empty cells for days before the 1st of the month
    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Add day cells for each day of the month
    for (int i = 1; i <= daysInMonth; i++) {
      final String dateString = i.toString();
      final AttendanceData? dayAttendance = data.firstWhere(
            (dataItem) => dataItem.date == dateString,
        orElse: () => AttendanceData(date: dateString, day: '', status: AttendanceStatus.unknown),
      );
      // Determine if this date is currently selected
      bool isSelected = _selectedAttendanceData != null && _selectedAttendanceData!.date == dateString;

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedAttendanceData = dayAttendance;
            });
            // Optionally, handle tap on a calendar day
            print('Tapped on ${dayAttendance.date} - Status: ${dayAttendance.status}');
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _getCellBackgroundColor(dayAttendance!.status),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (DateTime.now().day == int.parse(dateString) &&
                    DateTime.now().month == currentMonth &&
                    DateTime.now().year == currentYear)
                    ? AppColors.primary // Today's date
                    : Colors.grey.shade300,
                width: isSelected ? 2.0 : 1.0,
              ),

              // border:  isSelected
              //     ? Border.all(color: AppColors.primary, width: 2.0) // Highlight with blue border if selected
              //     : Border.all(color: Colors.grey.shade300), // Default border
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dateString,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getCellTextColor(dayAttendance.status),
                    fontSize: ResponsiveHelper.fontSize(context, 14),
                  ),
                ),
                // if (dayAttendance.status == AttendanceStatus.absent ||
                //     dayAttendance.status == AttendanceStatus.leave)
                //   Text(
                //     'X',
                //     style: TextStyle(
                //       color: Colors.red,
                //       fontWeight: FontWeight.bold,
                //       fontSize: ResponsiveHelper.fontSize(context, 16),
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const DefaultCommonAppBar(
        activityName: "Monthly Attendance", // Adjusted title as per image
        backgroundColor: AppColors.primary,
      ),
      body: isLoading
          ? loadingIndicator()
          : SingleChildScrollView(
            child: Column(
                    children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMonthSelector(monthYearTitle),
                    const SizedBox(height: 10),
                    // Day Headers (S, M, T, W, T, F, S) - Corrected order
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("S", style: AppTextStyles.caption(context, overrideStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red))), // Sunday in red
                          Text("M", style: AppTextStyles.caption(context, overrideStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                          Text("T", style: AppTextStyles.caption(context, overrideStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                          Text("W", style: AppTextStyles.caption(context, overrideStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                          Text("T", style: AppTextStyles.caption(context, overrideStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                          Text("F", style: AppTextStyles.caption(context, overrideStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                          Text("S", style: AppTextStyles.caption(context, overrideStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                        ],
                      ),
                    ),
                    const Divider(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1.0, // Make cells square
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: dayWidgets.length,
                      itemBuilder: (context, index) {
                        return dayWidgets[index];
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildCalendarLegend("Present", Colors.green.shade100),
                        _buildCalendarLegend("Absent", Colors.red.shade100),
                        _buildCalendarLegend("Half Day", Colors.yellow.shade100),
                      ],
                    ),
                    // New section to display selected day's data
                    if (_selectedAttendanceData != null) ...[
                      const Divider(height: 20, thickness: 1),
                      Text(
                        'Details for ${_selectedAttendanceData!.day}, ${_selectedAttendanceData!.date} ${DateFormat('MMMM ').format(DateTime(currentYear, currentMonth))}',
                        style: AppTextStyles.heading3(context, overrideStyle: const TextStyle(fontWeight: FontWeight.bold)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      _buildDetailRow("Status:", _getStatusText(_selectedAttendanceData!.status), valueColor: _getCellTextColor(_selectedAttendanceData!.status)),
                      if (_selectedAttendanceData!.status == AttendanceStatus.present || _selectedAttendanceData!.status == AttendanceStatus.halfDay) ...[
                        _buildDetailRow("Login Time:", _selectedAttendanceData!.loginTime ?? 'N/A'),
                        _buildDetailRow("Logout Time:", _selectedAttendanceData!.logOutTime ?? 'N/A'),
                        _buildDetailRow("Working Hours:", _selectedAttendanceData!.workingHours ?? 'N/A'),
                      ],
                      if (_selectedAttendanceData!.isFullDay == true) _buildDetailRow("Is Full Day:", "Yes"),
                      if (_selectedAttendanceData!.isHalfDay == true) _buildDetailRow("Is Half Day:", "Yes"),
                      if (_selectedAttendanceData!.isCheckIN == true) _buildDetailRow("Checked In:", "Yes"),
                    ],
                  ],
                ),
              ),
            ),
            // You can add other widgets below the calendar if needed
                    ],
                  ),
          ),
    );
  }

  String _getStatusText(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return "Present";
      case AttendanceStatus.absent:
        return "Absent";
      case AttendanceStatus.leave:
        return "On Leave";
      case AttendanceStatus.weekOff:
        return "Week Off";
      case AttendanceStatus.halfDay:
        return "Half Day";
      case AttendanceStatus.unknown:
      default:
        return "Unknown";
    }
  }
  // Helper method to build a detail row for the display section
  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyText1(context, overrideStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
          ),
          Text(
            value,
            style: AppTextStyles.bodyText1(context, overrideStyle: TextStyle(color: valueColor ?? Colors.black,fontSize: 14)),
          ),
        ],
      ),
    );
  }
}


// Re-defining AttendanceData with enum for status for clarity
class AttendanceData {
  final String date;
  final String day;
  final String? loginTime;
  final String? logOutTime;
  final String? workingHours;
  final AttendanceStatus status;
  final bool? isFullDay;
  final bool? isHalfDay;
  final bool? isCheckIN;

  AttendanceData({
    required this.date,
    required this.day,
    this.loginTime,
    this.logOutTime,
    this.workingHours,
    this.status = AttendanceStatus.unknown, // Default to unknown
    this.isFullDay,
    this.isHalfDay,
    this.isCheckIN,
  });
}