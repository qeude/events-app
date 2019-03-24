import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:events_app/pages/events_screen.dart';
import 'package:events_app/utils/constants.dart';
import 'package:events_app/blocs/events/events.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventsBloc = EventsBloc();
    return BlocProvider(
      bloc: eventsBloc,
      child: MaterialApp(
        title: appTitle,
        home: EventsScreen(),
    ));
  }
}