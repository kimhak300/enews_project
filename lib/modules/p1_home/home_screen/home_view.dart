import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../home_controller.dart';
import '../../button_nav/bottom_nav_bar/bottom_nav_view.dart';
import '../../p2_dashboard/dashboard_screen/dashboard_view.dart';
import '../../p3_search/search_screen/search_view.dart';
import '../../p4_saved/saved_screen/bookmark_view.dart';
import '../../p5_profile/profile_screen/profile_view.dart';
import '../../../core/controllers/language_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _HomeContent(controller: controller),
      const DashboardView(),
      const SearchView(),
      const BookmarkView(),
      const ProfileView(),
    ];

    return Scaffold(
      // Use themed scaffold background so it adapts to dark mode
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() => pages[controller.currentNavIndex.value]),
      bottomNavigationBar: BottomNavView(),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final HomeController controller;
  final BuildContext? contextFromParent;

  _HomeContent({required this.controller, this.contextFromParent});
  // Track current carousel index to drive the segmented indicator
  final RxInt _carouselIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildTopTabs(),
            _buildNewsCarousel(),
            _buildNewsCart(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/logo1.png'),
            radius: 25,
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Fox News',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Obx(() {
            final lang = Get.find<LanguageController>();
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => Get.dialog(AlertDialog(
                    title: Text('select_language'.tr),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('English'),
                          leading: Image.asset('assets/images/en.png',
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.language)),
                          trailing: Obx(() => Radio<bool>(
                                value: false,
                                groupValue: lang.isKhmer.value,
                                onChanged: (v) {
                                  lang.changeLanguage(false);
                                  Get.back();
                                },
                              )),
                          onTap: () {
                            lang.changeLanguage(false);
                            Get.back();
                          },
                        ),
                        ListTile(
                          title: const Text('ភាសាខ្មែរ'),
                          leading: Image.asset('assets/images/kh.png',
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.language)),
                          trailing: Obx(() => Radio<bool>(
                                value: true,
                                groupValue: lang.isKhmer.value,
                                onChanged: (v) {
                                  lang.changeLanguage(true);
                                  Get.back();
                                },
                              )),
                          onTap: () {
                            lang.changeLanguage(true);
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  )),
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.language,
                        color: lang.isKhmer.value ? Colors.blue : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        lang.isKhmer.value ? 'ខ្មែរ' : 'En',
                        style: TextStyle(
                          fontSize: 12,
                          color: lang.isKhmer.value ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final lang = Get.find<LanguageController>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('select_language'.tr,
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              leading: Image.asset('assets/images/en.png',
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.language)),
              trailing: Obx(() => Radio<bool>(
                    value: false,
                    groupValue: lang.isKhmer.value,
                    onChanged: (v) {
                      lang.changeLanguage(false);
                      Navigator.pop(context);
                    },
                  )),
              onTap: () {
                lang.changeLanguage(false);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('ភាសាខ្មែរ'),
              leading: Image.asset('assets/images/kh.png',
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.language)),
              trailing: Obx(() => Radio<bool>(
                    value: true,
                    groupValue: lang.isKhmer.value,
                    onChanged: (v) {
                      lang.changeLanguage(true);
                      Navigator.pop(context);
                    },
                  )),
              onTap: () {
                lang.changeLanguage(true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTabs() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: controller.topTabs.length,
        itemBuilder: (context, index) =>
            _buildTabButton(controller.topTabs[index], index),
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    return Obx(() {
      final isSelected = controller.currentTopTab.value == index;
      return GestureDetector(
        onTap: () => controller.currentTopTab.value = index,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNewsCarousel() {
    return Obx(() {
      final items = controller.currentTopTab.value == 1
          ? controller.campusNewsItems
          : controller.currentTopTab.value == 2
              ? controller.governmentNewsItems
              : controller.newsItems;

      // Guard: ensure the index is always in range when tab changes
      if (_carouselIndex.value >= items.length) {
        _carouselIndex.value = 0;
      }

      return Stack(
        children: [
          CarouselSlider.builder(
            itemCount: items.length,
            options: CarouselOptions(
              height: 300,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (index, reason) {
                _carouselIndex.value = index;
              },
            ),
            itemBuilder: (context, index, realIdx) {
              final item = items[index];
              return _buildCarouselItem(item);
            },
          ),

          // Subtle top gradient to increase indicator contrast on bright images
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 28,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Segmented dashed-like indicator (active = solid white, inactive = dimmed)
          Positioned(
            bottom: 8,
            left: 12,
            right: 12,
            child: Obx(() {
              final active = _carouselIndex.value;
              final count = items.length;
              return Row(
                children: List.generate(count, (i) {
                  final bool filled = i <= active; // show previous as filled like stories
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: filled ? Colors.white : Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        ],
      );
    });
  }

  Widget _buildCarouselItem(Map<String, dynamic> news) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              news['image']!,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[800],
                child: const Icon(Icons.image_not_supported,
                    color: Colors.white54, size: 50),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                  Colors.black,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  // support both subtitle (home items) and description (other tabs)
                  (news['subtitle'] ?? news['description']) ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      news['readTime']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCart() {
    return Obx(() {
      final items = controller.currentTopTab.value == 1
          ? controller.campusNewsItems
          : controller.currentTopTab.value == 2
              ? controller.governmentNewsItems
              : controller.newsItems;

      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _buildCardItem(items[index]),
          );
        },
      );
    });
  }

  Widget _buildCardItem(Map<String, dynamic> news) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          // Background image
          Ink.image(
            image: AssetImage(news['image'] ?? 'assets/images/default.jpg'),
            height: 300,
            fit: BoxFit.cover,
            child: InkWell(
              onTap: () {},
            ),
          ),

          // Gradient overlay for text readability
          Container(
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),

          // Text content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news['title'] ?? 'Untitled News',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  // support both description and subtitle for different datasets
                  (news['description'] ?? news['subtitle']) ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
