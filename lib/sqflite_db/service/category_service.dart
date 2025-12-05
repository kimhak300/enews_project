import '../db_helper.dart';
import '../model/category_model.dart';

class CategoryService {
  Future<int> insertCategory(CategoryModel category) async {
    final db = await DBHelper.initDb();
    return await db.insert('Categories', category.toMap());
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final db = await DBHelper.initDb();
    final data = await db.query('Categories');
    return data.map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<int> updateCategory(CategoryModel category) async {
    final db = await DBHelper.initDb();
    return await db.update('Categories', category.toMap(),
        where: 'category_id=?', whereArgs: [category.categoryId]);
  }

  Future<int> deleteCategory(int id) async {
    final db = await DBHelper.initDb();
    return await db.delete('Categories', where: 'category_id=?', whereArgs: [id]);
  }
}