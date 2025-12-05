import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/bookmark_model.dart';
import '../service/bookmark_service.dart';

class BookmarkController extends GetxController {
  final BookmarkService _service = BookmarkService();

  var bookmarks = <BookmarkModel>[].obs;               // User's bookmarks
  var articleBookmarked = <int, bool>{}.obs;          // articleId -> bookmarked
  var bookmarkCount = <int, RxInt>{}.obs;             // articleId -> total bookmarks

  int currentUserId = 0;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getInt('userId') ?? 0;
    if (currentUserId != 0) {
      await _loadUserBookmarks();
    }
  }

  Future<void> _loadUserBookmarks() async {
    if (currentUserId == 0) return;

    final userBookmarks = await _service.getUserBookmarks(currentUserId);
    bookmarks.assignAll(userBookmarks);

    for (var b in userBookmarks) {
      articleBookmarked[b.articleId] = true;

      final count = await _service.getBookmarkCount(b.articleId);
      bookmarkCount[b.articleId] = count.obs;
    }
  }

  Future<void> toggleBookmark(int articleId) async {
    if (currentUserId == 0) return;

    bool isSaved = await _service.isBookmarked(currentUserId, articleId);

    if (isSaved) {
      await _service.deleteBookmarkByArticle(currentUserId, articleId);
      articleBookmarked[articleId] = false;
    } else {
      await _service.insertBookmark(
        BookmarkModel(
          userId: currentUserId,
          articleId: articleId,
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
      articleBookmarked[articleId] = true;
    }

    // Refresh bookmark count reactively
    final count = await _service.getBookmarkCount(articleId);
    if (bookmarkCount[articleId] != null) {
      bookmarkCount[articleId]!.value = count;
    } else {
      bookmarkCount[articleId] = count.obs;
    }
  }

  bool isBookmarked(int articleId) => articleBookmarked[articleId] ?? false;

  RxInt getBookmarkCountRx(int articleId) {
    if (bookmarkCount[articleId] == null) {
      bookmarkCount[articleId] = 0.obs;
    }
    return bookmarkCount[articleId]!;
  }
}