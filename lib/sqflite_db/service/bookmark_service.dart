import 'package:newshub/sqflite_db/model/bookmark_model.dart';
import '../db_helper.dart';

class BookmarkService {
  Future<int> insertBookmark(BookmarkModel bookmark) async {
    final db = await DBHelper.initDb();
    return await db.insert('Bookmarks', bookmark.toMap());
  }

  Future<List<BookmarkModel>> getAllBookmarks() async {
    final db = await DBHelper.initDb();
    final data = await db.query('Bookmarks');
    return data.map((e) => BookmarkModel.fromMap(e)).toList();
  }

  Future<int> deleteBookmark(int id) async {
    final db = await DBHelper.initDb();
    return await db.delete('Bookmarks', where: 'bookmark_id=?', whereArgs: [id]);
  }
}