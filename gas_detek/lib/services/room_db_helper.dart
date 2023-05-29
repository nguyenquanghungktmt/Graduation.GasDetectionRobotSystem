import 'package:gas_detek/model/room_model.dart';
import 'package:sqflite/sql.dart';

import 'database_helper.dart';

extension RoomDBHelper on DatabaseHelper {
  static Future<int> addRoom(Room room) async {
    final db = await DatabaseHelper.getDB();
    return await db.insert("Room", room.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateRoom(Room room) async {
    final db = await DatabaseHelper.getDB();
    return await db.update("Room", room.toJson(),
        where: 'room_id = ?',
        whereArgs: [room.roomId],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteRoom(Room room) async {
    final db = await DatabaseHelper.getDB();
    return await db.delete(
      "Room",
      where: 'room_id = ?',
      whereArgs: [room.roomId],
    );
  }

  static Future<int> deleteAllRooms() async {
    final db = await DatabaseHelper.getDB();
    return await db.delete("Room");
  }

  static Future<List<Room>?> getAllRooms() async {
    final db = await DatabaseHelper.getDB();
    final List<Map<String, dynamic>> records = await db.query("Room");

    if (records.isEmpty) {
      return null;
    }

    return List.generate(records.length, (index) => Room.fromJson(records[index]));
  }
}