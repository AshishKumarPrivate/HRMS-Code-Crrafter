import 'package:flutter/material.dart';
 import 'package:hrms_management_code_crafter/util/storage_util.dart';
import 'package:provider/provider.dart';

import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/common_widget/solid_rounded_button.dart';
import '../../../util/responsive_helper_util.dart';
import '../../auth/controller/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? empName, empEmail, empPhone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserStorageData();
  }

  Future<void> loadUserStorageData() async {
    String? name = await StorageHelper().getEmpLoginName();
    String? email = await StorageHelper().getEmpLoginEmail();
    String? phone = await StorageHelper().getEmpLoginMobile();

    setState(() {
      empName = name ?? "UserName";
      empEmail = email ?? "eg@gmail.com";
      empPhone = phone ?? "xxxxxxxxxx";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context),
              const SizedBox(height: 5),
              SizedBox(
                width: ResponsiveHelper.containerWidth(context, 30),
                height: ResponsiveHelper.containerWidth(context, 8),
                child: CustomButton(
                  text: "Logout",
                  textColor: Colors.red,
                  type: ButtonType.outlined,
                  iconData: Icons.logout,
                  iconColor: Colors.red,
                  borderColor: Colors.red,
                  onPressed: () {
                    showLogoutBottomSheet(context);
                  },
                ),
              ),
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
              Text("${empName}", style: AppTextStyles.heading3(context)),
              Text("${empEmail}", style: AppTextStyles.caption(context)),
              Text(
                "Mobile No:${empPhone}",
                style: AppTextStyles.caption(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showLogoutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// **Red Warning Icon**
            Container(width: 100, height: 5, color: Colors.grey[400]),

            Container(
              width: double.infinity,
              // color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 10),

                    /// **Sign Out Text**
                    Text(
                      "Sign out from Account",
                      style: AppTextStyles.bodyText1(
                        context,
                        overrideStyle: new TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// **Confirmation Message**
                    Text(
                      "Are you sure you would like to Logout of your Account",
                      textAlign: TextAlign.start,
                      style: AppTextStyles.bodyText1(
                        context,
                        overrideStyle: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            /// **Cancel & Logout Buttons**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// **Cancel Button**
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightBrown_color,
                    // Light background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 0,
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: new TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                /// **Logout Button**
                ElevatedButton(
                  onPressed: () async {
                    Provider.of<AuthAPIProvider>(
                      context,
                      listen: false,
                    ).logoutUser(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Orange button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 0,
                    ),
                  ),
                  child: Text(
                    "Logout",
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
