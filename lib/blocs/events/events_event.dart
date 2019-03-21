
import 'package:events_app/models/models.dart';

abstract class EventsEvent{
  EventsEvent();
}


class FetchEvents extends EventsEvent{}
class AddEvent extends EventsEvent {}
class DeleteEvent extends EventsEvent {}
class UpdateEvent extends EventsEvent {}