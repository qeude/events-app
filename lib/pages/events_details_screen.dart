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
      builder: (context, EventsState state) {
        final Event event = (state as EventsStatePopulated)
            .events
            .firstWhere((elmt) => elmt.id == id, orElse: () => null);
        return Scaffold(
          body: Stack(
            children: <Widget>[
              Column(children: <Widget>[
                Expanded(
                    child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _buildEventImage(context, event),
                    _buildDescriptionSection(context, event),
                  ],
                ))
              ]),
              new Positioned(
                //Place it at the top, and not use the entire screen
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: AppBar(
                  backgroundColor: Colors.transparent, //No more green
                  elevation: 0.0, //Shadow gone
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventImage(BuildContext context, Event event) {
    return Hero(
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
          height: MediaQuery.of(context).size.height - 30.0,
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
                            Shadow(color: Colors.black12, blurRadius: 4.0)
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
                                Shadow(color: Colors.black12, blurRadius: 4.0)
                              ]))))
            ],
          )),
    );
  }

  Widget _buildDescriptionSection(BuildContext context, Event event) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: 20.0, left: 40.0,right: 40.0, bottom: 20.0),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              'Description',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: Text(event.description),
            padding: EdgeInsets.only(top: 20.0),  
          )
        ],
      ),
    );
  }
}
