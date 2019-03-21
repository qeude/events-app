import 'package:flutter/material.dart';
import 'package:events_app/pages/events_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events',
      home: EventsScreen(),
    );
  }
}