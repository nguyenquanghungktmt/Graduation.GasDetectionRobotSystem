import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';
import 'package:gas_detek/model/device_model.dart';

extension DeviceDBHelper on DatabaseHelper {
  static Future<int> addDevice(Device device) async {
    final db = await DatabaseHelper.getDB();
    return await db.insert("Device", device.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateDevice(Device device) async {
    final db = await DatabaseHelper.getDB();
    return await db.update("Device", device.toJson(),
        where: 'serial_number = ?',
        whereArgs: [device.serialNumber],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteDevice(Device Device) async {
    final db = await DatabaseHelper.getDB();
    return await db.delete(
      "Device",
      where: 'serial_number = ?',
      whereArgs: [Device.serialNumber],
    );
  }

  static Future<Device?> getDevice(String serialNumber) async {
    final db = await DatabaseHelper.getDB();

    final List<Map<String, dynamic>> records = await db.query(
      "Device",
      where: 'serial_number = ?',
      whereArgs: [serialNumber],
    );

    if (records.isEmpty) {
      return null;
    }

    return Device.fromJson(records[0]);
  }
}