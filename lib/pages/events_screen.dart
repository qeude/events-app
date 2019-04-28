import 'package:flutter/material.dart';

import 'package:events_app/blocs/events/events_bloc.dart';
import 'package:events_app/models/models.dart';
import 'package:events_app/widgets/events_list.dart';
import 'package:events_app/widgets/loading_indicator.dart';
import 'package:events_app/blocs/bloc_provider.dart';
import 'package:events_app/pages/events_add_edit_screen.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  EventsBloc eventsBloc;
  @override
  Widget build(BuildContext context) {
    eventsBloc = BlocProvider.of<EventsBloc>(context);
    eventsBloc.fetchAllEvents();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            'Events',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              onPressed: () async => print('+'),//await Navigator.of(context).push(MaterialPageRoute(builder: (_) {return EventsAddEditScreen();})),
            )
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () async => await eventsBloc.fetchAllEvents(),
            child: StreamBuilder<List<Event>>(
              stream: eventsBloc.allEvents,
              builder: (context, snapshot) {
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          LoadingIndicatorWidget(
                            visible: !snapshot.hasData,
                          ),
                          EventsList(
                            visible: snapshot.hasData,
                            eventsList:
                                snapshot.hasData ? snapshot.data : [],
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            )));
  }
}
