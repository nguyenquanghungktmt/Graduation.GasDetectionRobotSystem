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
    serial_number varchar(15) );
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

  static Future<Database> getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async {
      print("crate database");
      await db.execute(_queryCreateUser);
      // await db.execute(_queryCreateRoom);
    }, version: _version);
  }

  static Future<void> deleteDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _dbName);

    // Delete the database
    await deleteDatabase(path);
  }
}
