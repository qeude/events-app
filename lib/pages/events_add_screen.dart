import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:events_app/blocs/events/events.dart';

import 'package:events_app/widgets/on_image_textfield.dart';

import 'package:events_app/utils/constants.dart';

class EventsAddScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventBloc = BlocProvider.of<EventsBloc>(context);
    return BlocBuilder(
      bloc: eventBloc,
      builder: (BuildContext context, EventsState state) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              Column(children: <Widget>[
                Expanded(
                    child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _buildEventImage(context),
                    _buildAddSection('description'),
                    _buildAddSection('location'),
                    _buildAddSection('checklist'),
                    //_buildDescriptionSection(context),
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

  Widget _buildEventImage(BuildContext context) {
    return Container(
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
                  child: OnImageTextField(eventNameTextStyle, 'Add Name')),
            ),
            Container(
                child: Material(
                    color: Colors.transparent,
                    child: FlatButton(
                        padding: EdgeInsets.only(left: 0.0, top: 0.0),
                        onPressed: () async {
                          DateTime selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate:
                                DateTime.now().subtract(Duration(days: 1)),
                            lastDate: DateTime(2030),
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.dark(),
                                child: child,
                              );
                            },
                          );
                          TimeOfDay selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.dark(),
                                child: child,
                              );
                            },
                          );
                          DateTime result =DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
                        },
                        child: Text('Add Date', style: eventDateTextStyle))))
          ],
        ));
  }

  Widget _buildAddSection(String sectionName) {
    TextStyle textStyle = TextStyle(
        color: Colors.black87, fontSize: 18.0, fontWeight: FontWeight.w700);
    return Container(
      alignment: Alignment.topLeft,
      padding:
          EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
      child: FlatButton(
        onPressed: () => {},
        padding:EdgeInsets.only(top: 0.0, left: 0.0),
        child: Text('+ Add $sectionName', style: textStyle,),
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
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
            child: Text('Add Description'),
            padding: EdgeInsets.only(top: 20.0),
          )
        ],
      ),
    );
  }
}
