import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';
import '../../ui_helper/common_widget/default_common_app_bar.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late List<AttendanceData> data;
  late int currentYear;
  late int currentMonth;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    currentYear = now.year;
    currentMonth = now.month;
    _generateData();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor:AppColors.primary, // Default background
        statusBarIconBrightness: Brightness.light, // Dark icons for Android
        statusBarBrightness: Brightness.light, // Light text for iOS
      ),
    );
  }

  void _generateData() {
    final List<AttendanceData> actualData = [
      AttendanceData(
          date: "1",
          day: "TUE",
          checkIn: "09:00 AM",
          checkOut: "06:15 PM",
          workingHours: "09h 15m"),
      AttendanceData(date: "5", day: "SAT", status: "Week Off"),
      AttendanceData(date: "6", day: "SUN", status: "Week Off"),
      AttendanceData(date: "8", day: "TUE", status: "Sick Leave"),
    ];

    data = generateMonthlyAttendanceList(currentYear, currentMonth, actualData);
  }

  @override
  Widget build(BuildContext context) {
    String monthYearTitle = DateFormat('MMMM yyyy').format(DateTime(currentYear, currentMonth));

    return Scaffold(
      appBar: DefaultCommonAppBar(
        activityName: "Attendance",
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          _buildMonthSelector(monthYearTitle),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return _buildAttendanceTile(data[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                if (currentMonth == 1) {
                  currentMonth = 12;
                  currentYear--;
                } else {
                  currentMonth--;
                }
                _generateData();
              });
            },
          ),
          Text(
            title,
            style: AppTextStyles.heading3(context, overrideStyle: TextStyle()),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              setState(() {
                if (currentMonth == 12) {
                  currentMonth = 1;
                  currentYear++;
                } else {
                  currentMonth++;
                }
                _generateData();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTile(AttendanceData attendance) {
    Color tileColor = Colors.white;
    if (attendance.status == "Week Off") {
      tileColor = Colors.red.shade100;
    } else if (attendance.status == "Sick Leave") {
      tileColor = Colors.amber.shade200;
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
          // Date + Day
          Container(
            width: 40,
            padding: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  attendance.date,
                  style: AppTextStyles.heading3(context, overrideStyle: TextStyle(color: AppColors.primary)),
                ),
                Text(
                  attendance.day,
                  style: AppTextStyles.heading3(context, overrideStyle: TextStyle(fontSize: 12,color: AppColors.primary)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (attendance.status != null)
            Expanded(
              child: Center(
                child: Text(
                  attendance.status!,
                  style: AppTextStyles.heading3(context, overrideStyle: TextStyle()),
                ),
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
                        attendance.checkIn ?? '-',
                        style: AppTextStyles.heading3(
                          context,
                          overrideStyle: TextStyle(height: 1.5,fontSize: 14),
                        ),
                      ),
                        Text(
                          "Check In",
                          style: AppTextStyles.caption(context, overrideStyle: TextStyle()),
                        ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendance.checkIn ?? '-',
                        style: AppTextStyles.heading3(
                          context,
                          overrideStyle: TextStyle(height: 1.5,fontSize: 14),
                        ),
                      ),
                      Text(
                        "Check Out",
                        style: AppTextStyles.caption(context, overrideStyle: TextStyle()),
                      ),
                    ],
                  ),

                  // Working Hours
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendance.workingHours ?? '-',
                        style: AppTextStyles.heading3(
                          context,
                          overrideStyle: TextStyle(height: 1.5,fontSize: 14),
                        ),
                      ),
                      Text(
                        "Total Hrs",
                        style: AppTextStyles.caption(context, overrideStyle: TextStyle()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<AttendanceData> generateMonthlyAttendanceList(
      int year, int month, List<AttendanceData> actualData) {
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
            return AttendanceData(date: date, day: day, status: "Week Off");
          }
          return AttendanceData(date: date, day: day);
        },
      );

      fullList.add(match);
    }

    return fullList;
  }
}

class AttendanceData {
  final String date;
  final String day;
  final String? checkIn;
  final String? checkOut;
  final String? workingHours;
  final String? status;

  AttendanceData({
    required this.date,
    required this.day,
    this.checkIn,
    this.checkOut,
    this.workingHours,
    this.status,
  });
}
