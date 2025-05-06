import 'package:flutter/material.dart';

class EmployeeWorkDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> workData;

  const EmployeeWorkDetailsScreen({Key? key, required this.workData}) : super(key: key);

  String formatDate(String date) {
    final parsedDate = DateTime.tryParse(date);
    if (parsedDate == null) return date;
    return "${parsedDate.day.toString().padLeft(2, '0')}-"
        "${parsedDate.month.toString().padLeft(2, '0')}-"
        "${parsedDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Work Details"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetail("Company", workData["company"]),
                _buildDetail("Department", workData["department"]),
                _buildDetail("Job Position", workData["jobPosition"]),
                _buildDetail("Joining Date", formatDate(workData["joiningDate"])),
                _buildDetail("Salary", "₹${workData["salary"]}"),
                _buildDetail("Work Location", workData["workLocation"]),
                _buildDetail("Work Type", workData["workType"]),
                const SizedBox(height: 20),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Last Updated: ${formatDate(workData["updatedAt"])}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$title:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value ?? "N/A",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
