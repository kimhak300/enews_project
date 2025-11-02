import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../article_list_controller.dart';

class ArticleListView extends GetView<ArticleListController> {
  const ArticleListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('${controller.category.value} News')),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.articles.isEmpty) {
          return const Center(
            child: Text('No articles found'),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.articles.length,
          separatorBuilder: (context, index) => const Divider(height: 24),
          itemBuilder: (context, index) {
            final article = controller.articles[index];
            return InkWell(
              onTap: () => controller.goToArticleDetail(article),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${article.content.substring(0, article.content.length > 100 ? 100 : article.content.length)}...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          article.getTimeAgo(),
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.person, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          article.author,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
