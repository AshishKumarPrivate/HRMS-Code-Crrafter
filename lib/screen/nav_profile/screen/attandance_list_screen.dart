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

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late int currentYear;
  late int currentMonth;
  List<AttendanceData> data = [];
  bool isLoading = true;

  late String employeeId; // Replace with actual ID

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    currentYear = now.year;
    currentMonth = now.month;
    _fetchAndGenerateData();
  }

  Future<void> _fetchAndGenerateData() async {
    employeeId = await StorageHelper().getEmpLoginId();
    setState(() => isLoading = true);

    try {
      // Use provider to fetch data
      await Provider.of<PunchInOutProvider>(
        context,
        listen: false,
      ).empMonthlyAttendanceHistory(
        context,
        currentMonth.toString().padLeft(2, '0'),
        currentYear.toString(),
      );

      final provider = Provider.of<PunchInOutProvider>(context, listen: false);
      final responseData = provider.empMonthlyAttendanceModel?.data ?? [];

      // Parse response to AttendanceData
      final List<AttendanceData> actualData =
          responseData.map<AttendanceData>((item) {
            final dateTime = DateTime.parse(item.date ?? '');
            final loginTime =
                item.loginTime != null
                    ? DateTime.tryParse(item.loginTime!)
                    : null;
            final logoutTime =
                item.logoutTime != null
                    ? DateTime.tryParse(item.logoutTime!)
                    : null;

            return AttendanceData(
              date: dateTime.day.toString(),
              day: DateFormat('EEE').format(dateTime).toUpperCase(),
              loginTime:
                  loginTime != null
                      ? DateFormat('hh:mm a').format(loginTime)
                      : '-',
              logOutTime:
                  logoutTime != null
                      ? DateFormat('hh:mm a').format(logoutTime)
                      : '-',
              workingHours: item.workingHours ?? '-',
              status: item.status ?? '',
              isFullDay: item.isFullDay ?? false,
              isHalfDay: item.isFullDay ?? false,
              isCheckIN: item.isFullDay ?? false,
            );
          }).toList();

      final fullData = generateMonthlyAttendanceList(
        currentYear,
        currentMonth,
        actualData,
      );

      setState(() {
        data = fullData;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() => isLoading = false);
  }

  Future<List<AttendanceData>> fetchAttendanceData(int year, int month) async {
    // Repository().baseUrl.toString();
    try {
      final response = await http.post(
        Uri.parse(Repository().baseUrl.toString()),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "employeeId": employeeId,
          "month": month.toString().padLeft(2, '0'),
          "year": year.toString(),
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> list = json['data'] ?? [];

        return list.map((item) {
          final dateTime = DateTime.parse(item['date']);
          final loginTime =
              item['loginTime'] != null
                  ? DateTime.parse(item['loginTime'])
                  : null;
          final logoutTime =
              item['logoutTime'] != null
                  ? DateTime.parse(item['logoutTime'])
                  : null;

          return AttendanceData(
            date: dateTime.day.toString(),
            day: DateFormat('EEE').format(dateTime).toUpperCase(),
            loginTime:
                loginTime != null
                    ? DateFormat('hh:mm a').format(loginTime)
                    : '-',
            logOutTime:
                logoutTime != null
                    ? DateFormat('hh:mm a').format(logoutTime)
                    : '-',
            workingHours: item['workingHours'] ?? '-',
            status: item['status'] ?? '',
          );
        }).toList();
      } else {
        throw Exception("Failed to fetch data");
      }
    } catch (e) {
      rethrow;
    }
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
        (item) => item.date == date && item.day == day,
        orElse: () {
          if (day == "SUN") {
            return AttendanceData(
              date: date,
              day: day,
              weakOffStatus: "Week Off",
            );
          }
          return AttendanceData(date: date, day: day);
        },
      );

      fullList.add(match);
    }

    return fullList;
  }

  Widget buildAttendanceDotWithText(String type) {
    Color color;
    String label;

    switch (type.toLowerCase()) {
      case "full_day":
        color = Colors.red; // Light Blue
        label = "Full Day Leave";
        break;
      case "first_half":
        color =  Colors.amberAccent; // Light Yellow
        label = "Half Day";
        break;
      case "second_half":
        color = const Color(0xFFFFCCBC); // Light Orange
        label = "Second Half Day";
        break;
      default:
        color = Colors.grey;
        label = "Unknown";
    }

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

  Widget _buildMonthSelector(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
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
              Text(title, style: AppTextStyles.heading3(context)),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
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
          Row(
            children: [
              buildAttendanceDotWithText("full_day"),
              const SizedBox(height: 6),
              buildAttendanceDotWithText("first_half"),
              const SizedBox(height: 6),
              // buildAttendanceDotWithText("second_half"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTile(AttendanceData attendance) {
    Color tileColor = Colors.white;
    String? centerText;

    if (attendance.weakOffStatus == "Week Off") {
      tileColor = Colors.red.shade100;
      centerText = "Week Off";
    } else if (attendance.status == "absent") {
      tileColor = Colors.red;
      centerText = "On Leave";
    } else if (attendance.isCheckIN == true) {
      // tileColor = Colors.blue.shade50;
      // centerText = "Full Day Leave";
      if (attendance.isHalfDay == true && attendance.isFullDay == false) {
        tileColor = Colors.orange.shade100;
        centerText = "Half Day";
      } else if ((attendance.isFullDay == true &&
              attendance.isHalfDay == true) ||
          (attendance.isFullDay == true && attendance.isHalfDay == false)) {
        // tileColor = Colors.green.shade100;
        centerText = null; // show full data below
      } else {
        tileColor = Colors.grey.shade200;
        centerText = "Present";
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  attendance.date,
                  style: AppTextStyles.heading3(
                    context,
                    overrideStyle: const TextStyle(color: AppColors.primary),
                  ),
                ),
                Text(
                  attendance.day,
                  style: AppTextStyles.heading3(
                    context,
                    overrideStyle: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (centerText != null)
            Expanded(
              child: Center(
                child: Text(centerText, style: AppTextStyles.heading3(context)),
              ),
            )
          else
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendance.loginTime ?? '-',
                        style: AppTextStyles.heading3(
                          context,
                          overrideStyle: const TextStyle(
                            height: 1.5,
                            letterSpacing: 1,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text("Check In", style: AppTextStyles.caption(context,overrideStyle: TextStyle(fontSize: 11))),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendance.logOutTime ?? '-',
                        style: AppTextStyles.heading3(
                          context,
                          overrideStyle: const TextStyle(
                            height: 1.5,
                            letterSpacing: 1,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text("Check Out", style: AppTextStyles.caption(context,overrideStyle: TextStyle(fontSize: 11))),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendance.workingHours ?? '-',
                        style: AppTextStyles.heading3(
                          context,
                          overrideStyle: const TextStyle(
                            height: 1.5,
                            letterSpacing: 1,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text("Total Hrs", style: AppTextStyles.caption(context,overrideStyle: TextStyle(fontSize: 11))),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
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
    String monthYearTitle = DateFormat(
      'MMMM yyyy',
    ).format(DateTime(currentYear, currentMonth));

    return Scaffold(
      appBar: const DefaultCommonAppBar(
        activityName: "Attendance",
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          _buildMonthSelector(monthYearTitle),
          const Divider(),
          Expanded(
            child:
                isLoading
                    ? loadingIndicator()
                    : ListView.builder(
                      itemCount: data.length,
                      itemBuilder:
                          (context, index) => _buildAttendanceTile(data[index]),
                    ),
          ),
        ],
      ),
    );
  }
}

class AttendanceData {
  final String date;
  final String day;
  final String? loginTime;
  final String? logOutTime;
  final String? workingHours;
  final String? weakOffStatus;
  final String? status;
  final bool? isFullDay;
  final bool? isHalfDay;
  final bool? isCheckIN;

  AttendanceData({
    required this.date,
    required this.day,
    this.loginTime,
    this.logOutTime,
    this.workingHours,
    this.weakOffStatus,
    this.status,
    this.isFullDay,
    this.isHalfDay,
    this.isCheckIN,
  });
}
