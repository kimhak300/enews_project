import 'package:newshub/sqflite_db/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class FollowService {

  /// Follow an author
  Future<int> follow(int followerId, int followingId) async {
    final db = await DBHelper.initDb();
    return await db.insert('Follows', {
      'follower_id': followerId,
      'following_id': followingId,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Unfollow an author
  Future<void> unfollow(int followerId, int followingId) async {
    final db = await DBHelper.initDb();
    await db.delete(
      'Follows',
      where: 'follower_id = ? AND following_id = ?',
      whereArgs: [followerId, followingId],
    );
  }

  /// Check if a user is following an author
  Future<bool> isFollowing(int followerId, int followingId) async {
    final db = await DBHelper.initDb();
    final result = await db.query(
      'Follows',
      where: 'follower_id = ? AND following_id = ?',
      whereArgs: [followerId, followingId],
    );
    return result.isNotEmpty;
  }

  /// Get all authors that a user is following
  Future<List<int>> getFollowingAuthors(int followerId) async {
    final db = await DBHelper.initDb();
    final result = await db.query(
      'Follows',
      columns: ['following_id'],
      where: 'follower_id = ?',
      whereArgs: [followerId],
    );
    return result.map((e) => e['following_id'] as int).toList();
  }

  /// Count total followers of an author
  Future<int> countFollowers(int authorId) async {
    final db = await DBHelper.initDb();
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM Follows WHERE following_id = ?',
      [authorId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}