import 'package:newshub/sqflite_db/db_helper.dart';
import '../model/user_model.dart';

class UserService {

  Future<int> insertUser(UserModel user) async {
    final db = await DBHelper.initDb();
    int id = await db.insert('Users', user.toMap());
    user.userId = id; // <-- assign the ID to your model
    return id;
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await DBHelper.initDb();
    final List<Map<String, dynamic>> maps = await db.query('Users');
    return List.generate(maps.length, (i) => UserModel.fromMap(maps[i]));
  }

  Future<int> updateUser(UserModel user) async {
    final db = await DBHelper.initDb();
    return await db.update('Users', user.toMap(), where: 'user_id=?', whereArgs: [user.userId]);
  }

  Future<int> deleteUser(int id) async {
    final db = await DBHelper.initDb();
    return await db.delete('Users', where: 'user_id=?', whereArgs: [id]);
  }
}