import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:provider/provider.dart';
import '../../../../util/storage_util.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../util/responsive_helper_util.dart';
import '../controller/emp_attendance_chart_provider.dart';
import '../model/emp_chart_attendance_model.dart'; // Ensure this path is correct for StatusData

class AttendanceChartWidget extends StatefulWidget {
  const AttendanceChartWidget({super.key});

  @override
  State<AttendanceChartWidget> createState() => _AttendanceChartWidgetState();
}

class _AttendanceChartWidgetState extends State<AttendanceChartWidget> {
  late DateTime now;
  String? employeeId;
  late int currentYear;
  late int currentMonth;
  late String yearMonth;
  List<double?> _barValues = []; // State variable for bar values

  @override
  void initState() {
    super.initState();
    loadEmployeeId();
  }

  Future<void> loadEmployeeId() async {
    employeeId = await StorageHelper().getEmpLoginId();

    now = DateTime.now();
    currentYear = now.year;
    currentMonth = now.month;
    yearMonth = "${currentYear.toString()}-${currentMonth.toString().padLeft(2, '0')}";
    if (employeeId != null) {
      Provider.of<AttendanceChartProvider>(context, listen: false)
          .fetchAttendanceChart(employeeId: employeeId!, month: yearMonth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceChartProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return loadingIndicator();
        }

        if (provider.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              provider.errorMessage,
              style: AppTextStyles.heading2(
                context,
                overrideStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.fontSize(context, 12),
                ),
              ),
            ),
          );
        }

        final chart = provider.chartModel?.chart ?? [];

        // Initialize _barValues with 0.0 based on chart length
        // This ensures the animation starts from the bottom
        if (_barValues.length != chart.length) {
          _barValues = List.generate(chart.length, (_) => 0.0);
          // Trigger animation after the initial build and data is loaded
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _barValues = List.generate(chart.length, (index) {
                  final item = chart.elementAt(index);
                  double yValue = 0;
                  if (item.status is String && item.status == "Not Available") {
                    yValue = 0;
                  } else if (item.status is StatusData) {
                    final status = item.status as StatusData;
                    if (status.isFullDay == true) {
                      yValue = 3;
                    } else if (status.isHalfDay == true) {
                      yValue = 2;
                    } else {
                      yValue = 1;
                    }
                  }
                  return yValue;
                });
              });
            }
          });
        }


        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Attendance Chart",
                style: AppTextStyles.heading1(
                  context,
                  overrideStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.fontSize(context, 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Legend for colors
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: const [
                  LegendItem(color: Colors.green, label: 'Present'),
                  LegendItem(color: Colors.orange, label: 'Half Day'),
                  LegendItem(color: Colors.red, label: 'Absent'),
                  LegendItem(color: Colors.grey, label: 'Not Available'),
                ],
              ),
              const SizedBox(height: 16),

              // Horizontally scrollable bar chart
              SizedBox(
                height: 260, // Increased height to prevent cutting
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: chart.length * 25, // Dynamic width based on number of days and new bar width
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.center,
                          maxY: 3.0, // Ensures enough space above the highest bar
                          minY: 0,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchCallback: (event, response) {
                              if (!event.isInterestedForInteractions || response == null || response.spot == null) {
                                return;
                              }
                              // You can add logic here to show details on tap if needed
                            },
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1, // Show titles for every integer value
                                getTitlesWidget: (value, meta) {
                                  // Display numerical values on the left axis
                                  return Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                  );
                                },
                                reservedSize: 28, // Give some space for the titles
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, _) {
                                  final index = value.toInt();
                                  if (index >= 0 && index < chart.length) {
                                    final date = chart.elementAt(index).date.split("-").last;
                                    return Text(date, style: const TextStyle(fontSize: 10));
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 10, // Added reserved space at the top
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(chart.length, (index) {
                            final item = chart.elementAt(index);
                            double yValue = 0;

                            if (item.status is String && item.status == "Not Available") {
                              yValue = 0;
                            } else if (item.status is StatusData) {
                              final status = item.status as StatusData;
                              if (status.isFullDay == true) {
                                yValue = 3;
                              } else if (status.isHalfDay == true) {
                                yValue = 2;
                              } else {
                                yValue = 1;
                              }
                            }

                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  // Bind to the state variable for animation
                                  toY: _barValues.isNotEmpty && index < _barValues.length ? _barValues.elementAt(index) ?? 0 : 0,
                                  color: yValue == 3
                                      ? Colors.green
                                      : yValue == 2
                                      ? Colors.orange
                                      : yValue == 1
                                      ? Colors.red
                                      : Colors.grey, // Color for 'Not Available' (yValue 0)
                                  width: 16, // Increased bar width
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Legend item widget (no changes needed here)
class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({required this.color, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.heading2(
            context,
            overrideStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.fontSize(context, 10),
            ),
          ),
        ),
      ],
    );
  }
}