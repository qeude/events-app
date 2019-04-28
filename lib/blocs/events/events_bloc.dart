import 'package:events_app/repository/event_repository.dart';
import 'package:events_app/models/models.dart';
import 'package:events_app/blocs/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class EventsBloc extends BlocBase{
  List<Event> events = [];
  final _eventRepository = EventRepository();
  final _eventsFetcher = PublishSubject<List<Event>>();
  final _eventDetails = PublishSubject<Event>();

  Observable<List<Event>> get allEvents => _eventsFetcher.stream;
  Observable<Event> get eventDetails => _eventDetails.stream;

  getEvents({String query}) async {
    return await _eventRepository.getAllEvents(query: query);
  }

  getEventById(String id) async{
    List<Event> events =  await _eventRepository.getAllEvents();
    Event event = events.firstWhere((elmt) => elmt.id == id, orElse:() => null);
    _eventDetails.sink.add(event);
    return event;
  }

  void fetchAllEvents() async{
    List<Event> events =  await getEvents();
    _eventsFetcher.sink.add(events);
  }

  void addEvent(Event newEvent){
      final List<Event> updatedEvents = List.from(events)..add(newEvent);
      _eventRepository.insertEvent(newEvent);
      _eventsFetcher.sink.add(updatedEvents);
  }

  void deleteEvent(Event eventToDelete){
      final updateEvents = events.where((elmt) => elmt.id != eventToDelete.id).toList();
      _eventRepository.deleteEventByid(eventToDelete.id);
      _eventsFetcher.sink.add(updateEvents);

  }

  void updateEvent(Event updatedEvent){
      final updateEvents = events.map((elmt){       
        return elmt.id == updatedEvent.id ? updatedEvent : elmt;}).toList();
      _eventRepository.updateEvent(updatedEvent); 
      _eventsFetcher.sink.add(updateEvents);


  }

  @override
  void dispose() {
    _eventsFetcher?.close();
  }
  
  // @override
  // EventsState get initialState => EventsStateEmpty();

  // @override
  // Stream<EventsState> mapEventToState(EventsState currentState, EventsEvent event) async* {
  //   if(event is FetchEvents){
  //     yield* _mapLoadEventsToState();
  //   }else if(event is AddEvent){
  //     yield* _mapAddEventToState(currentState, event);
  //   }else if(event is DeleteEvent){
  //     yield* _mapDeleteEventToState(currentState, event);
  //   }else if(event is UpdateEvent){
  //     yield* _mapUpdateEventToState(currentState, event);
  //   }
  // }

  // Stream<EventsState> _mapLoadEventsToState() async*{
  //   yield EventsStateLoading();
  //     try{
  //       final List<Event> events = await getEvents();
  //       if(events.isEmpty){
  //         yield EventsStateEmpty();
  //       }
  //       else{
  //         yield EventsStatePopulated(events);
  //       }
  //     }catch(error){
  //       yield EventsStateError(error.toString());
  //     }
  // }

  // Stream<EventsState> _mapAddEventToState(EventsState currentState, AddEvent event) async*{
  //    if(currentState is EventsStatePopulated){
  //       final List<Event> updatedEvents = List.from(currentState.events)..add(event.event);
  //       yield EventsStatePopulated(updatedEvents);
  //       _eventRepository.insertEvent(event.event);
  //     }
  // }

  // Stream<EventsState> _mapDeleteEventToState(EventsState currentState, DeleteEvent event) async*{
  //   if(currentState is EventsStatePopulated){
  //     final updateEvents = currentState.events.where((elmt) => elmt.id != event.event.id).toList();
  //     yield EventsStatePopulated(updateEvents);
  //     _eventRepository.deleteEventByid(event.event.id);
  //   }
  // }

  // Stream<EventsState> _mapUpdateEventToState(EventsState currentState, UpdateEvent event) async* {
  //   if(currentState is EventsStatePopulated){
  //     final updateEvents = currentState.events.map((elmt){
  //       return elmt.id == event.updatedEvent.id ? event.updatedEvent : elmt;
  //     }).toList();
  //     yield EventsStatePopulated(updateEvents);
  //     _eventRepository.updateEvent(event.updatedEvent); 
  //   }
  // }
}