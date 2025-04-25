
import 'package:flutter/material.dart';
import 'package:hrms_management_code_crafter/util/size_config.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget child;
  const ResponsiveBuilder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return child;
  }
}
