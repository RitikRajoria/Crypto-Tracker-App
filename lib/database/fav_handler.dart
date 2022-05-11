import 'package:crypto_app_ui/models/favs.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class FavDBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'favs.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        """CREATE TABLE favs (id INTEGER PRIMARY KEY AUTOINCREMENT, uuid TEXT NOT NULL UNIQUE)""");
  }

  Future<FavsModel> insert(FavsModel favsModel) async {
    var dbClients = await db;
    await dbClients!.insert('favs', favsModel.toMap());
    return favsModel;
  }

  Future<List<FavsModel>> getFavsList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('favs');

    return queryResult.map((e) => FavsModel.fromMap(e)).toList();
  }

  Future<int> delete(String uuid) async {
    var dbClient = await db;
    return await dbClient!.delete('favs', where: 'uuid = ?', whereArgs: [uuid]);
  }

  Future deleteEntries() async {
    var dbClient = await db;
    var deleteEntry = await dbClient!.rawQuery('''DELETE FROM favs''');
    print("entries deleted");
    return deleteEntry;
  }

  Future<bool> uuidExists(String uuid) async {
    var dbClient = await db;
    var result = await dbClient!.rawQuery(
        '''SELECT EXISTS(SELECT * FROM favs WHERE uuid = "$uuid") ''');
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }
}
