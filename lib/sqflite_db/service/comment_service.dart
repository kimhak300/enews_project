import 'package:newshub/sqflite_db/model/comment_model.dart';
import '../db_helper.dart';

class CommentService {
  Future<int> insertComment(CommentModel comment) async {
    final db = await DBHelper.initDb();
    return await db.insert('Comments', comment.toMap());
  }

  Future<List<CommentModel>> getAllComments() async {
    final db = await DBHelper.initDb();
    final data = await db.query('Comments');
    return data.map((e) => CommentModel.fromMap(e)).toList();
  }

  Future<int> deleteComment(int id) async {
    final db = await DBHelper.initDb();
    return await db.delete('Comments', where: 'comment_id=?', whereArgs: [id]);
  }
}