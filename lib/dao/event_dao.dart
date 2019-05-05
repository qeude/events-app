import 'package:events_app/database/database.dart';
import 'package:events_app/models/models.dart';

class EventDao{
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> createEvent(Event event) async{
    final db = await dbProvider.database;
    var result = db.insert(eventTABLE, event.toDatabaseJson());
    return result;
  }
  Future<Event> getEventById(String id, {List<String> columns}) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    result = await db.query(eventTABLE,
      columns: columns,
      where: 'id = ?',
      whereArgs: [id],
    );
    Event event = result.isNotEmpty
      ? Event.fromDatabaseJson(result[0])
      : null;
    return event;
  }

  Future<List<Event>> getEvents({List<String> columns, String query}) async{
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    if(query != null){
      if(query.isNotEmpty){
        result= await db.query(eventTABLE, 
          columns: columns,
          where: 'name LIKE ?',
          whereArgs: ["%query%"],
          orderBy: 'date'
        );
      }
    }
    else {
        result = await db.query(eventTABLE, columns: columns, orderBy: 'date');
    }
    List<Event> events = result.isNotEmpty
      ? result.map((item) => Event.fromDatabaseJson(item)).toList()
      : [];
    return events;
  }
  Future<int> updateEvent(Event event) async {
    final db = await dbProvider.database;

    var result = await db.update(eventTABLE, event.toDatabaseJson(),
        where: "id = ?", whereArgs: [event.id]);

    return result;
  }

  Future<int> deleteEvent(String id) async {
    final db = await dbProvider.database;
    var result = await db.delete(eventTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

   Future deleteAllEvents() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      eventTABLE,
    );

    return result;
  }
}
