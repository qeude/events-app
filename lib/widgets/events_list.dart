import 'package:flutter/material.dart';

import 'package:events_app/models/models.dart';
import 'package:events_app/utils/constants.dart';

import 'package:events_app/pages/events_details_screen.dart';
class EventsList extends StatelessWidget {
  final bool visible;
  final List<Event> eventsList;

  const EventsList({this.visible, this.eventsList});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: visible ? opacityVisible : opacityInvisible,
        duration: Duration(milliseconds: 500),
        child: ListView.builder(
          itemCount: eventsList.length,
          padding: EdgeInsets.all(20.0),
          itemBuilder: (context, position) {
          return BuildCard(
            item: eventsList[position],
          );
        },
        ),
    );
  }
}

class BuildCard extends StatelessWidget{
  final Event item;
  const BuildCard({this.item});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await Navigator.of(context).push(MaterialPageRoute(builder: (_){return EventsDetailsScreen(id: item.id);})),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsets.only(bottom: 20.0),
        child: Hero(
          tag: 'eventImg${item.id}',
          child : Container(
          height: 350.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/croatia.jpg"),
              alignment: Alignment.topCenter,
              fit: BoxFit.fill
            ),
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
                        child : Text(item.name, style: TextStyle(color: Colors.white, fontSize: 50.0, shadows: [Shadow(color: Colors.black12, blurRadius: 4.0)]),)),
              ),
              Container(
                child: Material(
                        color: Colors.transparent,
                        child : Text("In ${item.date.difference(DateTime.now()).inDays} days", style: TextStyle(color:Colors.white, fontSize: 20.0, shadows: [Shadow(color: Colors.black12, blurRadius: 4.0)])))
              )
            ],
          )
        ),
      ))
    );
  }
}