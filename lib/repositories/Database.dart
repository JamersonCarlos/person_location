import 'package:geocoding/geocoding.dart';
import 'package:latlng/latlng.dart';
import 'package:personal_location/models/locationModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DBprovider {
  DBprovider._();
  static final DBprovider db = DBprovider._();

  //Instânica do SQLite
  Database? _database;

  Future get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final dpath = await getDatabasesPath();
    final path = join(dpath, "locations.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: ((db, version) async {
        await db.execute(
            "CREATE TABLE PersonLocations (nomeMarcador text, latitude real, longitude real)");
      }),
    );
  }

  Future postLocation(LocationModel location) async {
    try {
      Database db = await database;

      await db.insert(
        "PersonLocations",
        location.toMap(),
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> AllLocations() async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> maps = await db.query("PersonLocations");
      return maps;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future deletAllLocations() async {
    try {
      Database db = await database;
      return await db.rawDelete("delete from PersonLocations");
    } catch (e) {
      print(e);
    }
  }
}
