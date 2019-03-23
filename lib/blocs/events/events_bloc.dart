
import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:events_app/repository/event_repository.dart';
import 'events.dart';
import 'package:events_app/models/models.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState>{
  final _eventRepository = EventRepository();

  getEvents({String query}) async {
    return await _eventRepository.getAllEvents(query: query);
  }
  
  @override
  EventsState get initialState => EventsStateEmpty();

  @override
  Stream<EventsState> mapEventToState(EventsState currentState, EventsEvent event) async* {
    if(event is FetchEvents){
      yield* _mapLoadEventsToState();
    }else if(event is AddEvent){
      yield* _mapAddEventToState(currentState, event);
    }else if(event is DeleteEvent){
      yield* _mapDeleteEventToState(currentState, event);
    }else if(event is UpdateEvent){
      yield* _mapUpdateEventToState(currentState, event);
    }
  }

  Stream<EventsState> _mapLoadEventsToState() async*{
    yield EventsStateLoading();
      try{
        final List<Event> events = await getEvents();
        if(events.isEmpty){
          yield EventsStateEmpty();
        }
        else{
          yield EventsStatePopulated(events);
        }
      }catch(error){
        yield EventsStateError(error.toString());
      }
  }

  Stream<EventsState> _mapAddEventToState(EventsState currentState, AddEvent event) async*{
     if(currentState is EventsStatePopulated){
        final List<Event> updatedEvents = List.from(currentState.events)..add(event.event);
        yield EventsStatePopulated(updatedEvents);
        _eventRepository.insertEvent(event.event);
      }
  }

  Stream<EventsState> _mapDeleteEventToState(EventsState currentState, DeleteEvent event) async*{
    if(currentState is EventsStatePopulated){
      final updateEvents = currentState.events.where((elmt) => elmt.id != event.event.id).toList();
      yield EventsStatePopulated(updateEvents);
      _eventRepository.deleteEventByid(event.event.id);
    }
  }

  Stream<EventsState> _mapUpdateEventToState(EventsState currentState, UpdateEvent event) async* {
    if(currentState is EventsStatePopulated){
      final updateEvents = currentState.events.map((elmt){
        return elmt.id == event.updatedEvent.id ? event.updatedEvent : elmt;
      }).toList();
      yield EventsStatePopulated(updateEvents);
      _eventRepository.updateEvent(event.updatedEvent); 
    }
  }
}