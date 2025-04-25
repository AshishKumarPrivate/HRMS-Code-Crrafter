import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/screen/nav_profile/widget/cell_profile_list_tile.dart';

import '../../ui_helper/app_text_styles.dart';
import 'attandance_list_screen.dart';

class ProfileScreen extends StatelessWidget {

  final List<ProfileOption> options = [
    ProfileOption(
      "Attendance",
      "Check your attendance details",
      Icons.access_time,
    ),
    ProfileOption("MIS", "Check your daily MIS log", Icons.assignment),
    ProfileOption("Leave", "Check your Leave Request Status", Icons.event_busy),
    ProfileOption(
      "Holiday List",
      "Download your Holiday List",
      Icons.calendar_today,
    ),
    ProfileOption(
      "Expense List",
      "Check your Expense History and Status",
      Icons.receipt_long,
    ),
    ProfileOption("Meeting", "Check your Meeting History", Icons.video_call),
    ProfileOption("Logbook", "Check your Logbook History", Icons.book),
    ProfileOption("Overtime", "Check your Expense Status", Icons.access_alarm),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context),
              const SizedBox(height: 16),
              ProfileListTile(
                title: "Attendance",
                subtitle: "Check your attendance details",
                leadingIcon: Icons.access_time,
                backgroundColor: Colors.white,
                borderRadius: 16,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AttendanceScreen()),
                  );
                },
                titleStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              ProfileListTile(
                title: "Leave",
                subtitle: "Check your Leave Request Status",
                leadingIcon: Icons.event_busy,
                backgroundColor: Colors.white,
                borderRadius: 16,
                onTap: () {
                  // TODO: Add navigation for each item here
                },
                titleStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              ProfileListTile(
                title: "Holiday List",
                subtitle: "Download your Holiday List",
                leadingIcon: Icons.event_busy,
                backgroundColor: Colors.white,
                borderRadius: 16,
                onTap: () {
                  // TODO: Add navigation for each item here
                },
                titleStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              ProfileListTile(
                title: "Expense List",
                subtitle: "Check your Expense History and Status",
                leadingIcon: Icons.event_busy,
                backgroundColor: Colors.white,
                borderRadius: 16,
                onTap: () {
                  // TODO: Add navigation for each item here
                },
                titleStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueGrey,
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Vikram Singh", style: AppTextStyles.heading3(context)),
              Text("2310011", style: AppTextStyles.caption(context)),
              Text(
                "Technology | UI/UX Designer",
                style: AppTextStyles.caption(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

class ProfileOption {

  // list style for the card design for product profile liset
  final String title;
  final String subtitle;
  final IconData icon;

  ProfileOption(this.title, this.subtitle, this.icon);
}
