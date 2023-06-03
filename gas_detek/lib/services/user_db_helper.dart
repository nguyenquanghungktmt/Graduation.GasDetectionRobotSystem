import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';
import 'package:gas_detek/model/user_model.dart';

extension UserDBHelper on DatabaseHelper {
  static Future<int> addUser(User user) async {
    final db = await DatabaseHelper.getDB();
    return await db.insert("User", user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateUser(User user) async {
    final db = await DatabaseHelper.getDB();
    return await db.update("User", user.toJson(),
        where: 'uuid = ?',
        whereArgs: [user.uuid],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteUser(User user) async {
    final db = await DatabaseHelper.getDB();
    return await db.delete(
      "User",
      where: 'uuid = ?',
      whereArgs: [user.uuid],
    );
  }

  static Future<User?> getUser(String uuid) async {
    final db = await DatabaseHelper.getDB();

    final List<Map<String, dynamic>> records = await db.query(
      "User",
      where: 'uuid = ?',
      whereArgs: [uuid],
    );

    if (records.isEmpty) {
      return null;
    }

    return User.fromJson(records[0]);
  }
}