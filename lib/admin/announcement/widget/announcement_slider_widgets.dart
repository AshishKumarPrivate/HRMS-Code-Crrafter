import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/announcement/controller/announcement_api_provider.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/model/announcement_list_model.dart';
import 'package:hrms_management_code_crafter/util/date_formate_util.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../ui_helper/app_colors.dart';
import '../../../../ui_helper/app_text_styles.dart';
import '../../../../util/loading_indicator.dart';
import '../../../../util/responsive_helper_util.dart';

class AnnouncementSliderWidget extends StatefulWidget {
  const AnnouncementSliderWidget({super.key});

  @override
  State<AnnouncementSliderWidget> createState() => _AnnouncementSliderWidgetState();
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
    final provider = context.read<CompanyAnnouncementApiProvider>();
    await provider.getAllAnnouncementList(); // always fetch

    if (mounted) {
      _startAutoPlay(); // Start auto scroll after data loaded
    }
  }

  void _startAutoPlay() {
    _timer?.cancel(); // prevent multiple timers
    final announcements =
        context
            .read<CompanyAnnouncementApiProvider>()
            .compAnnouncementListModel
            ?.data ??
        [];

    if (announcements.isEmpty) return;
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // final announcements = context.read<CompanyAnnouncementApiProvider>().compAnnouncementListModel?.data ?? [];
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

  // Function to handle the delete action
  Future<void> _deleteTermsCondition(String? id) async {
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Terms Condition ID is missing.')),
      );
      return;
    }

    final bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Confirm Delete', style: AppTextStyles.heading1(
          context,
          overrideStyle: TextStyle(
            fontSize: ResponsiveHelper.fontSize(context, 14),
          ),
        ),),
        content: Text('Are you sure you want to delete this Terms & Condition?', style: AppTextStyles.bodyText2(
          context,
          overrideStyle: TextStyle(
            fontSize: ResponsiveHelper.fontSize(context, 12),
          ),
        ),),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: AppTextStyles.heading2(
              context,
              overrideStyle: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 12),
              ),
            ),),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: AppTextStyles.bodyText2(
              context,
              overrideStyle: TextStyle(
                color: Colors.red,
                fontSize: ResponsiveHelper.fontSize(context, 12),
              ),
            ),),
          ),
        ],
      ),
    ) ?? false; // Default to false if dialog is dismissed

    if (confirmDelete) {
      final provider = context.read<CompanyAnnouncementApiProvider>();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deleting...')),
      );
      await provider.deleteAnnouncement(context, id);
      if (!provider.isLoading && provider.errorMessage!.isEmpty) {
        if (_currentPage >= (provider.compAnnouncementListModel?.data?.length ?? 0) && _currentPage > 0) {
          setState(() {
            _currentPage = (provider.compAnnouncementListModel?.data?.length ?? 0) - 1;
            if (_pageController.hasClients) {
              _pageController.jumpToPage(_currentPage);
            }
          });
        }
        _startAutoPlay();
      } else {
        SnackBar(
          content: Text(
            (provider.errorMessage ?? '').isNotEmpty
                ? provider.errorMessage!
                : 'Failed to delete terms condition.',
          ),
        );

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CompanyAnnouncementApiProvider>();
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
                return AnnouncementCard(announcement: announcements[index],
                  onDelete: _deleteTermsCondition,);
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
  final Function(String?) onDelete;

  // const AnnouncementCard({Key? key, required this.announcement,})
  //   : super(key: key);
  const AnnouncementCard({
    Key? key,
    required this.announcement,
    required this.onDelete, // Required callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFE8F5E9)], // light cyan to mint
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 5),
            ),
          ],
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
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(30),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:  IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () => onDelete(announcement.sId.toString()), // Call the callback
                    ),

                    // Text(
                    //   'ID: ${termsConditinos.sId?.substring(0, 5) ?? "N/A"}',
                    //   style: AppTextStyles.heading1(
                    //     context,
                    //     overrideStyle: TextStyle(
                    //       color: AppColors.primary,
                    //       fontSize: ResponsiveHelper.fontSize(context, 12),
                    //     ),
                    //   ),
                    // ),
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
