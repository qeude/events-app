import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:events_app/blocs/events/events.dart';
import 'events_list.dart';
class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  EventsBloc eventsBloc;

  @override
  void initState() {
    super.initState();
    eventsBloc = EventsBloc();
    eventsBloc.dispatch(FetchEvents());
  }

  @override
  void dispose() {
    super.dispose();
    eventsBloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test')
      ),
      body: BlocBuilder(
        bloc: eventsBloc,
        builder: (context, EventsState state){
          return Column(children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  EventsList(
                    eventsList: state is EventsStatePopulated ? state.events : [],
                  ),
                ],
              ),
            )
          ],);
        },
      ),
      
    );
  }
}