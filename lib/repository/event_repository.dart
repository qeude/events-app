import 'package:events_app/dao/event_dao.dart';
import 'package:events_app/models/models.dart';

class EventRepository{
  final eventDao = EventDao();


  Future getAllEvents({String query}) => eventDao.getEvents(query: query);

  Future getEventById(String id) => eventDao.getEventById(id);
  
  Future insertEvent(Event event) => eventDao.createEvent(event);

  Future updateEvent(Event event) => eventDao.updateEvent(event);

  Future deleteEventByid(String id) => eventDao.deleteEvent(id);

  Future deleteAllEvents() => eventDao.deleteAllEvents();
  
}