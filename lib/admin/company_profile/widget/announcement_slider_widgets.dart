import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/model/announcement_list_model.dart';
import 'package:hrms_management_code_crafter/util/date_formate_util.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/app_text_styles.dart';
import '../../../../util/loading_indicator.dart';
import '../../../../util/responsive_helper_util.dart';
import '../controller/comp_profile_api_provider.dart';

class AnnouncementSliderWidget extends StatefulWidget {
  const AnnouncementSliderWidget({super.key});

  @override
  State<AnnouncementSliderWidget> createState() =>
      _AnnouncementSliderWidgetState();
}

class _AnnouncementSliderWidgetState extends State<AnnouncementSliderWidget> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  bool _hasFetched = false;
  bool _isInitialized = false;

  // @override
  // void initSState() {
  //   super.didChangeDependencies();
  //   if (!_isInitialized) {
  //     _isInitialized = true;
  //     Future.microtask(() => _initAsync());
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!_isInitialized) {
      _isInitialized = true;
      // Defer async logic till after first frame to avoid triggering build conflicts
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initAsync();
      });
    }
  }

  void _initAsync() async {
    final provider = context.read<CompanyProfileApiProvider>();

    await provider.getCompAnnouncementListData(context); // always fetch

    if (mounted) {
      _startAutoPlay(); // Start auto scroll after data loaded
    }
  }

  void _startAutoPlay() {
    _timer?.cancel(); // prevent multiple timers
    final announcements =
        context
            .read<CompanyProfileApiProvider>()
            .compAnnouncementListModel
            ?.data ??
        [];

    if (announcements.isEmpty) return;
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // final announcements = context.read<CompanyProfileApiProvider>().compAnnouncementListModel?.data ?? [];
      if (_pageController.hasClients && announcements.isNotEmpty) {
        _currentPage = (_currentPage + 1) % announcements.length;
        if (mounted) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeIn,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CompanyProfileApiProvider>();
    final List<Data> announcements =
        provider.compAnnouncementListModel?.data ?? [];

    if (provider.isLoading && announcements.isEmpty) {
      return SizedBox(height: 200, child: loadingIndicator());
    }

    if (!provider.isLoading && announcements.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16.0),
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

    return Container(
      height: 200,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: announcements.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return AnnouncementCard(announcement: announcements[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: announcements.length,
              effect: const ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotColor: Colors.grey,
                dotHeight: 8,
                dotWidth: 8,
                spacing: 4.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final Data announcement;

  const AnnouncementCard({Key? key, required this.announcement})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Card(
        elevation: 2.0,
        color: AppColors.lightBlueColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Published On: ${DateFormatter.formatToShortMonth( announcement.createdAt?.split("T").first ?? "N/A")}",
                      style: AppTextStyles.heading1(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 12),
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'ID: ${announcement.sId?.substring(0, 5) ?? "N/A"}',
                      style: AppTextStyles.heading1(
                        context,
                        overrideStyle: TextStyle(
                          color: AppColors.primary,
                          fontSize: ResponsiveHelper.fontSize(context, 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 25, thickness: 1, color: Colors.grey),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    announcement.message ?? "No message",
                    style: AppTextStyles.bodyText1(
                      context,
                      overrideStyle: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 12),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
