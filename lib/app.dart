import 'package:flutter/material.dart';
import 'package:events_app/pages/events_screen.dart';
import 'package:events_app/utils/constants.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: EventsScreen(),
    );
  }
}