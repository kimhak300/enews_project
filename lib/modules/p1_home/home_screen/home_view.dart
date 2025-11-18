import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import '../home_controller.dart';
import '../../button_nav/bottom_nav_bar/bottom_nav_view.dart';
import '../../p2_dashboard/dashboard_screen/dashboard_view.dart';
import '../../p2_dashboard/dashboard_controller.dart';
import '../../p3_search/search_screen/search_view.dart';
import '../../p4_saved/bookmark_controller.dart';
import '../../p5_profile/profile_screen/profile_view.dart';
import '../../p5_profile/profile_controller.dart';
import '../../../core/controllers/language_controller.dart';
import '../../../app/models/comment_model.dart';
import '../../../app/models/post_model.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _HomeContent(controller: controller),
      const DashboardView(),
      const SizedBox.shrink(),
      const SearchView(),
      const ProfileView(),
    ];

    return Scaffold(
      body: Obx(() => pages[controller.currentNavIndex.value]),
      bottomNavigationBar: BottomNavView(),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final HomeController controller;
  final BuildContext? contextFromParent;

  _HomeContent({required this.controller, this.contextFromParent});
  final RxInt _carouselIndex = 0.obs;
  final List<Map<String, dynamic>> _followingArticles = [
    {
      'category': 'TECHNOLOGY',
      'title': 'The Dawn of a New AI Era: What to Expect in the Next Decade',
      'source': 'BBC News',
      'image':
          'https://images.unsplash.com/photo-1520607162513-77705c0f0d4a?auto=format&fit=crop&w=1000&q=80',
      'likes': '1.2k',
      'comments': '345',
      'shares': '89',
      'hasPlay': true,
    },
    {
      'category': 'BUSINESS',
      'title': 'Global Markets React to Unexpected Economic Policies',
      'source': 'Reuters',
      'image':
          'https://images.unsplash.com/photo-1520607162630-3719c414cdfa?auto=format&fit=crop&w=1000&q=80',
      'likes': '876',
      'comments': '102',
      'shares': '34',
      'hasPlay': false,
    },
    {
      'category': 'SCIENCE',
      'title': 'Breakthrough in Quantum Computing Could Redefine Encryption',
      'source': 'Associated Press',
      'image':
          'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=1000&q=80',
      'likes': '2.5k',
      'comments': '512',
      'shares': '120',
      'hasPlay': false,
    },
  ];

  final Map<String, dynamic> _popularHero = {
    'category': 'TECHNOLOGY',
    'title': 'The Dawn of a New AI Era: What to Expect',
    'source': 'BBC News',
    'image':
        'https://images.unsplash.com/photo-1453282716202-de94e528067c?auto=format&fit=crop&w=1100&q=80',
    'likes': '1.2k',
    'comments': '345',
  };

  final List<Map<String, dynamic>> _popularSpotlights = [
    {
      'title': 'Global Markets React to Policies',
      'image':
          'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'Quantum Computing Breakthrough',
      'image':
          'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': "Exploring the World's Most Serene Landscapes",
      'image':
          'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=600&q=80',
    },
    {
      'title': 'The Resurgence of Retro Gaming Culture',
      'image':
          'https://images.unsplash.com/photo-1511512578047-dfb367046420?auto=format&fit=crop&w=600&q=80',
    },
  ];

  final List<Map<String, dynamic>> _newsStories = [
    {
      'title': 'Major Breakthrough in Renewable Energy Technology',
      'source': 'Science Today',
      'image':
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1000&q=80',
      'likes': '1.9k',
      'comments': '256',
    },
    {
      'title': 'Global Markets Respond to New Economic Policies',
      'source': 'Financial Times',
      'image':
          'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=1000&q=80',
      'likes': '1.2k',
      'comments': '266',
    },
    {
      'title': 'The Future of Artificial Intelligence in Healthcare',
      'source': 'Tech Chronicle',
      'image':
          'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?auto=format&fit=crop&w=1000&q=80',
      'likes': '3.8k',
      'comments': '781',
    },
    {
      'title': "New World Record Set in the Men's 100m Dash",
      'source': 'Sports Weekly',
      'image':
          'https://images.unsplash.com/photo-1509228468518-180dd4864904?auto=format&fit=crop&w=1000&q=80',
      'likes': '5.9k',
      'comments': '992',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: controller.refreshHomePage,
        color: Colors.blue,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildTopTabs(),
              // _buildNewsCarousel(),
              _buildNewsCart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/logo1.png'),
            radius: 25,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Fox News',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold, color: Colors.red),
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
              text.tr,
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

  Widget _buildNewsCart() {
    return Obx(() {
      final tabIndex = controller.currentTopTab.value;
      if (tabIndex == 1) {
        return _buildFollowingFeed();
      }
      if (tabIndex == 2) {
        return _buildPopularFeed();
      }
      if (tabIndex == 3) {
        return _buildNewsFeed();
      }
      return Scrollbar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDashboardPosts(),
              _buildVideoCard(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFollowingFeed() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [Color(0xFF0B1121), Color(0xFF050912)],
          // ),
          ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Stories for you',
                  style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                //   decoration: BoxDecoration(
                //     color: Colors.white.withOpacity(0.08),
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   child: Row(
                //     children: [
                //       const Icon(Icons.tips_and_updates, color: Colors.red, size: 16),
                //       const SizedBox(width: 6),
                //       Text(
                //         'Live',
                //         style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(
                //           fontSize: 22,
                //           fontWeight: FontWeight.bold,
                //       ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 16),
            ..._followingArticles.map(_buildFollowingArticleCard),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowingArticleCard(Map<String, dynamic> article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    article['image'] as String,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        // color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.black,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.white60),
                      ),
                    ),
                  ),
                ),
                if (article['hasPlay'] == true)
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.85),
                        ),
                        child: const Icon(Icons.play_arrow,
                            color: Colors.black, size: 32),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (article['category'] as String).toUpperCase(),
                  style: const TextStyle(
                    letterSpacing: 1.5,
                    fontSize: 12,
                    color: Color(0xFF7F9CF5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article['title'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  article['source'] as String,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: Row(
              children: [
                _buildFollowingStat(
                    Icons.favorite_border, article['likes'] as String),
                const SizedBox(width: 16),
                _buildFollowingStat(
                    Icons.chat_bubble_outline, article['comments'] as String),
                const SizedBox(width: 16),
                _buildFollowingStat(Icons.share, article['shares'] as String),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  // child: IconButton(
                  //   icon: const Icon(Icons.share, color: Colors.white),
                  //   onPressed: () {
                  //     Get.snackbar(
                  //       'Shared',
                  //       'Story shared with your followers',
                  //       snackPosition: SnackPosition.BOTTOM,
                  //       backgroundColor: Colors.black.withOpacity(0.8),
                  //       colorText: Colors.white,
                  //       duration: const Duration(seconds: 2),
                  //     );
                  //   },
                  // ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowingStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildPopularFeed() {
    return Container(
      width: double.infinity,
      color: Theme.of(Get.context!).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(
              builder: (context) => Text(
                'Popular Highlights',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(Get.context!).primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 18),
            _buildPopularHeroCard(),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _popularSpotlights.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (_, index) => _buildPopularSpotlightCard(
                _popularSpotlights[index],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularHeroCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Theme.of(Get.context!).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    _popularHero['image'] as String,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow,
                          color: Colors.black, size: 34),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (_popularHero['category'] as String).toUpperCase(),
                  style: const TextStyle(
                    letterSpacing: 1.2,
                    fontSize: 11,
                    color: Color(0xFF90CDF4),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _popularHero['title'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _popularHero['source'] as String,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: [
                _buildFollowingStat(
                    Icons.favorite_border, _popularHero['likes'] as String),
                const SizedBox(width: 18),
                _buildFollowingStat(Icons.chat_bubble_outline,
                    _popularHero['comments'] as String),
                const Spacer(),
                // IconButton(
                //   icon: const Icon(Icons.share, color: Colors.white70),
                //   onPressed: () {
                //     Get.snackbar(
                //       'Shared',
                //       'Popular highlight shared',
                //       snackPosition: SnackPosition.BOTTOM,
                //       backgroundColor: Colors.black.withOpacity(0.85),
                //       colorText: Colors.white,
                //       duration: const Duration(seconds: 2),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSpotlightCard(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: AspectRatio(
              aspectRatio: 16 / 11,
              child: Image.network(
                data['image'] as String,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              data['title'] as String,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsFeed() {
    return Container(
      color: Theme.of(Get.context!).colorScheme.background,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          children:
              _newsStories.map((story) => _buildNewsStoryCard(story)).toList(),
        ),
      ),
    );
  }

  Widget _buildNewsStoryCard(Map<String, dynamic> story) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).primaryColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                story['image'] as String,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story['title'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  story['source'] as String,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: Row(
              children: [
                _buildFollowingStat(
                    Icons.favorite_border, story['likes'] as String),
                const SizedBox(width: 16),
                _buildFollowingStat(
                    Icons.chat_bubble_outline, story['comments'] as String),
                const Spacer(),
                // IconButton(
                //   icon: const Icon(Icons.share, color: Colors.white70),
                //   onPressed: () {
                //     Get.snackbar(
                //       'Shared',
                //       'News story shared',
                //       snackPosition: SnackPosition.BOTTOM,
                //       backgroundColor: Colors.black.withOpacity(0.8),
                //       colorText: Colors.white,
                //       duration: const Duration(seconds: 2),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardPosts() {
    try {
      final dashboardCtrl = Get.find<DashboardController>();

      return Obx(() {
        if (dashboardCtrl.posts.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => Text(
                      'Latest Posts',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // Navigate to dashboard - just informational, actual nav is in bottom nav
                    },
                    child: const Text('See all'),
                  ),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dashboardCtrl.posts.length > 3
                  ? 3
                  : dashboardCtrl.posts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final post = dashboardCtrl.posts[index];
                return _buildDashboardPostCard(post);
              },
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Builder(
              builder: (context) => Text(
                'Trending Videos',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      });
    } catch (e) {
      // Dashboard controller not initialized
      return const SizedBox.shrink();
    }
  }

  Widget _buildDashboardPostCard(post) {
    final profileCtrl = Get.put(ProfileController());

    return Builder(
      builder: (context) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info header
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Obx(() => CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blue,
                          backgroundImage:
                              profileCtrl.profileImage.value != null
                                  ? FileImage(profileCtrl.profileImage.value!)
                                  : null,
                          child: profileCtrl.profileImage.value == null
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                        )),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Obx(() => Text(
                                    profileCtrl.userName.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              const SizedBox(width: 4),
                              const Icon(Icons.verified,
                                  color: Colors.blue, size: 16),
                            ],
                          ),
                          Text(
                            _formatPostDate(post.createdAt),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {
                        _showDashboardPostOptionsBottomSheet(context, post);
                      },
                    ),
                  ],
                ),
              ),

              // Post title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  post.title,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 8),

              // Topic tag
              if (post.topic.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.withOpacity(0.4)),
                    ),
                    child: Text(
                      post.topic,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // Cover image if available
              if (post.coverImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.file(
                    File(post.coverImage!),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: Center(child: Icon(Icons.broken_image, size: 40)),
                    ),
                  ),
                ),

              // Interaction buttons
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPostInteractionButton(
                      context: context,
                      icon: post.isLiked ?? false
                          ? Icons.thumb_up
                          : Icons.thumb_up_outlined,
                      label: post.likeCount > 0 ? '${post.likeCount}' : 'Like',
                      color: post.isLiked ?? false
                          ? Colors.blue
                          : Colors.grey[600]!,
                      onTap: () => _togglePostLike(post),
                    ),
                    _buildPostInteractionButton(
                      context: context,
                      icon: Icons.comment_outlined,
                      label: post.commentCount > 0
                          ? '${post.commentCount}'
                          : 'Comment',
                      color: Colors.grey[600]!,
                      onTap: () => _showPostComments(context, post),
                    ),
                    _buildPostInteractionButton(
                      context: context,
                      icon: Icons.share_outlined,
                      label:
                          post.shareCount > 0 ? '${post.shareCount}' : 'Share',
                      color: Colors.grey[600]!,
                      onTap: () => _sharePostFromHome(post),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatPostDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  Widget _buildPostInteractionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePostLike(post) {
    try {
      final dashboardCtrl = Get.find<DashboardController>();
      final index = dashboardCtrl.posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        if (post.isLiked ?? false) {
          post.isLiked = false;
          post.likeCount = (post.likeCount ?? 0) > 0 ? post.likeCount - 1 : 0;
        } else {
          post.isLiked = true;
          post.likeCount = (post.likeCount ?? 0) + 1;
        }
        dashboardCtrl.posts[index] = post;
        dashboardCtrl.posts.refresh();
      }
    } catch (e) {
      // Dashboard controller not initialized
    }
  }

  void _showPostComments(BuildContext context, post,
      {VoidCallback? onUpdated}) {
    final profileCtrl = Get.put(ProfileController());
    final commentController = TextEditingController();

    // Check if this is a video post (starts with 'video_') or dashboard post
    final isVideoPost = post.id.toString().startsWith('video_');

    Get.bottomSheet(
      StatefulBuilder(
        builder: (BuildContext context, setModalState) {
          void addCommentToList(String text, String authorName) {
            final newComment = Comment(
              id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
              postId: post.id,
              authorName: authorName,
              authorImage: profileCtrl.profileImage.value?.path,
              text: text,
              createdAt: DateTime.now(),
            );

            // Add comment to post
            post.comments.add(newComment);
            post.commentCount = post.comments.length;

            // Update the modal state
            setModalState(() {});

            // Update the appropriate controller
            if (isVideoPost) {
              try {
                final homeCtrl = Get.find<HomeController>();
                final index =
                    homeCtrl.videoPosts.indexWhere((p) => p.id == post.id);
                if (index != -1) {
                  homeCtrl.videoPosts[index] = post;
                  homeCtrl.videoPosts.refresh();
                  homeCtrl.saveVideos();
                }
              } catch (e) {
                // Controller not found
              }
            } else {
              try {
                final dashboardCtrl = Get.find<DashboardController>();
                final index =
                    dashboardCtrl.posts.indexWhere((p) => p.id == post.id);
                if (index != -1) {
                  dashboardCtrl.posts[index] = post;
                  dashboardCtrl.posts.refresh();
                }
              } catch (e) {
                // Controller not found
              }
            }

            onUpdated?.call();
          }

          return Container(
            height: Get.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle bar
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                // Comments header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Text(
                        'comments',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${post.commentCount}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 24),
                // Comments list
                Expanded(
                  child: post.comments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No comments yet',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Be the first to comment',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: post.comments.length,
                          itemBuilder: (context, index) {
                            final comment = post.comments[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.blue,
                                    backgroundImage: comment.authorImage !=
                                                null &&
                                            File(comment.authorImage!)
                                                .existsSync()
                                        ? FileImage(File(comment.authorImage!))
                                        : null,
                                    child: comment.authorImage == null ||
                                            !File(comment.authorImage!)
                                                .existsSync()
                                        ? Text(
                                            comment.authorName[0].toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              comment.authorName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              comment.getTimeAgo(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          comment.text,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[800],
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                // Comment input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        Obx(() => CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.blue,
                              backgroundImage: profileCtrl.profileImage.value !=
                                      null
                                  ? FileImage(profileCtrl.profileImage.value!)
                                  : null,
                              child: profileCtrl.profileImage.value == null
                                  ? const Icon(Icons.person,
                                      size: 18, color: Colors.white)
                                  : null,
                            )),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: commentController,
                              decoration: const InputDecoration(
                                hintText: 'Write a comment...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              style: const TextStyle(fontSize: 14),
                              maxLines: null,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (value) {
                                if (value.trim().isNotEmpty) {
                                  addCommentToList(
                                      value, profileCtrl.userName.value);
                                  commentController.clear();
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.blue),
                          onPressed: () {
                            if (commentController.text.trim().isNotEmpty) {
                              addCommentToList(commentController.text,
                                  profileCtrl.userName.value);
                              commentController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
      isDismissible: true,
    );
  }

  void _sharePostFromHome(post) {
    try {
      final dashboardCtrl = Get.find<DashboardController>();
      final index = dashboardCtrl.posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        post.shareCount = (post.shareCount ?? 0) + 1;
        dashboardCtrl.posts[index] = post;
        dashboardCtrl.posts.refresh();
      }
    } catch (e) {
      // Dashboard controller not initialized
    }

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Share Post',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              iconColor: Colors.black,
              leading: const Icon(Icons.copy),
              title: const Text('Copy link',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Copied',
                  'Link copied to clipboard',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 1),
                );
              },
            ),
            ListTile(
              iconColor: Colors.black,
              leading: const Icon(Icons.share),
              title: const Text('Share to other apps',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Shared',
                  'Post shared successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 1),
                );
              },
            ),
            ListTile(
              iconColor: Colors.black,
              leading: const Icon(Icons.message),
              title: const Text('Send in message',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Message',
                  'Opening messages...',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 1),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _shareVideoPost(Post videoPost, int index) {
    final homeCtrl = Get.find<HomeController>();

    // Update the share count
    videoPost.shareCount = (videoPost.shareCount) + 1;
    homeCtrl.videoPosts[index] = videoPost;
    homeCtrl.videoPosts.refresh();
    homeCtrl.saveVideos();

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Share Video',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              iconColor: Colors.black,
              leading: const Icon(Icons.copy),
              title: const Text('Copy link',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Copied',
                  'Link copied to clipboard',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 1),
                );
              },
            ),
            ListTile(
              iconColor: Colors.black,
              leading: const Icon(Icons.share),
              title: const Text('Share to other apps',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Shared',
                  'Video shared successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 1),
                );
              },
            ),
            ListTile(
              iconColor: Colors.black,
              leading: const Icon(Icons.message),
              title: const Text('Send in message',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Message',
                  'Opening messages...',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 1),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard() {
    final profileCtrl = Get.put(ProfileController());
    final homeCtrl = Get.put(HomeController());

    // Different text descriptions for each video
    final List<String> videoDescriptions = [
      'កំណត់ចងក្រោយការបូជនីយកិច្ចបញ្ចប់អនុស្សាវរីយ៍លើកទី៣របស់ប្រធានាធិបតី Donald Trump ប្រពន្ធដំបូងនៃលោក Trump បានសាទរពានដែលដ្ឋាន់មានឯកឧត្តមផត់ដ្ឋាន',
      'ព័ត៌មានចុងក្រោយអំពីស្ថានភាពសេដ្ឋកិច្ចពិភពលោក និងការវិវឌ្ឍន៍ថ្មីៗនៅក្នុងវិស័យបច្ចេកវិទ្យា',
      'របាយការណ៍ពិសេសអំពីការអភិវឌ្ឍន៍ក្នុងវិស័យការអប់រំ និងនវានុវត្តន៍ថ្មីៗសម្រាប់សិស្សានុសិស្ស',
      'ការវិភាគស៊ីជម្រៅអំពីស្ថានភាពនយោបាយក្នុងតំបន់ និងផលប៉ះពាល់របស់វាទៅលើសង្គម',
      'ព័ត៌មានកីឡាចុងក្រោយ ការប្រកួតសំខាន់ៗ និងសមិទ្ធផលរបស់កីឡាករជាតិ',
    ];

    // Ensure persistent video posts exist in HomeController
    if (homeCtrl.videoPosts.isEmpty) {
      final generated = List.generate(
          5,
          (index) => Post(
                id: 'video_$index',
                title: videoDescriptions[index],
                topic: 'Video',
                createdAt: DateTime.now()
                    .subtract(Duration(minutes: (index + 1) * 15)),
                authorId: 'video_author',
                authorName: profileCtrl.userName.value,
                authorImage: profileCtrl.profileImage.value?.path,
              ));
      homeCtrl.videoPosts.assignAll(generated);
      homeCtrl.saveVideos();
    }

    return Scrollbar(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trending videos list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: [
              homeCtrl.homeVideoUrls.length,
              homeCtrl.videoControllers.length,
              homeCtrl.isInitializedList.length
            ].reduce((a, b) => a < b ? a : b),
            itemBuilder: (context, index) {
              return Obx(() {
                final videoPost = homeCtrl.videoPosts[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User info header for each video
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Obx(() => CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.blue,
                                  backgroundImage:
                                      profileCtrl.profileImage.value != null
                                          ? FileImage(
                                              profileCtrl.profileImage.value!)
                                          : null,
                                  child: profileCtrl.profileImage.value == null
                                      ? const Icon(Icons.person,
                                          color: Colors.white)
                                      : null,
                                )),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Obx(() => Text(
                                            profileCtrl.userName.value,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          )),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.verified,
                                          color: Colors.blue, size: 16),
                                    ],
                                  ),
                                  const SizedBox(width: 1),
                                  Text(
                                    _formatPostDate(DateTime.now().subtract(
                                        Duration(minutes: (index + 1) * 15))),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_horiz),
                              onPressed: () {
                                _showPostOptionsBottomSheet(context, videoPost);
                              },
                            ),
                          ],
                        ),
                      ),

                      // Post text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          index < videoDescriptions.length
                              ? videoDescriptions[index]
                              : 'ព័ត៌មានថ្មីៗពីសារព័ត៌មាន',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Video player
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FullScreenVideoPage(
                                controller: homeCtrl.videoControllers[index],
                                title: index == 0
                                    ? "កំណត់ចងក្រោយការបូជនីយកិច្ចបញ្ចប់អនុស្សាវរីយ៍លើកទី៣របស់ប្រធានាធិបតី Donald Trump ប្រពន្ធដំបូងនៃលោក Trump បានសាទរពានដែលដ្ឋាន់មានឯកឧត្តមផត់ដ្ឋាន"
                                    : index == 1
                                        ? "ព័ត៌មានចុងក្រោយអំពីស្ថានភាពសេដ្ឋកិច្ចពិភពលោក និងការវិវឌ្ឍន៍ថ្មីៗនៅក្នុងវិស័យបច្ចេកវិទ្យា"
                                        : index == 2
                                            ? "របាយការណ៍ពិសេសអំពីការអភិវឌ្ឍន៍ក្នុងវិស័យការអប់រំ និងនវានុវត្តន៍ថ្មីៗសម្រាប់សិស្សានុសិស្ស"
                                            : index == 3
                                                ? "ការវិភាគស៊ីជម្រៅអំពីស្ថានភាពនយោបាយក្នុងតំបន់ និងផលប៉ះពាល់របស់វាទៅលើសង្គម"
                                                : index == 4
                                                    ? "ព័ត៌មានកីឡាចុងក្រោយ ការប្រកួតសំខាន់ៗ និងសមិទ្ធផលរបស់កីឡាករជាតិ"
                                                    : "Trending Video",
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Obx(() {
                            if (homeCtrl.isInitializedList[index].value) {
                              return AspectRatio(
                                aspectRatio: homeCtrl
                                    .videoControllers[index].value.aspectRatio,
                                child: VideoPlayer(
                                    homeCtrl.videoControllers[index]),
                              );
                            } else {
                              return Container(
                                color: Colors.black,
                                height: 180,
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              );
                            }
                          }),
                        ),
                      ),

                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildPostInteractionButton(
                              context: context,
                              icon: videoPost.isLiked
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined,
                              label: videoPost.likeCount > 0
                                  ? '${videoPost.likeCount}'
                                  : 'Like',
                              color: videoPost.isLiked
                                  ? Colors.blue
                                  : Colors.grey[600]!,
                              onTap: () {
                                videoPost.isLiked = !videoPost.isLiked;
                                if (videoPost.isLiked) {
                                  videoPost.likeCount++;
                                } else {
                                  videoPost.likeCount--;
                                }
                                homeCtrl.videoPosts.refresh();
                                homeCtrl.saveVideos();
                              },
                            ),
                            _buildPostInteractionButton(
                              context: context,
                              icon: Icons.comment_outlined,
                              label: videoPost.comments.length > 0
                                  ? '${videoPost.comments.length}'
                                  : 'Comment',
                              color: Colors.grey[600]!,
                              onTap: () {
                                _showPostComments(context, videoPost,
                                    onUpdated: () {
                                  homeCtrl.videoPosts.refresh();
                                  homeCtrl.saveVideos();
                                });
                              },
                            ),
                            _buildPostInteractionButton(
                              context: context,
                              icon: Icons.share_outlined,
                              label: videoPost.shareCount > 0
                                  ? '${videoPost.shareCount}'
                                  : 'Share',
                              color: Colors.grey[600]!,
                              onTap: () => _shareVideoPost(videoPost, index),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentImageThumbnail(String imagePath) {
    return Container(
      width: 35,
      height: 35,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.image, size: 16),
          ),
        ),
      ),
    );
  }

  void _showPostOptionsBottomSheet(BuildContext context, Post post) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.black),
                ),
                title: const Text(
                  'Edit',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'edit post',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post edited')),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bookmark_border, color: Colors.black),
                ),
                title: const Text(
                  'Save',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'Add to Favorite List',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  try {
                    final bookmarkCtrl = Get.put(BookmarkController());
                    bookmarkCtrl.savePost(post);
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      'Failed to save video',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  }
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.black),
                ),
                title: const Text(
                  'Delete',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'are you sure to delete this content?',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Content deleted')),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.report_outlined, color: Colors.black),
                ),
                title: const Text(
                  'Report',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'Feedback Bad Content',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report submitted')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDashboardPostOptionsBottomSheet(BuildContext context, post) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit, color: Colors.black),
                ),
                title: const Text(
                  'Edit',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'Edit this post',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to edit post page
                  Get.toNamed('/edit-post', arguments: post);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bookmark_border, color: Colors.black),
                ),
                title: const Text(
                  'Save',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'Add to Favorite List',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  try {
                    final bookmarkCtrl = Get.put(BookmarkController());
                    bookmarkCtrl.savePost(post);
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      'Failed to save post',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  }
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.red),
                ),
                title: const Text(
                  'Delete',
                  style:
                      TextStyle(fontWeight: FontWeight.w500, color: Colors.red),
                ),
                subtitle: const Text(
                  'Remove this post permanently',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Show confirmation dialog
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Delete Post'),
                      content: const Text(
                          'Are you sure you want to delete this post? This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            try {
                              final dashboardCtrl =
                                  Get.find<DashboardController>();
                              dashboardCtrl.posts
                                  .removeWhere((p) => p.id == post.id);
                              Get.back();
                              Get.snackbar(
                                'Deleted',
                                'Post deleted successfully',
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 2),
                              );
                            } catch (e) {
                              Get.back();
                              Get.snackbar(
                                'Error',
                                'Failed to delete post',
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 2),
                              );
                            }
                          },
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.report_outlined, color: Colors.black),
                ),
                title: const Text(
                  'Report',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: const Text(
                  'Report inappropriate content',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Get.snackbar(
                    'Report Submitted',
                    'Thank you for reporting this content',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
