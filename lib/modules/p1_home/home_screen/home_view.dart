import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';

import '../home_controller.dart';
import '../../button_nav/bottom_nav_bar/bottom_nav_view.dart';
import '../../p2_dashboard/dashboard_screen/dashboard_view.dart';
import '../../p3_search/search_screen/search_view.dart';
import '../../p4_saved/saved_screen/bookmark_view.dart';
import '../../p5_profile/profile_screen/profile_view.dart';
import '../../p5_profile/profile_controller.dart';
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
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  final bool filled =
                      i <= active; // show previous as filled like stories
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVideoCard(),
        ],
      ),
    );
  }

  Widget _buildVideoCard() {
    final profileCtrl = Get.put(ProfileController());
    final homeCtrl = Get.put(HomeController());

    // Track like state for each video
    final likeStates = List.generate(5, (index) => false.obs);
    final likeCounts = List.generate(5, (index) => 0.obs);

    // Different text descriptions for each video
    final List<String> videoDescriptions = [
      'កំណត់ចងក្រោយការបូជនីយកិច្ចបញ្ចប់អនុស្សាវរីយ៍លើកទី៣របស់ប្រធានាធិបតី Donald Trump ប្រពន្ធដំបូងនៃលោក Trump បានសាទរពានដែលដ្ឋាន់មានឯកឧត្តមផត់ដ្ឋាន',
      'ព័ត៌មានចុងក្រោយអំពីស្ថានភាពសេដ្ឋកិច្ចពិភពលោក និងការវិវឌ្ឍន៍ថ្មីៗនៅក្នុងវិស័យបច្ចេកវិទ្យា',
      'របាយការណ៍ពិសេសអំពីការអភិវឌ្ឍន៍ក្នុងវិស័យការអប់រំ និងនវានុវត្តន៍ថ្មីៗសម្រាប់សិស្សានុសិស្ស',
      'ការវិភាគស៊ីជម្រៅអំពីស្ថានភាពនយោបាយក្នុងតំបន់ និងផលប៉ះពាល់របស់វាទៅលើសង្គម',
      'ព័ត៌មានកីឡាចុងក្រោយ ការប្រកួតសំខាន់ៗ និងសមិទ្ធផលរបស់កីឡាករជាតិ',
    ];

    return Column(
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
                              backgroundImage: profileCtrl.profileImage.value !=
                                      null
                                  ? FileImage(profileCtrl.profileImage.value!)
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
                              const Text(
                                '4hour(s) ago • ព័ត៌មានខ្លីរយៈពេល',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_horiz),
                          onPressed: () {
                            _showPostOptionsBottomSheet(context);
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
                            child:
                                VideoPlayer(homeCtrl.videoControllers[index]),
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

                  // Interaction buttons
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildLikeButton(likeStates[index], likeCounts[index]),
                        _buildCommentButton(context),
                        _buildActionButton(Icons.share_outlined, 'Share'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLikeButton(RxBool isLiked, RxInt likeCount) {
    return Obx(() => InkWell(
          onTap: () {
            isLiked.value = !isLiked.value;
            if (isLiked.value) {
              likeCount.value++;
            } else {
              likeCount.value--;
            }
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Icon(
                  isLiked.value ? Icons.thumb_up : Icons.thumb_up_outlined,
                  size: 20,
                  color: isLiked.value ? Colors.blue : Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  likeCount.value > 0 ? '${likeCount.value}' : 'Like',
                  style: TextStyle(
                    color: isLiked.value ? Colors.blue : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ));
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

  Widget _buildCommentButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _showCommentsBottomSheet(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Icon(Icons.comment_outlined, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              'Comment',
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

  void _showCommentsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'All comments(0)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48), // Balance the close button
                      ],
                    ),
                  ),

                  // Empty state
                  Expanded(
                    child: ListView(
                      controller: controller,
                      children: [
                        const SizedBox(height: 100),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 80,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No comment',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Comment input
                  Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border(
                        top: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          // SizedBox(
                          //   height: 40,
                          //   width: 120,
                          //   child: ListView(
                          //     scrollDirection: Axis.horizontal,
                          //     children: [
                          //       _buildRecentImageThumbnail('assets/images/logo1.png'),
                          //       _buildRecentImageThumbnail('assets/images/logo1.png'),
                          //       _buildRecentImageThumbnail('assets/images/logo1.png'),
                          //     ],
                          //   ),
                          // ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Comment',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.send_outlined),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.emoji_emotions_outlined),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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

  void _showPostOptionsBottomSheet(BuildContext context) {
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
                  'Follow',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'Add to follow list',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to follow list')),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to favorites')),
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
                  child: const Icon(Icons.close, color: Colors.black),
                ),
                title: const Text(
                  'Unlike',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'Hide this content, reduce this type of content recommendation',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Content hidden')),
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
}
