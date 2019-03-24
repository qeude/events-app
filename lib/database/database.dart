import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:events_app/models/models.dart';

final eventTABLE = 'Event';
class DatabaseProvider {
  static final DatabaseProvider dbProvider =  DatabaseProvider();

  Database _database;

  Future<Database> get database async{
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
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
        "date TEXT,"
        "complete INTEGER "
        ")");
    await database.insert(eventTABLE, Event('Croatie', DateTime(2019, 06, 12)).toDatabaseJson());
    await database.insert(eventTABLE, Event('Suisse', DateTime(2019, 07, 13)).toDatabaseJson());
    await database.insert(eventTABLE, Event('Italie', DateTime(2019, 04, 22)).toDatabaseJson());
    await database.insert(eventTABLE, Event('Croatie', DateTime(2019, 06, 12)).toDatabaseJson());
    await database.insert(eventTABLE, Event('Suisse', DateTime(2019, 07, 13)).toDatabaseJson());
    await database.insert(eventTABLE, Event('Italie', DateTime(2019, 04, 22)).toDatabaseJson());
    await database.insert(eventTABLE, Event('Croatie', DateTime(2019, 06, 12)).toDatabaseJson());
    await database.insert(eventTABLE, Event('Suisse', DateTime(2019, 07, 13)).toDatabaseJson());
    await database.insert(eventTABLE, Event('Italie', DateTime(2019, 04, 22)).toDatabaseJson());
    await database.insert(eventTABLE, Event('Croatie', DateTime(2019, 06, 12)).toDatabaseJson());
    await database.insert(eventTABLE, Event('Suisse', DateTime(2019, 07, 13)).toDatabaseJson());
    await database.insert(eventTABLE, Event('Italie', DateTime(2019, 04, 22)).toDatabaseJson());



  }
}