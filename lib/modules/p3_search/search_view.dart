import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/app/widget/app_layout_widget.dart';
import 'package:newshub/modules/p1_home/widget/news_widget.dart';
import 'package:newshub/sqflite_db/controller/article_controller.dart';

class SearchView extends StatelessWidget {

  final ArticleController controller = Get.put(ArticleController());

  SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayoutWidget(
      title: "Search Article",
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _searchArticle(),
            SizedBox(height: AppSpacing.paddingL),
            _articleList(),
          ],
        ),
      )
    );
  }

  Widget _searchArticle(){
    return TextField(
      decoration: InputDecoration(
        hintText: "Search articles...",
        prefixIcon: const Icon(Icons.search),
      ),
      onChanged: (value) {
        controller.search(value);
      },
    );
  }

  Widget _articleList(){
    return Expanded(
      child: Obx(() {

        if (controller.searchResults.isEmpty) {
          return const Center(child: Text("No results"));
        }

        return ListView.builder(
          itemCount: controller.searchResults.length,
          itemBuilder: (_, index) {
            final a = controller.searchResults[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NewsWidget(
                username: a.authorName ?? "Unknown",
                time: a.publishedAt,
                caption: a.content,
                mediaUrl: a.imageUrl ?? "",
                authorId: a.authorId,
                articleId: a.articleId!,
              ),
            );
          },
        );
      }),
    );
  }
}