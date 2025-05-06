import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
 import 'package:hrms_management_code_crafter/util/responsive_helper_util.dart';

import '../ui_helper/app_colors.dart';

class HTMLTextWidgetUtil extends StatefulWidget {
  final String text;
  final int maxLines;
  final Map<String, Style>? customStyles; // Accepts custom styles
  final bool showExpandButton; // NEW: Toggle for "See More/See Less"

  const HTMLTextWidgetUtil({
    Key? key,
    required this.text,
    this.maxLines = 3, // Default number of lines to show
    this.customStyles, // New parameter to pass styles
    this.showExpandButton = false, // Default is true, but can be disabled
  }) : super(key: key);

  @override
  _HTMLTextWidgetUtilState createState() => _HTMLTextWidgetUtilState();
}

class _HTMLTextWidgetUtilState extends State<HTMLTextWidgetUtil> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Default styles
    Map<String, Style> defaultStyles = {
      "p": Style(
        color: Colors.black,
        fontSize: FontSize(ResponsiveHelper.fontSize(context, 12)),
        textAlign: TextAlign.justify,
        lineHeight: LineHeight(1.6),
        margin: Margins.zero, // Remove margins
        padding: HtmlPaddings.zero,
        wordSpacing: 1, // Adjust spacing if &nbsp; is causing issues

      ),
      "strong": Style(fontWeight: FontWeight.bold, color: Colors.black),
      "em": Style(fontStyle: FontStyle.italic),
      "h1": Style(fontSize: FontSize(22.0), fontWeight: FontWeight.bold, color: AppColors.primary),
      "h2": Style(fontSize: FontSize(20.0), fontWeight: FontWeight.bold, color: AppColors.primary),
      "a": Style(color: AppColors.primary, textDecoration: TextDecoration.underline),
      "pre": Style(margin: Margins.zero, padding: HtmlPaddings.zero, lineHeight: LineHeight(1)),
      "div": Style(margin: Margins.zero, padding: HtmlPaddings.zero), // No margin/padding for div
      "span": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
      "ul": Style(margin: Margins.zero, padding: HtmlPaddings.zero), // No margin/padding for ul
      "li": Style(margin: Margins.zero, padding: HtmlPaddings.zero), // No margin/padding for li
    };

    // Merge default styles with custom styles (if provided)
    final mergedStyles = {...defaultStyles, ...?widget.customStyles};
    final cleanedHtml = widget.text.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Html(
            data: cleanedHtml,
            style: mergedStyles, // Apply the merged styles
          ),
        ),

        // Optional "See More" / "See Less" functionality

        if (widget.showExpandButton)  GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? "See Less" : "See More",
            style: TextStyle(
              color: AppColors.primary,
              fontSize: ResponsiveHelper.fontSize(context, 12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
