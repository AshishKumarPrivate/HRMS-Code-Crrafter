import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/widget/address_tab_widget.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/widget/announcement_tab_widget.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/widget/company_profile_data_widgett.dart';
import 'package:hrms_management_code_crafter/admin/employee/screen/policy/policy_list_screen.dart';

import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/common_widget/default_common_app_bar.dart';
import '../widget/corporate_address_form_widget.dart';

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = const [
    "Overview",
    "Address",
    "Announcements",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultCommonAppBar(
        activityName: "View Company Profile",
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: AppColors.primary,
            child: TabBar(
              tabAlignment: TabAlignment.start,
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.white.withOpacity(0.7),
              indicatorColor: AppColors.white,
              indicatorWeight: 4.0,
              labelStyle: AppTextStyles.heading1(
                context,
                overrideStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              unselectedLabelStyle: AppTextStyles.heading1(
                context,
                overrideStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              tabs: _tabs.map((tabName) => Tab(text: tabName)).toList(),
            ),
          ),
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs.map((tabName) {
                // Return different widgets based on the tab name
                // Use a single if-else if-else or switch statement
                if (tabName == "Overview") {
                  return const CompanyProfileOverviewScreen();
                } else if (tabName == "Address") {
                  return const AddressTabContentWidget();
                }  else if (tabName == "Announcements") {
                  return const AnnouncementTabContentWidget();
                } else {
                  // Default content for tabs not yet implemented
                  return Center(
                    child: Text(
                      "$tabName Content (Coming Soon)",
                      style: AppTextStyles.bodyText1(context),
                    ),
                  );
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


