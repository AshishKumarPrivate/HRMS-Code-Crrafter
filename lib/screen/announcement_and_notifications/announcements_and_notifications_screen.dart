import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/model/announcement_list_model.dart';
import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:provider/provider.dart';
import '../../admin/announcement/controller/announcement_api_provider.dart';
import '../../admin/announcement/widget/announcement_slider_widgets.dart';
 import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/app_text_styles.dart';
import '../../util/date_formate_util.dart';
import '../../util/responsive_helper_util.dart';

class AnnouncementAndNotificationScreen extends StatefulWidget {
  const AnnouncementAndNotificationScreen({super.key});

  @override
  State<AnnouncementAndNotificationScreen> createState() => _AnnouncementAndNotificationScreenState();
}

class _AnnouncementAndNotificationScreenState extends State<AnnouncementAndNotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white), // <-- Add this line
        title: Text(
          'Notification',
          style: AppTextStyles.heading1(context,overrideStyle: TextStyle(fontSize: 16,color: AppColors.white)),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.white,
          indicatorColor: AppColors.white,
          tabs: const [
            Tab(text: 'Announcement'),
            Tab(text: 'Notification'),
          ],
        ),
        backgroundColor: AppColors.primary,
        elevation: 1,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          /// Announcement Tab
          const AnnouncementListWidget(),

          /// Notification Tab Placeholder
          Center(
            child: Text(
              "🔔 No notifications yet.",
              style: AppTextStyles.bodyText1(
                context,
                overrideStyle: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnnouncementListWidget extends StatefulWidget {
  const AnnouncementListWidget({super.key});

  @override
  State<AnnouncementListWidget> createState() => _AnnouncementListWidgetState();
}

class _AnnouncementListWidgetState extends State<AnnouncementListWidget> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (!_isInitialized) {
      _isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _initAsync());
    }
  }

  Future<void> _initAsync() async {
    final provider = context.read<CompanyAnnouncementApiProvider>();
    await provider.getAllAnnouncementList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CompanyAnnouncementApiProvider>();
    final List<Data> announcements =
        provider.compAnnouncementListModel?.data ?? [];

    if (provider.isLoading && announcements.isEmpty) {
      return loadingIndicator();
    }

    if (!provider.isLoading && announcements.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "📭 No announcements available right now.",
          style: AppTextStyles.bodyText2(
            context,
            overrideStyle: TextStyle(
              fontSize: ResponsiveHelper.fontSize(context, 12),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: announcements.length,
      itemBuilder: (context, index) {
        return AnnouncementCard(announcement: announcements[index]);
      },
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final Data announcement;

  const AnnouncementCard({
    Key? key,
    required this.announcement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F7FA), Color(0xFFE8F5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Published On: ${DateFormatter.formatToShortMonth(announcement.createdAt?.split("T").first ?? "N/A")}",
              style: AppTextStyles.heading2(
                context,
                overrideStyle: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(context, 12),
                ),
              ),
            ),
            const Divider(height: 20, thickness: 1, color: Colors.grey),
            Text(
              announcement.message ?? "No message",
              style: AppTextStyles.bodyText1(
                context,
                overrideStyle: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(context, 13),
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
