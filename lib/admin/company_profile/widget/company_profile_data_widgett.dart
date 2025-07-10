import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/model/company_profile_data_model.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/screen/update_company_profile_screen.dart';
import 'package:hrms_management_code_crafter/admin/company_profile/widget/update_corporate_address_form_widget.dart';
import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:hrms_management_code_crafter/util/storage_util.dart';
import 'package:provider/provider.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../controller/comp_profile_api_provider.dart';
import 'cmp_profile_overview_shimmer_widget.dart';

class CompanyProfileOverviewScreen extends StatefulWidget {
  const CompanyProfileOverviewScreen({super.key});

  @override
  State<CompanyProfileOverviewScreen> createState() =>
      _CompanyProfileOverviewScreenState();
}

class _CompanyProfileOverviewScreenState
    extends State<CompanyProfileOverviewScreen> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<CompanyProfileApiProvider>(
    //     context,
    //     listen: false,
    //   ).getCompProfileData();
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CompanyProfileApiProvider>(context, listen: false);
      if (provider.compProfileDataModel == null) {
        provider.getCompProfileData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBgColor,
      // backgroundColor: Colors.green,
      // Use a light background for the overview
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<CompanyProfileApiProvider>(context, listen: false)
              .refreshCompProfileData();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<CompanyProfileApiProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: loadingIndicator(),
                    );
                  }
                  else if (provider.errorMessage != null &&
                      provider.errorMessage!.isNotEmpty) {
                    // Corrected condition
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              provider.errorMessage!,
                              // Now safely use !, as we checked for not null and not empty
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyText1(
                                context,
                                overrideStyle: const TextStyle(color: Colors.red),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                provider.getCompProfileData(); // Retry fetching data
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              child: const Text(
                                'Retry',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (provider.compProfileDataModel?.data == null) {
                    if (!provider.hasFetchedOnce) {
                      // Initial load: show loader
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: CompanyProfileShimmer(),
                      );
                    } else {
                      // Data was fetched before, now null again
                      return Center(
                        child: Text(
                          "No company profile data available.",
                          style: AppTextStyles.bodyText1(context),
                        ),
                      );
                    }
                  }
                  else {
                    // Safely access data using null-aware operators
                    final Data? data =
                        provider.compProfileDataModel!.data; // data can be null here
                    final OverviewData? overview = data?.overviewData;
                    final RegisteredOfficeAddress? registeredOffice =
                        data?.registeredOfficeAddress;
                    final RegisteredOfficeAddress? corporateOffice =
                        data?.corporateOfficeAddress;
                    final RegisteredOfficeAddress? customAddress =
                        data?.customAddress;

                    setOverViewData(overview!.sId.toString());

        
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (overview != null)
                            _buildSectionCard(
                              context,
                              title: "Company Information",
                              onEdit: ()async {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => UpdateCompanyProfileScreen(data: overview),
                                //   ),
                                // );
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => UpdateCompanyProfileScreen(data: overview),
                                  ),
                                );
        
                                if (result == true) {
                                  context.read<CompanyProfileApiProvider>().getCompProfileData();
                                }
                              },
                              children: [
                                _buildInfoTile(
                                  context,
                                  "Company Name",
                                  overview.companyName ?? "N/A",
                                ),
                                _buildInfoTile(
                                  context,
                                  "Brand Name",
                                  overview.brandName ?? "N/A",
                                ),
                                _buildInfoTile(
                                  context,
                                  "Official Email",
                                  overview.companyOfficialEmail ?? "N/A",
                                ),
                                _buildInfoTile(
                                  context,
                                  "Official Contact",
                                  overview.companyOfficialContact ?? "N/A",
                                ),
                                _buildInfoTile(
                                  context,
                                  "Website",
                                  overview.website ?? "N/A",
                                ),
                                _buildInfoTile(
                                  context,
                                  "Domain Name",
                                  overview.domainName ?? "N/A",
                                ),
                                _buildInfoTile(
                                  context,
                                  "Industry Types",
                                  overview.industryTypes?.join(', ') ?? "N/A",
                                ),
                                if (overview.logo?.secureUrl != null &&
                                    overview.logo!.secureUrl!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Center(
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: AppColors.lightBlueColor,
                                        backgroundImage: NetworkImage(
                                          overview.logo!.secureUrl!,
                                        ),
                                        onBackgroundImageError: (
                                          exception,
                                          stackTrace,
                                        ) {
                                          print('Error loading logo: $exception');
                                          // Fallback to a placeholder icon if image fails to load
                                        },
                                        // Removed the redundant child if image URL is present
                                      ),
                                    ),
                                  )
                                else // Fallback if no logo URL or empty
                                  Visibility(
                                    visible: false,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Center(
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor: AppColors.lightBlueColor,
                                          child: const Icon(
                                            Icons.business,
                                            size: 50,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          const SizedBox(height: 20.0),
                          if (registeredOffice != null)
                            _buildSectionCard(
                              context,
                              title: "Registered Office Address",
                              onEdit: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    // builder: (_) => UpdateCorporateAddressForm(),
                                    builder: (_) => UpdateCorporateAddressForm(registeredOfficeAddress: registeredOffice , data: overview!),
                                  ),
                                );

                                if (result == true) {
                                  context.read<CompanyProfileApiProvider>().getCompProfileData();
                                }
                              },
                              children: [
                                _buildAddressInfo(context, registeredOffice),
                              ],
                            ),
                          const SizedBox(height: 20.0),
                          if (corporateOffice != null)
                            _buildSectionCard(
                              context,
                              title: "Corporate Office Address",
                              children: [_buildAddressInfo(context, corporateOffice)],
                            ),
                          const SizedBox(height: 20.0),
                          if (customAddress != null)
                            _buildSectionCard(
                              context,
                              title: "Custom Address",
                              children: [_buildAddressInfo(context, customAddress)],
                            ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build a common section card
  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
        VoidCallback? onEdit, // <-- Add this
  }) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading2(
                    context,
                    overrideStyle: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20, color: AppColors.primary),
                    onPressed: onEdit,
                    tooltip: "Edit $title",
                  ),

              ],
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  // Helper to build a single info tile
  Widget _buildInfoTile(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: AppTextStyles.heading1(
                context,
                overrideStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? "N/A" : value,
              // Keep this check for empty strings
              style: AppTextStyles.bodyText1(
                context,
                overrideStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressInfo(
    BuildContext context,
    RegisteredOfficeAddress address,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoTile(context, "Address Line 1", address.address1 ?? "N/A"),
        if (address.address2 != null && address.address2!.isNotEmpty)
          _buildInfoTile(context, "Address Line 2", address.address2!),
        _buildInfoTile(context, "City", address.city ?? "N/A"),
        _buildInfoTile(context, "State", address.state ?? "N/A"),
        _buildInfoTile(context, "Country", address.country ?? "N/A"),
        _buildInfoTile(
          context,
          "Pincode",
          address.pincode?.toString() ?? "N/A",
        ),
      ],
    );
  }

  void setOverViewData(String overviewId) async{
    await StorageHelper().setCompanyOverviewId(overviewId);  }

}
