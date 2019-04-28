import 'package:flutter/material.dart';
import 'package:events_app/pages/events_screen.dart';
import 'package:events_app/utils/constants.dart';
import 'package:events_app/blocs/events/events_bloc.dart';
import 'package:events_app/blocs/bloc_provider.dart';
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final eventsBloc = EventsBloc();

  @override
  void dispose() {
    this.eventsBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: eventsBloc,
      child: MaterialApp(
        title: appTitle,
        home: EventsScreen(),
    ));
  }
}