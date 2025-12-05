import 'package:newshub/sqflite_db/db_helper.dart';
import '../model/user_model.dart';

class UserService {
  Future<int> insertUser(UserModel user) async {
    final db = await DBHelper.initDb();
    int id = await db.insert('Users', user.toMap());
    user.userId = id;
    return id;
  }

  Future<UserModel?> getUserById(int id) async {
    final db = await DBHelper.initDb();
    final maps = await db.query('Users', where: 'user_id=?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(UserModel user) async {
    final db = await DBHelper.initDb();
    return await db.update(
      'Users',
      user.toMap(),
      where: 'user_id=?',
      whereArgs: [user.userId],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await DBHelper.initDb();
    return await db.delete('Users', where: 'user_id=?', whereArgs: [id]);
  }
}