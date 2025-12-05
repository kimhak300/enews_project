import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/app/controllers/language_controller.dart';
import 'package:newshub/app/widget/app_layout_widget.dart';
import 'package:intl/intl.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final LanguageController languageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: AppLayoutWidget(
        leftWidget: ClipOval(
          child: Image.asset(
            "assets/images/logo1.png",
            height: 50,
            width: 50,
          ),
        ),
        title: "E-New",
        rightWidget: GestureDetector(
          onTap: () => languageController.toggleLanguage(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Image.asset(
              languageController.isKhmer.value
                  ? "assets/images/kh_flag.png"
                  : "assets/images/en_flag.png",
              height: 32,
              width: 32,
            ),
          ),
        ),

        /// Body
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.paddingS),
              Flexible(flex: 1, child: _tabBar(context)),
              SizedBox(height: AppSpacing.paddingM),
              Flexible(flex: 9, child: _tabContent()),
            ],
          ),
        ),
      ),
    );
  }

  /// Tab Bar
  Widget _tabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TabBar(
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(text: "All"),
          Tab(text: "Following"),
          Tab(text: "My Article"),
        ],
      ),
    );
  }

  /// Tab Content
  Widget _tabContent() {
    return const TabBarView(
      children: [
        Center(child: Text("All Articles")),
        Center(child: Text("Following Articles")),
        Center(child: Text("My Articles")),
      ],
    );
  }

  /// TIME FORMATTER
  String _formatTime(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
      if (diff.inHours < 24) return '${diff.inHours} hr ago';
      if (diff.inDays < 7) return '${diff.inDays} days ago';

      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return '';
    }
  }
}