import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:provider/provider.dart';
import '../../../../util/storage_util.dart';
import '../controller/emp_attendance_chart_provider.dart';
import '../model/emp_chart_attendance_model.dart';

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
          return Center(child: Text(provider.errorMessage));
        }

        final chart = provider.chartModel?.chart ?? [];

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Attendance Chart",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                height: 300,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: chart.length * 20, // Dynamic width based on number of days
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.center,
                        maxY: 3,
                        minY: 0,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, _) {
                                switch (value.toInt()) {
                                  case 1:
                                    return const Text('Absent');
                                  case 2:
                                    return const Text('Half Day');
                                  case 3:
                                    return const Text('Present');
                                  default:
                                    return const Text('');
                                }
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                final index = value.toInt();
                                if (index >= 0 && index < chart.length) {
                                  final date = chart[index].date.split("-").last;
                                  return Text(date, style: const TextStyle(fontSize: 10));
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(chart.length, (index) {
                          final item = chart[index];
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
                                toY: yValue,
                                color: yValue == 3
                                    ? Colors.green
                                    : yValue == 2
                                    ? Colors.orange
                                    : yValue == 1
                                    ? Colors.red
                                    : Colors.grey,
                                width: 12,
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
            ],
          ),
        );
      },
    );
  }
}

// Legend item widget
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
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
