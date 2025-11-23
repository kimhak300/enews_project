import 'package:newshub/sqflite_db/model/history_model.dart';
import '../db_helper.dart';

class HistoryService {
  Future<int> insertHistory(HistoryModel history) async {
    final db = await DBHelper.initDb();
    return await db.insert('History', history.toMap());
  }

  Future<List<HistoryModel>> getAllHistory() async {
    final db = await DBHelper.initDb();
    final data = await db.query('History');
    return data.map((e) => HistoryModel.fromMap(e)).toList();
  }

  Future<List<HistoryModel>> getHistoryByUser(int userId) async {
    final db = await DBHelper.initDb();
    final data =
    await db.query('History', where: 'user_id=?', whereArgs: [userId]);
    return data.map((e) => HistoryModel.fromMap(e)).toList();
  }
}