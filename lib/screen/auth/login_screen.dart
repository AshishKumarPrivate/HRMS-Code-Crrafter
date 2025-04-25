import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hrms_management_code_crafter/screen/auth/widget/login_form_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bottom_navigation_screen.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';
import '../../util/dimensions_utils.dart';
import '../../util/image_loader_util.dart';
import '../../util/responsive_helper_util.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Uri _url = Uri.parse('https://codecrafter.co.in/');

  Future<void> _launchURL() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      Text(
                        'Sign In ',
                        style: AppTextStyles.heading1(
                          context,
                          overrideStyle: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.fontSize(context, 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // White container (Login Card)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    margin: EdgeInsets.only(
                      bottom: ResponsiveHelper.containerHeight(context, 5),
                    ), // leave space for bottom bar
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(36),
                      ),
                    ),
                    child: SingleChildScrollView(child: LoginFormWidget()),
                  ),
                ),
              ],
            ),

            // Fixed Bottom Powered By
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: buildBottomSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomSection() {
    return Container(
      color: Colors.white,
      height: ResponsiveHelper.containerHeight(context, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Powered By",
            style: AppTextStyles.heading1(
              context,
              overrideStyle: TextStyle(
                fontSize: ResponsiveHelper.fontSize(
                  context,
                  Dimensions.fontSize10,
                ),
              ),
            ),
          ),
          // const SizedBox(width: 8),
          ResponsiveHelper.sizeboxWidthlSpace(
            context,
            Dimensions.sizeBoxHorizontalSpace_2,
          ),
          GestureDetector(
            onTap: () {
              _launchURL();
              print("logo clicked ");
            },
            child: Container(
              width: ResponsiveHelper.containerWidth(context, 20),
              child: ImageLoaderUtil.assetImage(
                "assets/images/code_crafter_logo.png",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
