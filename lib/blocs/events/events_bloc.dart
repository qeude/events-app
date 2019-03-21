
import 'package:bloc/bloc.dart';

import 'events.dart';
import 'package:events_app/models/models.dart';
import 'get_events.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState>{

  void onAdd(){
    dispatch(AddEvent());
  }

  void onDelete(){
    dispatch(DeleteEvent());
  }

  void onUpdate(){
    dispatch(UpdateEvent());
  }

  @override
  EventsState get initialState => EventsStateEmpty();

  @override
  Stream<EventsState> mapEventToState(EventsState currentState, EventsEvent event) async* {
    if(event is FetchEvents){
      yield EventsStateLoading();
      try{
        final List<Event> events = GetEvents().fetchEvents();
        print(events);
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
  }
}