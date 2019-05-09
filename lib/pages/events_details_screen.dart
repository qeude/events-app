import 'package:flutter/material.dart';

import 'package:events_app/blocs/bloc_provider.dart';
import 'package:events_app/blocs/events/events_bloc.dart';
import 'package:events_app/pages/events_add_edit_screen.dart';
import 'package:events_app/models/models.dart';
import 'package:events_app/utils/constants.dart';
import 'package:events_app/utils/utils.dart';
import 'package:events_app/widgets/loading_indicator.dart';

class EventsDetailsScreen extends StatefulWidget {
  final String id;
  final String image;
  final String name;
  final DateTime date;
  EventsDetailsScreen(
      {@required this.id,
      @required this.image,
      @required this.name,
      @required this.date});

  @override
  _EventsDetailsScreenState createState() => _EventsDetailsScreenState();
}

class _EventsDetailsScreenState extends State<EventsDetailsScreen> {
  EventsBloc eventBloc;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    eventBloc = BlocProvider.of<EventsBloc>(context);
    eventBloc.getEventById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: eventBloc.eventDetails,
      builder: (context, snapshot) {
        Event event;
        if (snapshot.hasData) event = snapshot.data;
        return Stack(
          children: <Widget>[
            Column(children: <Widget>[
              Expanded(
                  child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  _buildEventImage(context, event),
                  (event != null &&
                          event.description != null &&
                          event.description.trim().isNotEmpty)
                      ? _buildDescriptionSection(context, event)
                      : Container(),
                  (event != null && event.hasLocation)
                      ? _buildLocationSection(context)
                      : Container()
                ],
              ))
            ]),
            new Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                actions: _buildActionButtons(context, event),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            ),
          ],
        );
      },
    ));
  }

  List<Widget> _buildActionButtons(BuildContext context, Event event) {
    return [
      IconButton(
        icon: Icon(Icons.delete_forever),
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Delete ${event.name}'),
                  content: Text(
                      'You will not be able to get it back, are you sure that you want delete this event ?'),
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
                        eventBloc.deleteEvent(event);
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName("/"));
                      },
                    ),
                  ],
                );
              });
        },
      ),
      IconButton(
          icon: Icon(Icons.create),
          onPressed: () async =>
              await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return EventsAddEditScreen(id: widget.id);
              })))
    ];
  }

  Widget _buildEventImage(BuildContext context, Event event) {
    return Hero(
      tag: 'eventImg${event != null ? event.id : widget.id}',
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: eventImageProvider(
                    event != null ? event.image : widget.image),
                alignment: Alignment.topCenter,
                fit: BoxFit.cover),
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
                      event != null ? event.name : widget.name,
                      style: eventNameTextStyle,
                    )),
              ),
              Container(
                  child: Material(
                      color: Colors.transparent,
                      child: Text(
                          "In ${event != null ? getTimeUntilEvent(event.date) : getTimeUntilEvent(widget.date)}",
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

  _buildLocationSection(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding:
          EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Text(
                  'Location',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
                )),
          ),
          buildEventLocation(),
        ],
      ),
    );
  }
}
