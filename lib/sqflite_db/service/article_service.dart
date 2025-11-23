import 'package:newshub/sqflite_db/model/artical_model.dart';
import '../db_helper.dart';

class ArticleService {
  Future<int> insertArticle(ArticleModel article) async {
    final db = await DBHelper.initDb();
    return await db.insert('Articles', article.toMap());
  }

  // Future<List<ArticleModel>> getAllArticles() async {
  //   final db = await DBHelper.initDb();
  //   final data = await db.query('Articles');
  //   return data.map((e) => ArticleModel.fromMap(e)).toList();
  // }

  Future<List<ArticleModel>> getAllArticles() async {
    final db = await DBHelper.initDb();

    final result = await db.rawQuery('''
      SELECT A.*, U.name AS author_name
      FROM Articles A
      LEFT JOIN Users U ON A.author_id = U.user_id
      ORDER BY A.published_at DESC
    ''');

    return result.map((e) => ArticleModel.fromMap(e)).toList();
  }

  Future<int> updateArticle(ArticleModel article) async {
    final db = await DBHelper.initDb();
    return await db.update('Articles', article.toMap(),
        where: 'article_id=?', whereArgs: [article.articleId]);
  }

  Future<int> deleteArticle(int id) async {
    final db = await DBHelper.initDb();
    return await db.delete('Articles', where: 'article_id=?', whereArgs: [id]);
  }
}