import 'package:flutter/material.dart';
import 'app_bar_widget.dart';

class AppLayoutWidget extends StatelessWidget {
  final String title;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final Widget body;

  const AppLayoutWidget({
    super.key,
    required this.title,
    required this.body,
    this.leftWidget,
    this.rightWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        // Top Custom AppBar
        appBar: AppBarWidget(
          title: title,
          left: leftWidget,
          right: rightWidget,
        ),

        // Content area
        body: body,
      ),
    );
  }
}