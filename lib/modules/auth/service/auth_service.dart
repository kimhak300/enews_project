import 'package:newshub/sqflite_db/db_helper.dart';
import 'package:newshub/sqflite_db/model/user_model.dart';

class AuthService {

  /// Login
  Future<UserModel?> login(String email, String password) async {
    final db = await DBHelper.initDb();
    final result = await db.query(
      'Users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) return UserModel.fromMap(result.first);
    return null;
  }

  /// Insert new user
  Future<int> insertUser(UserModel user) async {
    final db = await DBHelper.initDb();
    return await db.insert('Users', user.toMap());
  }

  /// Check if email exists
  Future<UserModel?> getUserByEmail(String email) async {
    final db = await DBHelper.initDb();
    final result = await db.query(
      'Users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) return UserModel.fromMap(result.first);
    return null;
  }
}