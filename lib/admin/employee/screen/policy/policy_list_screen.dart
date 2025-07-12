import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/util/html_text_view_util.dart';
import 'package:provider/provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/controller/policy/company_policy_api_provider.dart';
import 'package:hrms_management_code_crafter/admin/employee/model/policy/all_cmp_policy_list_model_response.dart';
import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:hrms_management_code_crafter/ui_helper/app_colors.dart';
import 'package:hrms_management_code_crafter/ui_helper/common_widget/default_common_app_bar.dart';
import '../../../../ui_helper/app_text_styles.dart';
import '../../../../util/responsive_helper_util.dart';

class PolicyListScreen extends StatefulWidget {
  const PolicyListScreen({super.key});

  @override
  State<PolicyListScreen> createState() => _PolicyListScreenState();
}

class _PolicyListScreenState extends State<PolicyListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CompanyPolicyApiProvider>(context, listen: false)
          .getAllPolicyList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBgColor,
      appBar: const DefaultCommonAppBar(
        activityName: "Our Company Policies",
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<CompanyPolicyApiProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return loadingIndicator();
          }

          if (provider.errorMessage.isNotEmpty) {
            return const Center(child: Text('Something went wrong'));
          }

          final policies = provider.policyListModel?.data;

          if (policies == null || policies.isEmpty) {
            return const Center(child: Text('No Policies found.'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshEmployeeList(),
            child: ListView.builder(
              itemCount: policies.length,
              itemBuilder: (context, index) {
                final policy = policies[index];
                return PolicyListItem(policyData: policy);
              },
            ),
          );
        },
      ),
    );
  }
}
// Inside your PolicyListItem widget
class PolicyListItem extends StatefulWidget {
  final Data policyData;

  const PolicyListItem({
    Key? key,
    required this.policyData,
  }) : super(key: key);

  @override
  State<PolicyListItem> createState() => _PolicyListItemState();
}

class _PolicyListItemState extends State<PolicyListItem>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          setState(() => isExpanded = !isExpanded);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.white, AppColors.lightBgColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.5),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.policyData.title ?? "No Title",
                      style: AppTextStyles.heading2(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 15),
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      maxLines: isExpanded ? null : 1,
                      overflow:
                      isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    tooltip: "Delete Policy",
                    icon: const Icon(Icons.delete_forever_rounded,
                        color: Colors.redAccent, size: 22),
                    onPressed: () async {
                      final provider =
                      Provider.of<CompanyPolicyApiProvider>(context,
                          listen: false);
                      await provider.deletePolicy(
                        context,
                        widget.policyData.sId ?? "",
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 6),

              /// Description
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: HTMLTextWidgetUtil(
                    text: widget.policyData.description ?? "No Description",
                  ),
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

