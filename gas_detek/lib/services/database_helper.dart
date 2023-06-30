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
    device_serial_number varchar(15),
    avatar_url varchar(50) );
  ''';

  static const String _queryCreateRoom = '''
  create table room (
	  room_id varchar(36) primary key not null,
    room_name varchar(100),
    owner_uuid varchar(36) not null,
    is_gas_detect int,
    room_status varchar(100),
    map2d_url varchar(50));
  ''';

  static const String _queryCreateDevice = '''
  create table device (
	  serial_number varchar(15) primary key not null,
	  module_id varchar(15),
    model_name varchar(100),
    image_url varchar(50),
    device_status varchar(100),
    description text );
  ''';

  static Future<Database> getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async {
      print("create database");
      await db.execute(_queryCreateUser);
      await db.execute(_queryCreateRoom);
      await db.execute(_queryCreateDevice);
    }, version: _version);
  }

  static Future<void> deleteDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _dbName);

    // Delete the database
    await deleteDatabase(path);
  }
}
