import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/api/controller/article_controller.dart';
import 'package:newshub/api/controller/category_controller.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/modules/admin/manage_articles/widgets/article_card_widget.dart';
import 'package:newshub/modules/admin/manage_articles/widgets/create_article_bottomsheet.dart';
import 'package:newshub/modules/admin/manage_articles/widgets/update_article_bottomsheet.dart';

class ManageArticlesView extends StatelessWidget {
  final ArticleController controller = Get.put(ArticleController());
  final CategoryController categoryController = Get.put(CategoryController());

  ManageArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Load categories and articles initially
    categoryController.fetchCategories();
    controller.fetchArticles();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Add Article"),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const CreateArticleBottomsheet(),
          ).then((_) => controller.fetchArticles());
        },
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.articles.isEmpty) {
          return const Center(child: Text('No articles found.'));
        }

        return Padding(
          padding: EdgeInsets.all(AppSpacing.paddingXS),
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.fetchArticles();
            },
            child: ListView.builder(
              itemCount: controller.articles.length,
              itemBuilder: (context, index) {
                final article = controller.articles[index];
                return ArticleCardWidget(
                  title: article.title,
                  subtitle: article.subtitle ?? '',
                  categories: article.categories,
                  articleData: article.toJson(), // full data for detail screen
                );
              },
            ),
          ),
        );
      }),
    );
  }

  void _showFilterDialog(BuildContext context) {
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Filter by Category'),
          content: Obx(() {
            if (categoryController.isLoading.value) {
              return const SizedBox(
                height: 50,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Category',
              ),
              items: categoryController.categories
                  .map(
                    (cat) => DropdownMenuItem(
                  value: cat.name,
                  child: Text(cat.name),
                ),
              )
                  .toList(),
              value: selectedCategory,
              onChanged: (v) => setState(() => selectedCategory = v),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.fetchArticles(); // Clear filter
              },
              child: const Text('Clear'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                controller.fetchArticles(category: selectedCategory); // Pass category
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
