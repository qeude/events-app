import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:events_app/blocs/events/events.dart';
import 'package:events_app/widgets/events_list.dart';
import 'package:events_app/widgets/loading_indicator.dart';
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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Events', style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.black,),
            onPressed: () => false,
          )
        ],
      ),
      body: BlocBuilder(
        bloc: eventsBloc,
        builder: (context, EventsState state){
          return Column(children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  LoadingIndicatorWidget(
                    visible: state is EventsStateLoading,
                  ),
                  EventsList(
                    visible: state is EventsStatePopulated,
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