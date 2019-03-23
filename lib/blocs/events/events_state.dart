
import 'package:events_app/models/models.dart';

class EventsState {
  EventsState();
}

class EventsStateLoading extends EventsState {}

class EventsStatePopulated extends EventsState{
  final List<Event> events;
  EventsStatePopulated(this.events);
}

class EventsStateError extends EventsState{
  final String error;

  EventsStateError(this.error);
}

class EventsStateEmpty extends EventsState{}
