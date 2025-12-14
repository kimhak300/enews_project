import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/api/controller/article_controller.dart';
import 'package:newshub/api/controller/category_controller.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/modules/admin/manage_articles/widgets/article_card_widget.dart';
import 'package:newshub/modules/admin/manage_articles/widgets/create_article_bottomsheet.dart';

class ManageArticlesView extends StatefulWidget {
  ManageArticlesView({super.key});

  @override
  State<ManageArticlesView> createState() => _ManageArticlesViewState();
}

class _ManageArticlesViewState extends State<ManageArticlesView> {
  late final ArticleController controller;
  late final CategoryController categoryController;
  String _selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    controller = Get.put(ArticleController());
    categoryController = Get.put(CategoryController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryController.fetchCategories();
      controller.fetchArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('articles'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text("add_article".tr),
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
          return Center(
              child: Text(
            'no_articles_found'.tr,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
          ));
        }

        return Padding(
          padding: EdgeInsets.all(AppSpacing.paddingXS),
          child: Column(
            children: [
              // Search + status
              Container(
                padding: const EdgeInsets.all(16),
                color: theme.colorScheme.surface,
                child: Column(
                  children: [
                    TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: 'search_articles'.tr,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: theme.colorScheme.onSurface.withOpacity(0.24)),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: controller.searchArticles,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildFilterChip(context, 'all'.tr, 'all'),
                        const SizedBox(width: 8),
                        Wrap(
                          children: [
                          _buildFilterChip(context, 'pubilished'.tr, 'pubilished'),
                        ]),
                        _buildFilterChip(context, 'draft'.tr, 'draft'),
                        const SizedBox(width: 8),
                        _buildFilterChip(context, 'archived'.tr, 'archived'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    controller.searchController.clear();
                    await controller.fetchArticles();
                  },
                  child: ListView.builder(
                    itemCount: controller.articles.length,
                    itemBuilder: (context, index) {
                      final article = controller.articles[index];
                      return ArticleCardWidget(
                        title: article.title,
                        subtitle: article.subtitle,
                        categories: article.categories,
                        images: article.media,
                        articleData: article.toJson(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String status) {
    final theme = Theme.of(context);
    final selected = _selectedStatus == status;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (v) {
        setState(() {
          _selectedStatus = v ? status : 'all';
          controller.searchController.clear();
          controller.filterByStatus(_selectedStatus);
        });
      },
      selectedColor: theme.colorScheme.primary.withOpacity(0.12),
    );
  }

  void _showFilterDialog(BuildContext context) {
    String? selectedCategory;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('filter_by_category'.tr),
          content: Obx(() {
            if (categoryController.isLoading.value) {
              return const SizedBox(
                height: 50,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'select_category'.tr,
              ),
              items: categoryController.categories
                  .map((cat) => DropdownMenuItem(
                        value: cat.name,
                        child: Text(cat.name),
                      ))
                  .toList(),
              value: selectedCategory,
              onChanged: (v) => setState(() => selectedCategory = v),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.fetchArticles();
              },
              child: Text('clear'.tr),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                controller.fetchArticles(category: selectedCategory);
              },
              child: Text('apply'.tr),
            ),
          ],
        ),
      ),
    );
  }
}

