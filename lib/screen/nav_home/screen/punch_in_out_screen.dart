import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:animated_background/animated_background.dart';

import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../util/location_service_utils.dart';
import '../../../util/responsive_helper_util.dart';
import '../../../util/storage_util.dart';
import '../../../util/string_utils.dart';
import '../controller/punch_in_out_provider.dart';
import 'camera_and_location_screen.dart';

class PunchInOutScreen extends StatefulWidget {

  @override
  State<PunchInOutScreen> createState() => _PunchInOutScreenState();
}

class _PunchInOutScreenState extends State<PunchInOutScreen> with TickerProviderStateMixin {
  String currentTime = "";
  Timer? _clockTimer;   // ← store reference
  String? empName, empEmail, empPhone, empLoginId;
  String? _punchPhotoPath;

  @override
  void initState() {
    super.initState();
    loadUserStorageData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationService = Provider.of<LocationService>(context, listen: false);
      if (!locationService.hasFetchedLocationOnce) {
        locationService.getLocationAndAddress(shouldOpenSettings: false);
      }
    });
    _startClock();
    Future.microtask(() {
      Provider.of<PunchInOutProvider>(context, listen: false).loadPunchData();
    });
  }


  Future<void> loadUserStorageData() async {
    String? name = await StorageHelper().getEmpLoginName();
    String? email = await StorageHelper().getEmpLoginEmail();
    String? phone = await StorageHelper().getEmpLoginMobile();

    empLoginId = await StorageHelper().getEmpLoginId();

    // NotificationService.initialize(context); // Initialize FCM

    setState(() {
      empName = name ?? "UserName";
      empEmail = email ?? "eg@gmail.com";
      empPhone = phone ?? "91xxxxxxxx";
    });
  }

  void _startClock() {
    _clockTimer =  Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        currentTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "PM" : "AM"}";
      });
    });
  }

  Future<void> _handlePunchAction(PunchInOutProvider provider) async {
    // Navigate to CameraScreen and await the result (image path)
    final String? imagePath = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CameraScreen()),
    );

    if (imagePath != null) {
      setState(() {
        _punchPhotoPath = imagePath; // Store the photo path
      });

      // Now, call the provider's punch method with the image path
      if (provider.isPunchedIn) {
        await provider.empCheckOut(context, );
      } else {
        await provider.empCheckIn(context, );
      }
    } else {
      // User cancelled camera or no photo taken
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo capture cancelled.')),
      );
    }
  }

  @override
  void dispose() {
    _clockTimer?.cancel(); // ← cancel when widget is removed
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final locationService = Provider.of<LocationService>(context);

    final now = DateTime.now();
    final provider = Provider.of<PunchInOutProvider>(context);
    // final formattedDate =
    //     "${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year} - ${["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"][now.weekday % 7]}";

  // Format: 19, May 2025
    final formattedDate = "${DateFormat("dd MMMM yyyy").format(now)} - ${DateFormat('EEEE').format(now)}";
    return Container(
      // color: AppColors.primary,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 0,
          left: 0,
          right: 0,
          bottom: 15,
        ),
        child: Column(
          children: [
            TopProfileHeader(empName:
            StringUtils.capitalizeEachWord(empName.toString(),
            ),empEmail:empEmail.toString(),
                address: locationService.addressMessage.isNotEmpty
                    ? locationService.addressMessage
                    : "Location not available",
                onRefresh: () {
                  locationService.getLocationAndAddress(shouldOpenSettings: true);
                },),


            SizedBox(height: 20),
            Text(
              currentTime,
              style: AppTextStyles.heading2(
                context,
                overrideStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.fontSize(context, 30),
                ),
              ),
            ),
            SizedBox(height: 1),
            Text(
              formattedDate,
              style: AppTextStyles.heading3(
                context,
                overrideStyle: TextStyle(
                  color: AppColors.txtGreyColor,
                  fontSize: ResponsiveHelper.fontSize(context, 14),
                ),
              ),
            ),
            SizedBox(height: 20),
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
                        baseColor: AppColors.primary,
                        // baseColor: Colors.orange.withAlpha(300),
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
                      provider.isPunchedIn ? provider.empCheckOut(context) : provider.empCheckIn(context);
                    // _handlePunchAction(provider);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fingerprint, size: 40, color: Colors.green),
                        SizedBox(height: 8),
                        Text(
                          provider.isPunchedIn ? "PUNCH OUT" : "PUNCH IN",
                          style: AppTextStyles.heading2(
                            context,
                            overrideStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveHelper.fontSize(context, 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  progressColor: provider.progressColor,
                  // progressColor: Colors.orange,
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
                  style: AppTextStyles.heading2(
                    context,
                    overrideStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.fontSize(context, 12),
                    ),
                  ),
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
                  _buildPunchTile( provider.getTotalHours() , "Total Hours"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPunchTile(String time, String label) {
    return Column(
      children: [
        Icon(Icons.access_time, color: AppColors.primary),
        SizedBox(height: 4),
        Text(time, style: AppTextStyles.heading1(
          context,
          overrideStyle: TextStyle(
            fontSize: ResponsiveHelper.fontSize(context, 12),
          ),
        ),),
        Text(label,style: AppTextStyles.bodyText1(
          context,
          overrideStyle: TextStyle(
            fontSize: ResponsiveHelper.fontSize(context, 12),
          ),
        ),),
      ],
    );
  }

  String formatTime(DateTime dt) {
    // final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    // final minute = dt.minute.toString().padLeft(2, '0');
    // final suffix = dt.hour >= 12 ? "PM" : "AM";
    // return "$hour:$minute $suffix";

    // Add 5 hours and 30 minutes to UTC to get IST
    final istTime = dt.add(Duration(hours: 5, minutes: 30));
    // Format to 'hh:mm:ss a' (e.g., 09:30:00 AM)
    return DateFormat('hh:mm a').format(istTime);
  }

}

class TopProfileHeader extends StatelessWidget {
  final String empName;
  final String empEmail;
  final String address;
  final VoidCallback onRefresh;

  const TopProfileHeader({
    Key? key,
    required this.empName,
    required this.empEmail,
    required this.address,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Listen to LocationService for updates to the address.
    // This allows the address in the header to react to changes.
    final locationService = Provider.of<LocationService>(context);

    // Determine the text to display for the address based on location service status
    String displayAddress;
    if (locationService.status == LocationStatus.loading) {
      displayAddress = "Fetching Location...";
    } else if (locationService.status == LocationStatus.denied ||
        locationService.status == LocationStatus.deniedForever ||
        locationService.status == LocationStatus.serviceDisabled ||
        locationService.status == LocationStatus.error) {
      displayAddress = locationService.addressMessage; // Display the error/denial message
    } else {
      displayAddress = address; // Use the provided address when granted/initial (if it has a value)
    }


    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary],
          // colors: [Color(0xFF00796B), Color(0xFF48A999)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.only(top: 45.0),
        child: Column(
          children: [
            // Profile section
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 32, color: Colors.grey[700]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringUtils.capitalizeEachWord(empName),
                        style: AppTextStyles.heading1(
                          context,
                          overrideStyle: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.fontSize(context, 16),
                          ),
                        ),
                      ),
                      Text(
                        empEmail,
                        style: AppTextStyles.bodyText1(
                          context,
                          overrideStyle: TextStyle(
                            color: AppColors.white,
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.verified,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Location section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                 const Icon(Icons.location_on, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      displayAddress,
                      style: AppTextStyles.bodyText1(
                        context,
                        overrideStyle: TextStyle(
                          color: Colors.black,
                          fontSize: ResponsiveHelper.fontSize(context, 12),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon:  Icon(Icons.refresh, color: AppColors.primary),
                    onPressed: onRefresh,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


