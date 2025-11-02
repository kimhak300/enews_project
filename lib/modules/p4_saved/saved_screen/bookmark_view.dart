import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../bookmark_controller.dart';

class BookmarkView extends GetView<BookmarkController> {
  const BookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.put to ensure controller exists when accessed from bottom nav
    final ctrl = Get.put(BookmarkController());
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              'bookmarks'.tr,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
        if (ctrl.bookmarkedArticles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_border,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'no_bookmarks_yet'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ctrl.bookmarkedArticles.length,
          itemBuilder: (context, index) {
            final article = ctrl.bookmarkedArticles[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () => ctrl.goToArticleDetail(article),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.image,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${'saved'.tr} ${article.getTimeAgo()}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                article.category,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark),
                        color: AppTheme.primaryColor,
                        onPressed: () => ctrl.removeBookmark(article),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
          ),
        ],
        ),
      ),
    );
  }
}
