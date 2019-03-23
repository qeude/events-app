import 'package:equatable/equatable.dart';
import 'package:events_app/models/models.dart';

abstract class EventsEvent extends Equatable {
  EventsEvent([List props = const []]) : super(props);
}

class FetchEvents extends EventsEvent {}

class AddEvent extends EventsEvent {
  final Event event;

  AddEvent(this.event) : super([event]);

  @override
  String toString() => 'AddEvent { event:$event }';
}

class DeleteEvent extends EventsEvent {
  final Event event;

  DeleteEvent(this.event) : super([event]);

  @override
  String toString() => 'DeleteEvent { event: $event }';
}

class UpdateEvent extends EventsEvent {
  final Event updatedEvent;

  UpdateEvent(this.updatedEvent) : super([updatedEvent]);
  @override
  String toString() => 'UpdateEvent { event:$updatedEvent }';
}
