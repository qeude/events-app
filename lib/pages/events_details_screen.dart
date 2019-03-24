import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:events_app/blocs/events/events.dart';

class EventsDetailsScreen extends StatelessWidget {
  final String id;

  EventsDetailsScreen({@required this.id});

  @override
  Widget build(BuildContext context) {
    final eventBloc = BlocProvider.of<EventsBloc>(context);
    return BlocBuilder(
      bloc: eventBloc,
      builder: (context, EventsState state) {
        final event = (state as EventsStatePopulated)
            .events
            .firstWhere((elmt) => elmt.id == id, orElse: () => null);
        return Scaffold(
          body: Stack(children: <Widget>[
            Column(children: <Widget>[
            Expanded(
                child: Hero(
              tag: 'eventImg${event.id}',
              child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/croatia.jpg"),
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fill),
                  ),
                  padding: EdgeInsets.only(left: 40.0, bottom: 30.0),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Material(
                            color: Colors.transparent,
                            child: Text(
                              event.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50.0,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black12, blurRadius: 4.0)
                                  ]),
                            )),
                      ),
                      Container(
                          child: Material(
                              color: Colors.transparent,
                              child: Text(
                                  "In ${event.date.difference(DateTime.now()).inDays} days",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black12,
                                            blurRadius: 4.0)
                                      ]))))
                    ],
                  )),
            ))
          ]),
          new Positioned( //Place it at the top, and not use the entire screen
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AppBar(
            backgroundColor: Colors.transparent, //No more green
            elevation: 0.0, //Shadow gone
          ),),
          ],),
        );
      },
    );
  }
}
