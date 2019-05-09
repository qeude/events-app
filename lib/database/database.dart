import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

final eventTABLE = 'Event';
class DatabaseProvider {
  static final DatabaseProvider dbProvider =  DatabaseProvider();

  Database _database;

  Future<Database> get database async{
    //deleteDb();
    _database = _database ?? await createDatabase();
    return _database;
  }

  deleteDb() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Event.db");
    await deleteDatabase(path);
  }

  createDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Event.db");
    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

   void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $eventTABLE ("
        "id STRING PRIMARY KEY, "
        "name TEXT,"
        "description TEXT,"
        "image TEXT,"
        "haslocation INTEGER,"
        "date TEXT"
        ")");
  }
}