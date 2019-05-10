import 'package:events_app/repository/event_repository.dart';
import 'package:events_app/models/models.dart';
import 'package:events_app/blocs/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart';
import 'package:events_app/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class EventsBloc extends BlocBase {
  List<Event> events = [];
  final _eventRepository = EventRepository();
  final _eventsFetcher = PublishSubject<List<Event>>();
  final _eventDetails = PublishSubject<Event>();

  Observable<List<Event>> get allEvents => _eventsFetcher.stream;
  Observable<Event> get eventDetails => _eventDetails.stream;

  getEvents({String query}) async {
    return await _eventRepository.getAllEvents(query: query);
  }

  getEventById(String id) async {
    Event event = await _eventRepository.getEventById(id);
    _eventDetails.sink.add(event);
  }

  void fetchAllEvents() async {
    events = await getEvents();
    _eventsFetcher.sink.add(events);
  }

  void addEvent(Event newEvent) {
    final List<Event> updatedEvents = List.from(events)..add(newEvent);
    _eventRepository.insertEvent(newEvent);
    _eventsFetcher.sink.add(updatedEvents);
  }

  void deleteEvent(Event eventToDelete) async {
    final updateEvents =
        events.where((elmt) => elmt.id != eventToDelete.id).toList();
    await deleteImage(eventToDelete.image);
    _eventRepository.deleteEventByid(eventToDelete.id);
    _eventsFetcher.sink.add(updateEvents);
  }

  void deleteAllEvents() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    appDirectory.deleteSync(recursive: true);
    _eventRepository.deleteAllEvents();
    _eventsFetcher.sink.add([]);
  }

  void updateEvent(Event updatedEvent) async {
    final oldEvent = events.firstWhere((elmt) => elmt.id == updatedEvent.id);
    final updateEvents = events.map((elmt) {
      return elmt.id == updatedEvent.id ? updatedEvent : elmt;
    }).toList();
    if (oldEvent.image != updatedEvent.image) await deleteImage(oldEvent.image);
    _eventRepository.updateEvent(updatedEvent);
    _eventsFetcher.sink.add(updateEvents);
  }

  @override
  void dispose() {
    _eventsFetcher?.close();
    _eventDetails?.close();
  }
}
