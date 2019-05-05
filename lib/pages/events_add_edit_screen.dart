import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:events_app/blocs/bloc_provider.dart';
import 'package:events_app/blocs/events/events_bloc.dart';

import 'package:events_app/widgets/on_image_textfield.dart';

import 'package:events_app/utils/constants.dart';
import 'package:events_app/utils/utils.dart';
import 'package:events_app/models/models.dart';
import 'package:events_app/blocs/add_event/add_event_bloc.dart';

class EventsAddEditScreen extends StatefulWidget {
  final String id;

  EventsAddEditScreen({this.id});
  @override
  _EventsAddEditScreenState createState() => _EventsAddEditScreenState();
}

class _EventsAddEditScreenState extends State<EventsAddEditScreen> {
  bool hasDescription = false;

  bool hasLocation = false;

  bool hasChecklist = false;

  DateTime eventDate;

  TextEditingController eventNameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  final AddEventBloc addEventBloc = AddEventBloc();

  @override
  void dispose() {
    addEventBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventBloc = BlocProvider.of<EventsBloc>(context);
    if(widget.id != null)
      eventBloc.getEventById(widget.id);
    return StreamBuilder(
      stream: eventBloc.eventDetails,
      builder: (BuildContext context, snapshot) {
        Event event;
        if (snapshot.hasData) {
          event = snapshot.data;
          addEventBloc.changeEventDate(event.date);
          addEventBloc.changeDescription(event.description != null && event.description.trim().isNotEmpty);
          addEventBloc.changeEventImage(event.image);
          eventNameController.text = event.name;
        }
        return Scaffold(
          body: Stack(
            children: <Widget>[
              Column(children: <Widget>[
                Expanded(
                    child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    StreamBuilder<String>(
                        stream: addEventBloc.eventImage,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return _buildEventImage(context, snapshot.data);
                          }
                          return _buildSelectImage();
                        }),
                    StreamBuilder<bool>(
                      stream: addEventBloc.hasDescription,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          this.hasDescription = snapshot.data;
                          if (snapshot.data) {
                            descriptionController.text = event == null ? "" : event.description;
                            return _buildDescriptionSection(context);
                          }
                          return _buildAddSection('description');
                        }
                        return Container();
                      },
                    ),
                    _buildAddSection('location'),
                    _buildAddSection('checklist'),
                  ],
                ))
              ]),
              new Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: StreamBuilder(
                  stream : addEventBloc.eventImage,
                  builder: (context, snapshot){
                    return AppBar(
                      backgroundColor: Colors.transparent, //No more green
                      elevation: 0.0,
                      actions: snapshot.hasData ? <Widget>[
                        IconButton(icon: Icon(Icons.image),
                        onPressed: () => {
                          getImage()
                        },),
                        IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            if (this._checkAllField()) {
                              String description = this.hasDescription
                                  ? this.descriptionController.text
                                  : null;
                              if(widget.id == null)
                                eventBloc.addEvent(Event(this.eventNameController.text, this.eventDate, snapshot.data, description: description));
                              else
                                eventBloc.updateEvent(Event(this.eventNameController.text, this.eventDate,snapshot.data, description: description, id:widget.id));
                              print(
                                  'Saving ${this.eventDate} ${eventNameController.text} ${snapshot.data}');
                              Navigator.pop(context);
                            }
                          },
                        )
                      ] : <Widget>[],
                    );
                  })
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventImage(BuildContext context, String image) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: eventImageProvider(image),
              alignment: Alignment.topCenter,
              fit: BoxFit.cover),
        ),
        padding: EdgeInsets.only(left: 40.0, bottom: 245.0),
        alignment: Alignment.bottomLeft,
        height: MediaQuery.of(context).size.height - 30.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.zero,
              child: Material(
                  color: Colors.transparent,
                  child: OnImageTextField(
                    eventNameTextStyle,
                    'Add Name',
                    controller: eventNameController,
                  )),
            ),
            Container(
                child: Material(
                    color: Colors.transparent,
                    child: FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        DateTime selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now().subtract(Duration(days: 1)),
                          lastDate: DateTime(2030),
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData.dark(),
                              child: child,
                            );
                          },
                        );
                        TimeOfDay selectedTime;
                        if (selectedDate != null) {
                          selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.dark(),
                                child: child,
                              );
                            },
                          );
                        }
                        if (selectedDate != null && selectedTime != null) {
                          DateTime result = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute);
                          addEventBloc.changeEventDate(result);
                        }
                      },
                      child: StreamBuilder<DateTime>(
                          stream: addEventBloc.eventDate,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              this.eventDate = snapshot.data;
                              return Text(
                                  "In ${getTimeUntilEvent(snapshot.data)}",
                                  style: eventDateTextStyle);
                            }
                            return Text('Add Date', style: eventDateTextStyle);
                          }),
                    )))
          ],
        ));
  }

  void getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String imagePath = image.path;
      String resultPath = await saveImage(imagePath);
      addEventBloc.changeEventImage(resultPath);
    }
  }

  Widget _buildSelectImage() {
    return GestureDetector(
      child: Container(
          decoration: BoxDecoration(color: Colors.grey[100]),
          alignment: Alignment.bottomLeft,
          height: MediaQuery.of(context).size.height - 30.0,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Icon(Icons.image, size: 40,),
              Text('Tap to select an image ...', style: TextStyle(fontSize: 20),),
            ],)
          )),
      onTap: () {
        getImage();
      },
    );
  }

  Widget _buildAddSection(String sectionName) {
    TextStyle textStyle = TextStyle(
        color: Colors.black87, fontSize: 18.0, fontWeight: FontWeight.w700);
    return Container(
      alignment: Alignment.topLeft,
      padding:
          EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0, bottom: 20.0),
      child: FlatButton(
        onPressed: () {
          switch (sectionName) {
            case ('description'):
              {
                addEventBloc.changeDescription(true);
              }
              break;
            case ('checklist'):
              {
                addEventBloc.changeChecklist(true);
              }
              break;
            case ('location'):
              {
                addEventBloc.changeLocation(true);
              }
              break;
            default:
              {}
              break;
          }
        },
        padding: EdgeInsets.only(top: 0.0, left: 0.0),
        child: Text(
          '+ Add $sectionName',
          style: textStyle,
        ),
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
            child: TextField(
              controller: descriptionController,
              maxLength: 250,
              maxLines: 5,
              autocorrect: true,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Enter description"),
            ),
            padding: EdgeInsets.only(top: 20.0),
          )
        ],
      ),
    );
  }

  bool _checkAllField() {
    return this.eventNameController.text != null &&
        this.eventNameController.text.trim().isNotEmpty &&
        this.eventDate != null;
  }
}
