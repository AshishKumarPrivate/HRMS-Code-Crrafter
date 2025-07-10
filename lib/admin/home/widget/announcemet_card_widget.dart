
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../util/responsive_helper_util.dart';
import '../../announcement/model/cmp_announcement_model.dart';
import 'package:flutter/material.dart';


class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

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
                      announcement.title,
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
                      'ID: ${announcement.id}',
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
                  // Allow scrolling for long descriptions
                  child: Text(
                    announcement.description,
                    style: AppTextStyles.bodyText1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveHelper.fontSize(context, 12),
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