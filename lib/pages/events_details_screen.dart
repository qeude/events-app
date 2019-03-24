import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:events_app/blocs/events/events.dart';
import 'package:events_app/models/models.dart';
class EventsDetailsScreen extends StatelessWidget {
  final String id;

  EventsDetailsScreen({@required this.id});

  @override
  Widget build(BuildContext context) {
    final eventBloc = BlocProvider.of<EventsBloc>(context);
    return BlocBuilder(
      bloc: eventBloc,
      builder: (context, EventsState state){
        print(state);
        final event = (state as EventsStatePopulated)
          .events
          .firstWhere((elmt) => elmt.id == id, orElse: () => null);
        return Scaffold(
          appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(event.name, style: TextStyle(color: Colors.black),),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add, color: Colors.black,),
              onPressed: () => false,
            )
          ],
          ),
          body: Container(child:Text(event.name)),
        );
      },
    );
  }
}