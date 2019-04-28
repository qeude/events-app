import 'package:flutter/material.dart';

import 'package:events_app/blocs/bloc_provider.dart';
import 'package:events_app/blocs/events/events_bloc.dart';
import 'package:events_app/pages/events_add_edit_screen.dart';
import 'package:events_app/models/models.dart';
import 'package:events_app/utils/constants.dart';
class EventsDetailsScreen extends StatefulWidget {
  final String id;

  EventsDetailsScreen({@required this.id});

  @override
  _EventsDetailsScreenState createState() => _EventsDetailsScreenState();
}

class _EventsDetailsScreenState extends State<EventsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final eventBloc = BlocProvider.of<EventsBloc>(context);
    eventBloc.getEventById(widget.id);
    return StreamBuilder(
      stream : eventBloc.eventDetails,
      builder: (context, snapshot){
        final Event event = snapshot.data;
        return Scaffold(
          body: Stack(
            children: <Widget>[
              Column(children: <Widget>[
                Expanded(
                    child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _buildEventImage(context, event),
                    (event.description != null && event.description.trim().isNotEmpty) ? _buildDescriptionSection(context, event) : Container(),
                  ],
                ))
              ]),
              new Positioned(
                //Place it at the top, and not use the entire screen
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: AppBar(
                  actions: <Widget>[
                    IconButton(icon: Icon(Icons.create), onPressed: () async =>
                    await Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return EventsAddEditScreen(id: widget.id);
                            })))
                  ],
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
          padding: EdgeInsets.only(left: 40.0, bottom: 250.0),
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
                      style: eventNameTextStyle,
                    )),
              ),
              Container(
                  child: Material(
                      color: Colors.transparent,
                      child: Text(
                          "In ${event.date.difference(DateTime.now()).inDays} days",
                          style: eventDateTextStyle)))
            ],
          )),
    );
  }

  Widget _buildDescriptionSection(BuildContext context, Event event) {
    return Container(
      alignment: Alignment.topLeft,
      padding:
          EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
              'Description',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
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
