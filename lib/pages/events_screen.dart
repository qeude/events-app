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
  void didChangeDependencies() {
    super.didChangeDependencies();
    eventsBloc = BlocProvider.of<EventsBloc>(context);
    
  }
  

  @override
  Widget build(BuildContext context) {
    eventsBloc.fetchAllEvents();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: StreamBuilder(
              stream: eventsBloc.allEvents,
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData ||
                    (snapshot.hasData && snapshot.data.length == 0))
                  return Container();
                return IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: () {
                    showDialog(
                        context: context ,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete all'),
                            content: Text(
                                'Are you sure you want to delete all ? You will not be able to retrieve events.'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text('Delete'),
                                onPressed: () {
                                  eventsBloc.deleteAllEvents();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                );
              }),
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
              onPressed: () async => await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) {
                    return EventsAddEditScreen();
                  })),
            )
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () async => eventsBloc.fetchAllEvents(),
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
                            eventsList: snapshot.hasData ? snapshot.data : [],
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
