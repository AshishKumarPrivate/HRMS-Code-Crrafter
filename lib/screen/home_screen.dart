import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ui_helper/app_text_styles.dart';
import '../ui_helper/theme/theme_provider.dart';
import 'nav_home/Info_card.dart';
import 'nav_home/punch_in_out_screen.dart';
import 'nav_home/widget/activity_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SafeArea(
      top: false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(
            top: 50,
            left: 15,
            right: 15,
            bottom: 10,
          ),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Morning, Ali Husni 🤟",
                            style: AppTextStyles.heading3(context),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "24 February 2023",
                            style: AppTextStyles.bodyText3(context),
                          ),
                        ],
                      ),
                      Switch(
                        value: isDark,
                        onChanged: (val) => themeProvider.toggleTheme(val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  PunchInOutScreen(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InfoCard(
                        title: 'Check In',
                        time: '08:30 am',
                        subtitle: 'On time',
                        points: '+150 pt',
                        icon: Icons.login,
                        color: Colors.green,
                      ),
                      InfoCard(
                        title: 'Check Out',
                        time: '05:10 pm',
                        subtitle: 'On time',
                        points: '+100 pt',
                        icon: Icons.logout,
                        color: Colors.pink,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      InfoCard(
                        title: 'Start Overtime',
                        time: '06:01 pm',
                        subtitle: 'Project revision from...',
                        points: '',
                        icon: Icons.alarm,
                        color: Colors.deepPurple,
                      ),
                      InfoCard(
                        title: 'Finish Overtime',
                        time: '11:10 pm',
                        subtitle: '5h 00m',
                        points: '+\$120.00',
                        icon: Icons.nightlight_round,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Recent Activity",
                    style: AppTextStyles.heading3(context),
                  ),
                  const SizedBox(height: 12),
                  const ActivityTile(
                    title: 'Check In',
                    date: '23 Feb 2023',
                    time: '09:15 am',
                    status: 'Late',
                    points: '+5 pt',
                    color: Colors.green,
                  ),
                  const ActivityTile(
                    title: 'Check Out',
                    date: '23 Feb 2023',
                    time: '05:02 pm',
                    status: 'Ontime',
                    points: '+100 pt',
                    color: Colors.pink,
                  ),
                  const ActivityTile(
                    title: 'Overtime',
                    date: '22 Feb 2023',
                    time: '06:01 - 10:59 pm',
                    status: '5h 30m',
                    points: '+\$120.00',
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
