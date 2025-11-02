import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../search_controller.dart' as search;

class SearchView extends GetView<search.SearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.put to ensure controller exists when accessed from bottom nav
    final ctrl = Get.put(search.SearchController());

    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: ctrl.searchController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'search_news'.tr,
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: ctrl.search,
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (ctrl.isSearching.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (ctrl.searchResults.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: ctrl.searchResults.length,
                  itemBuilder: (context, index) {
                    final article = ctrl.searchResults[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          article.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${article.content.substring(0, 50)}...',
                          maxLines: 2,
                        ),
                        onTap: () => ctrl.goToArticleDetail(article),
                      ),
                    );
                  },
                );
              }

              return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ctrl.recentSearches.isNotEmpty) ...[
                Text(
                  'recent_searches'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...ctrl.recentSearches.map((term) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.history_outlined, color: Colors.grey, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          term,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => ctrl.removeRecentSearch(term),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.close, size: 18, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 24),
              ],
              const Text(
                'Trending Topics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: [
                  _buildTrendingChip('#AI', ctrl),
                  _buildTrendingChip('#Technology', ctrl),
                  _buildTrendingChip('#Business', ctrl),
                  _buildTrendingChip('#Sports', ctrl),
                  _buildTrendingChip('#Health', ctrl),
                ],
              ),
            ],
          ),
        );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingChip(String tag, search.SearchController ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ctrl.searchController.text = tag.substring(1);
            ctrl.search(tag.substring(1));
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              tag,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}