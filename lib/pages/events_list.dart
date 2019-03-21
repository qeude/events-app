import 'package:flutter/material.dart';

import 'package:events_app/models/models.dart';

class EventsList extends StatelessWidget {

  final List<Event> eventsList;

  const EventsList({this.eventsList});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 500),
        child: ListView.builder(
          itemCount: eventsList.length,
          itemBuilder: (context, position) {
          return BuildListTile(
            item: eventsList[position],
          );
        },
        ),
    );
  }
}

class BuildListTile extends StatelessWidget {

  final Event item;
  const BuildListTile({this.item});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text(item.date.toString()),
    );
  }
}