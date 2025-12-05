import 'package:flutter/material.dart';
import 'package:newshub/app/widget/app_layout_widget.dart';

class SearchView extends StatelessWidget {

  SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayoutWidget(
      title: "Search Article",
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [

          ],
        ),
      )
    );
  }
}