import 'package:gas_detek/model/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "gas_detekt.db";

  static const String _queryCreateUser = '''
  create table user (
	uuid varchar(36) primary key not null,
    username varchar(100),
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100),
    avatar_url varchar(50),
    device_serial_number varchar(15) );
  ''';

  static const String _queryCreateRoom = '''
  create table room (
	room_id varchar(36) primary key not null,
    room_name varchar(100),
    owner_uuid varchar(36) not null,
    is_gas_detect boolean,
    room_status varchar(100),
    map2d_url varchar(50),
    created_time datetime,
    modified_time datetime);
  ''';

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
    onCreate: (db, version) async {
      await db.execute(_queryCreateUser);
      // await db.execute(_queryCreateRoom);
    }, version: _version);
  }

  static Future<int> addUser(User user) async {
    final db = await _getDB();
    return await db.insert("User", user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateNote(User user) async {
    final db = await _getDB();
    return await db.update("User", user.toJson(),
        where: 'uuid = ?',
        whereArgs: [user.uuid],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteNote(User user) async {
    final db = await _getDB();
    return await db.delete(
      "User",
      where: 'uuid = ?',
      whereArgs: [user.uuid],
    );
  }

  static Future<User?> getUser(String uuid) async {
    final db = await _getDB();

    final List<Map<String, dynamic>> records = await db.query(
      "Note",
      where: 'uuid = ?',
      whereArgs: [uuid],
    );

    if (records.isEmpty) {
      return null;
    }

    return User.fromJson(records[0]);
  }
}
