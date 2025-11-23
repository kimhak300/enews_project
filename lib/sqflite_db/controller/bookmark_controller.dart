import 'package:get/get.dart';
import 'package:newshub/sqflite_db/model/bookmark_model.dart';
import 'package:newshub/sqflite_db/service/bookmark_service.dart';

class BookmarkController extends GetxController {
  var bookmarks = <BookmarkModel>[].obs;
  final BookmarkService _service = BookmarkService();

  @override
  void onInit() {
    super.onInit();
    fetchBookmarks();
  }

  void fetchBookmarks() async {
    bookmarks.value = await _service.getAllBookmarks();
  }

  void addBookmark(BookmarkModel bookmark) async {
    await _service.insertBookmark(bookmark);
    fetchBookmarks();
  }

  void deleteBookmark(int id) async {
    await _service.deleteBookmark(id);
    fetchBookmarks();
  }
}