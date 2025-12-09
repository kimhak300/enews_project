import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';
import 'package:newshub/data/models/article_model.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Loading states
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final isRefreshing = false.obs;
  final errorMessage = ''.obs;

  // Pagination
  int currentPage = 1;
  bool hasMore = true;

  // Articles list
  final RxList<ArticleModel> articles = <ArticleModel>[].obs;
  final RxList<ArticleModel> trendingArticles = <ArticleModel>[].obs;

  // Categories
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final selectedCategory = Rxn<CategoryModel>();

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    isLoading.value = true;
    await Future.wait([
      fetchArticles(),
      fetchCategories(),
    ]);
    isLoading.value = false;
  }

  Future<void> fetchArticles({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      hasMore = true;
      articles.clear();
      isRefreshing.value = true;
    }

    if (!hasMore && !refresh) return;

    if (currentPage > 1) {
      isLoadingMore.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await _apiService.getArticles(page: currentPage, type: 'article');

      if (response.isSuccess) {
        // Handle different response formats
        List data = [];
        if (response.data is List) {
          data = response.data as List;
        } else if (response.data is Map) {
          if (response.data['data'] is List) {
            data = response.data['data'] as List;
          } else if (response.data['articles'] is List) {
            data = response.data['articles'] as List;
          }
        }

        final newArticles =
            data.map((json) => ArticleModel.fromJson(json)).toList();

        if (newArticles.isEmpty) {
          hasMore = false;
        } else {
          articles.addAll(newArticles);
          currentPage++;

          // Set first 5 as trending (if first load)
          if (trendingArticles.isEmpty && newArticles.length >= 3) {
            trendingArticles.assignAll(newArticles.take(5).toList());
          }
        }
      } else {
        errorMessage.value = response.error ?? 'Failed to load articles';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoadingMore.value = false;
      isRefreshing.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await _apiService.getCategories();
      if (response.isSuccess) {
        // Handle different response formats
        List data;
        if (response.data is List) {
          data = response.data;
        } else if (response.data['data'] != null) {
          data = response.data['data'] as List;
        } else if (response.data['categories'] != null) {
          data = response.data['categories'] as List;
        } else if (response.data['value'] != null) {
          data = response.data['value'] as List;
        } else {
          data = [];
        }
        categories.assignAll(
          data.map((json) => CategoryModel.fromJson(json)).toList(),
        );
      }
    } catch (e) {
      // Silent fail for categories
    }
  }

  void loadMore() {
    if (!isLoadingMore.value && hasMore) {
      fetchArticles();
    }
  }

  Future<void> refresh() async {
    await fetchArticles(refresh: true);
  }

  void selectCategory(CategoryModel? category) {
    selectedCategory.value = category;
    // Could filter articles by category here
  }

  List<ArticleModel> get filteredArticles {
    if (selectedCategory.value == null) return articles;
    final sel = selectedCategory.value!;
    final selName = sel.name.toLowerCase();
    return articles.where((article) {
      if (article.categories == null) return false;
      return article.categories!.any((c) {
        final sameId = c.id == sel.id && sel.id != 0;
        final sameName = c.name.toLowerCase() == selName;
        return sameId || sameName;
      });
    }).toList();
  }
}