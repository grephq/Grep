import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class Reminder extends StatefulWidget {
  Reminder({this.fullname});

  final String fullname;
  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {

  TextEditingController tecDescription = new TextEditingController();
  String description;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  DateTime pickedDate;
  TimeOfDay time;
  @override
  void initState() {
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
    startTime();

  }
  startTime() async{
    var duration = new Duration(milliseconds: 50);
     return new Timer(duration, _pickDate);
  }

  _pickDate() async {
    pickedDate = DateTime.now();
    DateTime date = await showDatePicker(
      context: context,
      firstDate: pickedDate,
      lastDate: DateTime(2100),
      initialDate: pickedDate,
    );    if(date != null)
    setState(() {
      pickedDate = date;
    });  
      _pickTime();
  }


  Future onSelectNotification(String payload) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Notification"),
          content: Text(widget.fullname + " feeling lazy, lets take care of that errand. Set a reminder"),
        ));
  }

  showNotification() async {
    var android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description');
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    var scheduledNotificationDateTime =
    new DateTime(pickedDate.year, pickedDate.month, pickedDate.day, time.hour, time.minute);
    await flutterLocalNotificationsPlugin.schedule(0, 'Reminder ',  description, scheduledNotificationDateTime, platform);
  }
  _pickTime() async {
    time = TimeOfDay.now();
    TimeOfDay t = await showTimePicker(
        context: context,
        initialTime: time
    );    if(t != null)
      setState(() {
        time = t;
      });  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color(0xFFED2F59),
        title: new Text("Reminder"),
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        child: Center(
          child: new Column(
            children: <Widget>[
              ListTile(
                title: Text("Date: ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}"),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: _pickDate,
              ),
              ListTile(
                title: Text("Time: ${time.hour}:${time.minute}"),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: _pickTime,
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: null,
                controller: tecDescription,
                cursorColor: Color.fromRGBO(237,47,89, 1),
                decoration: new InputDecoration(
                  hintText: "Description",
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(),
                  ),
                ),
              ),
              SizedBox(height: 15.0,),
              SizedBox(
                height: 55.0,
                width: 400.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    side: BorderSide(color: Color.fromRGBO(237,47,89, 1)),
                  ),
                  onPressed: () {
                    setState(() {
                      description = tecDescription.text;
                    });
                    try{
                      showNotification();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => new AlertDialog(
                            title: new Text("Success"),
                            content: new Text("Reminder set for ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day} ${time.hour}:${time.minute}"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          )
                      );
                    }catch(Exception){
                      showDialog(
                          context: context,
                          builder: (_) => new AlertDialog(
                            title: new Text("Failed"),
                            content: new Text("something went wrong}"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          )
                      );
                    }
                  },
                  color: Color.fromRGBO(237,47,89, 1),
                  child: Text("Set Reminder",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
