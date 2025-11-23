import 'package:newshub/sqflite_db/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class LikeService {
  Future<int> addLike(int userId, int articleId) async {
    final db = await DBHelper.initDb();
    return await db.insert('Likes', {
      'user_id': userId,
      'article_id': articleId,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeLike(int userId, int articleId) async {
    final db = await DBHelper.initDb();
    await db.delete(
      'Likes',
      where: 'user_id = ? AND article_id = ?',
      whereArgs: [userId, articleId],
    );
  }

  Future<bool> isLiked(int userId, int articleId) async {
    final db = await DBHelper.initDb();
    final result = await db.query(
      'Likes',
      where: 'user_id = ? AND article_id = ?',
      whereArgs: [userId, articleId],
    );
    return result.isNotEmpty;
  }

  Future<int> countLikes(int articleId) async {
    final db = await DBHelper.initDb();
    final result = await db.rawQuery(
        'SELECT COUNT(*) as total FROM Likes WHERE article_id = ?',
        [articleId]);
    return Sqflite.firstIntValue(result) ?? 0;
  }
}