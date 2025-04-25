import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:animated_background/animated_background.dart';

import '../../ui_helper/app_colors.dart';
import 'controller/punch_in_out_provider.dart';

class PunchInOutScreen extends StatefulWidget {

  @override
  State<PunchInOutScreen> createState() => _PunchInOutScreenState();
}

class _PunchInOutScreenState extends State<PunchInOutScreen> with TickerProviderStateMixin {
  String currentTime = "";

  @override
  void initState() {
    super.initState();
    _startClock();
    Future.microtask(() {
      Provider.of<PunchInOutProvider>(context, listen: false).loadPunchData();
    });
  }

  void _startClock() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        currentTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "PM" : "AM"}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final provider = Provider.of<PunchInOutProvider>(context);
    final formattedDate =
        "${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year} - ${["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"][now.weekday % 7]}";

    return Container(
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(
            currentTime,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            formattedDate,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          SizedBox(height: 40),
          Stack(
            alignment: Alignment.center,
            children: [
              // 🔵 Animated Background using animated_background package
              SizedBox(
                width: double.infinity,
                height: 220,
                child: AnimatedBackground(
                  behaviour: RandomParticleBehaviour(
                    options: ParticleOptions(
                      baseColor: Colors.orange.withAlpha(300),
                      spawnOpacity: 0.0,
                      opacityChangeRate: 0.25,
                      minOpacity: 0.1,
                      maxOpacity: 0.2,
                      spawnMinSpeed: 10.0,
                      spawnMaxSpeed: 10.0,
                      spawnMinRadius: 5.0,
                      spawnMaxRadius: 10.0,
                      particleCount: 15,
                    ),
                  ),
                  vsync: this, // Required for animation
                  child: const SizedBox(),
                ),
              ),

              // 🟠 Circular progress indicator on top
              CircularPercentIndicator(
                radius: 100.0,
                lineWidth: 10.0,
                percent: provider.progress,
                animation: false,
                circularStrokeCap: CircularStrokeCap.round,
                center: GestureDetector(
                  onTap: () {
                    provider.isPunchedIn ? provider.punchOut() : provider.punchIn();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fingerprint, size: 40, color: Colors.green),
                      SizedBox(height: 8),
                      Text(
                        provider.isPunchedIn ? "PUNCH OUT" : "PUNCH IN",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                progressColor: Colors.orange,
                backgroundColor: AppColors.txtGreyColor.withAlpha(60),
              ),
            ],
          ),

          SizedBox(height: 16),
          if (provider.halfDayReached)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Minimum half day time reached",
                style: TextStyle(color: Colors.orange[800], fontSize: 12),
              ),
            ),
          SizedBox(height: 40),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPunchTile(
                  provider.punchInTime != null
                      ? formatTime(provider.punchInTime!)
                      : "--:--",
                  "Punch In",
                ),
                _buildPunchTile(
                  provider.punchOutTime != null
                      ? formatTime(provider.punchOutTime!)
                      : "--:--",
                  "Punch Out",
                ),
                _buildPunchTile(provider.getTotalHours(), "Total Hours"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPunchTile(String time, String label) {
    return Column(
      children: [
        Icon(Icons.access_time, color: Colors.red),
        SizedBox(height: 4),
        Text(time, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  String formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final suffix = dt.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $suffix";
  }
}
