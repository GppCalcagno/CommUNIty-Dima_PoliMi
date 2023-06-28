import 'package:dima_project/layout_dimension.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget tabletBody;

  const ResponsiveLayout({super.key, required this.mobileBody, required this.tabletBody});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < limitWidth) {
          return mobileBody;
        } else {
          return tabletBody;
        }
      },
    );
  }
}
