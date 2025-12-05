import '../db_helper.dart';
import '../model/bookmark_model.dart';

class BookmarkService {
  Future<int> insertBookmark(BookmarkModel bookmark) async {
    final db = await DBHelper.initDb();
    return await db.insert('Bookmarks', bookmark.toMap());
  }

  Future<int> deleteBookmarkByArticle(int userId, int articleId) async {
    final db = await DBHelper.initDb();
    return await db.delete(
      'Bookmarks',
      where: 'user_id=? AND article_id=?',
      whereArgs: [userId, articleId],
    );
  }

  Future<bool> isBookmarked(int userId, int articleId) async {
    final db = await DBHelper.initDb();
    final data = await db.query(
      'Bookmarks',
      where: 'user_id=? AND article_id=?',
      whereArgs: [userId, articleId],
    );
    return data.isNotEmpty;
  }

  Future<int> getBookmarkCount(int articleId) async {
    final db = await DBHelper.initDb();
    final data = await db.query(
      'Bookmarks',
      where: 'article_id=?',
      whereArgs: [articleId],
    );
    return data.length;
  }

  Future<List<BookmarkModel>> getUserBookmarks(int userId) async {
    final db = await DBHelper.initDb();
    final data = await db.query(
      'Bookmarks',
      where: 'user_id=?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return data.map((e) => BookmarkModel.fromMap(e)).toList();
  }
}