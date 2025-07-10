import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/admin/company_terms_conditions/model/all_terms_conditions_model.dart';
import 'package:hrms_management_code_crafter/admin/company_terms_conditions/controller/terms_conditions_api_provider.dart';
import 'package:hrms_management_code_crafter/util/html_text_view_util.dart';
import 'package:provider/provider.dart';
import 'package:hrms_management_code_crafter/util/loading_indicator.dart';
import 'package:hrms_management_code_crafter/ui_helper/app_colors.dart';
import 'package:hrms_management_code_crafter/ui_helper/common_widget/default_common_app_bar.dart';
import '../../../../ui_helper/app_text_styles.dart';
import '../../../../util/responsive_helper_util.dart';

class TermsConditiosListScreen extends StatefulWidget {
  const TermsConditiosListScreen({super.key});

  @override
  State<TermsConditiosListScreen> createState() => _TermsConditiosListScreenState();
}

class _TermsConditiosListScreenState extends State<TermsConditiosListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CompanyTermsConditionApiProvider>(context, listen: false)
          .getAllTermsConditionsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBgColor,
      appBar: const DefaultCommonAppBar(
        activityName: "Company Terms & Conditions",
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<CompanyTermsConditionApiProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return loadingIndicator();
          }

          if (provider.errorMessage.isNotEmpty) {
            return const Center(child: Text('Something went wrong'));
          }

          final termsList = provider.termsConditionsListModel?.data;

          if (termsList == null || termsList.isEmpty) {
            return const Center(child: Text('No Policies found.'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshTermsConditionList(),
            child: ListView.builder(
              itemCount: termsList.length,
              itemBuilder: (context, index) {
                final singleTerms = termsList[index];
                return TermsConditionsListItem(termsConditionsData: singleTerms);
              },
            ),
          );
        },
      ),
    );
  }
}

class TermsConditionsListItem extends StatefulWidget {
  final Data termsConditionsData;

  const TermsConditionsListItem({
    Key? key,
    required this.termsConditionsData,
  }) : super(key: key);

  @override
  State<TermsConditionsListItem> createState() => _TermsConditionsListItemState();
}

class _TermsConditionsListItemState extends State<TermsConditionsListItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: InkWell(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.termsConditionsData.title ?? "No Title",
                      style: AppTextStyles.heading1(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 14),
                        ),
                      ),
                      maxLines: isExpanded ? null : 1,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final provider = Provider.of<CompanyTermsConditionApiProvider>(
                        context,
                        listen: false,
                      );
                      await provider.deleteTermsConditions(
                        context,
                        widget.termsConditionsData.sId ?? "",
                      );
                    },
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 8),
                HTMLTextWidgetUtil(
                  text: widget.termsConditionsData.description ?? "No Description",
                ),
              ],
              // const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
