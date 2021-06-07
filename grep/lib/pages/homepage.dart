import 'dart:async';
import 'dart:convert';
import 'package:grep_build3/pages/payment.dart';
import 'package:grep_build3/pages/start.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:grep_build3/pages/profile.dart';
import 'package:grep_build3/pages/free_errands.dart';
import 'package:grep_build3/pages/history.dart';
import 'package:grep_build3/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_string/random_string.dart';
import 'package:start_jwt/json_web_token.dart';
import 'package:intl/intl.dart';
import 'loading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({this.fullname, this.email, this.phone, this.refcode, this.free, this.birthday, this.address, this.noErrands});

  String fullname;
  String email;
  String phone;
  final String refcode;
  String free;
  String birthday;
  String address;
  int noErrands;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  AnimationController _controller;
  String description, location, notificationBody;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool status = false;
  SharedPreferences logindata;
  String pickup, dropoff, orderDescription;
  TextEditingController tecDescription = new TextEditingController();
  TextEditingController tecLocation = new TextEditingController();
  TextEditingController dropLocation = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _orderKey = GlobalKey<FormState>();
  TextEditingController _textFieldController = new TextEditingController();
  List<String> s;
  DateTime pickedDate;
  bool loading = false;
  TimeOfDay time;
  
  

  
  
  _pickDate() async {
    pickedDate = DateTime.now();
    DateTime date = await showDatePicker(
      context: context,
      firstDate: pickedDate,
      lastDate: DateTime(2100),
      initialDate: pickedDate,
    );    
    if(date != null){
      setState(() {
        pickedDate = date;
      });  
      await _pickTime();
    }
    
  }

  Future removeSharedData() async{
    logindata = await SharedPreferences.getInstance();
    logindata.setBool("login", false);
    logindata.remove("fullname");
    logindata.remove("email");
    logindata.remove("phone");
    logindata.remove("refcode");
    logindata.remove("free");
    logindata.remove("address");
    logindata.remove("noErrand");
    logindata.remove("birthday");
    logindata.remove("showShowcase");
  }


  _pickTime() async {
    time = TimeOfDay.now();
    TimeOfDay t = await showTimePicker(
        context: context,
        initialTime: time
    );    
    if(t != null){
      setState(() {
        time = t;
      });
      reminderDialog(context);
    }
      
  }

  void initState(){
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
    _controller =  AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _controller.repeat(reverse: true);
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  
  String reminderValidator(String title){
    if(title.length == 0){
      return "*Description cannot be empty";
    }
  }

  String fieldvalidator(String value){
    if(value.isEmpty){
      return "*This field cannot be empty";
    }else{
      return null;
    }
  }

  void dispose(){
    super.dispose();
  }
  

  

  Future<void> reminderDialog(BuildContext context) async{
    return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Description'),
        content: Form(
          key: _formKey,
          child:  TextFormField(
            validator: reminderValidator,
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Enter: "),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            color: Color.fromRGBO(237, 47, 89, 1),
            textColor: Colors.white,
            child: Text('Send'),
            onPressed: () {
              if(_formKey.currentState.validate()){
                setState(() {
                  description = _textFieldController.text;
                });
                reminderNotification();
                Navigator.of(context).pop();
                _textFieldController.clear();
                showDialog(
                  context: context,
                  builder: (BuildContext context) => new AlertDialog(
                    title: new Text("Success"),
                    content: new Text("Reminder set for ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day} ${time.hour}:${time.minute}"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Close'),
                        onPressed: () {
                          _textFieldController.clear();
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                );
              }
            },
          ),
        ],
      );
    });
  }

  reminderNotification() async {
    var android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description');
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    var scheduledNotificationDateTime =
    new DateTime(pickedDate.year, pickedDate.month, pickedDate.day, time.hour, time.minute);
    await flutterLocalNotificationsPlugin.schedule(0, 'Reminder',  description, scheduledNotificationDateTime, platform);
  }

  freeNotification() async {
    var android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description');
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    var scheduledNotificationDateTime =
    new DateTime(DateTime.now().year, DateTime.now().month,DateTime.now().day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second);
    await flutterLocalNotificationsPlugin.schedule(0, 'Nneka from Grep',  "Congrats😊! This order is free.", scheduledNotificationDateTime, platform);
  }

  showNotification() async {
    const AndroidInitializationSettings InitializationSettingsAndroid= 
      AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true
      );
    final InitializationSettings initializationSettings = InitializationSettings(InitializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    var android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description');
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    var scheduledNotificationDateTime =
    new DateTime(DateTime.now().year, DateTime.now().month,DateTime.now().day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second);
    await flutterLocalNotificationsPlugin.schedule(0, 'Nneka from Grep',  "Welcome🎉, what are you waiting for? Make an order!", scheduledNotificationDateTime, platform);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.pink
      ),
      home: Scaffold(
        body: home(context)
      ),
    );
  }

  Widget home(BuildContext context){
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(237,47,89, 1),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 180.0,
              child: Container(
                color: Color.fromRGBO(237,47,89, 1),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Experience fast delivery",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("within UNILAG",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Send & receive packages from your hostel, faculty",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("& anywhere within UNILAG",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                          child: Text("Start making orders right away! ➔",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500
                            ),
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                          child: Icon(Icons.location_on, color: Colors.white, size: 50.0,),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Form(
              key: _orderKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: TextFormField(
                      validator: fieldvalidator,
                      onChanged: (_loc) => pickup = _loc,
                      textCapitalization: TextCapitalization.sentences,
                      controller: tecLocation,
                      cursorColor: Color.fromRGBO(237,47,89, 1),
                      decoration: new InputDecoration(
                        fillColor: Color.fromRGBO(234, 234, 234, 1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(234, 234, 234, 1),
                          )
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(234, 234, 234, 1),
                          )
                        ),
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(0.0),
                        ),
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),
                        hintText: "Enter pick-up point",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          //fontWeight: FontWeight.bold,
                          fontSize: 18.0
                        )
                      ),
                    )
                  ),
                  SizedBox(height: 10.0,),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: TextFormField(
                      validator: fieldvalidator,
                      controller: dropLocation,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (_loc) => dropoff = _loc,
                      cursorColor: Color.fromRGBO(237,47,89, 1),
                      decoration: new InputDecoration(
                        fillColor: Color.fromRGBO(234, 234, 234, 1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(234, 234, 234, 1),
                          )
                        ),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(234, 234, 234, 1),
                          )
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(234, 234, 234, 1),
                          )
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(0.0),
                        ),
                        hintText: "Enter drop-off point",
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.black,
                          //fontWeight: FontWeight.bold,
                          fontSize: 18.0
                        )
                      ),
                    )
                  ),
                  SizedBox(height: 10.0,),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                    child: TextFormField(
                      validator: fieldvalidator,
                      controller: tecDescription,
                      maxLines: 4,
                      onChanged: (_dec) => orderDescription = _dec,
                      textCapitalization: TextCapitalization.sentences,
                      cursorColor: Color.fromRGBO(237,47,89, 1),
                      decoration: new InputDecoration(
                        fillColor: Color.fromRGBO(234, 234, 234, 1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(234, 234, 234, 1),
                          )
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(234, 234, 234, 1),
                          )
                        ),
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(0.0),
                        ),
                        hintText: "Description",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          //fontWeight: FontWeight.bold,
                          fontSize: 18.0
                        )
                      ),
                    )
                  ),
                ],
              )
            ),
            SizedBox(height: 15.0,),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: loading ? CircleLoading() : SizedBox(
                height: 55.0,
                width: 400.0,
                child: RaisedButton(
                  color: Color.fromRGBO(237,47,89, 1),
                  elevation: 0.0,
                  child: Text("Order",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                    ),
                  ),
                  onPressed: () async{
                    if(_orderKey.currentState.validate()){
                      setState(() {
                        loading = true;
                      });
                      var now = new DateTime.now();
                      String formattedTime = DateFormat.jm().format(now);
                      String formattedDate = DateFormat.yMMMMd('en_US').format(now);
                      final jwt = new JsonWebTokenCodec(secret: 'OBbyzm1zv7m9oJ5wI5rNhuFHX37gPA');
                      try{
                        final encoded = jwt.encode({
                          "fullname" : "${widget.fullname}",
                          "phone" : "${widget.phone}",
                          "email" : "${widget.email}",
                          "pickup" : pickup,
                          "dropoff" : dropoff,
                          "description" : orderDescription,
                          "status" : "Available",
                          "date" : "$formattedDate $formattedTime",
                          "errandid" : randomAlphaNumeric(10).toUpperCase()
                        });
                        Response response = await post("https://tomiwa.com.ng/grepworks/greporder7.php", body:{
                          "order" : encoded
                        });
                        if(response.body.isNotEmpty){
                          var value = jsonDecode(response.body);
                          SharedPreferences data;
                          data = await SharedPreferences.getInstance();
                          int val = data.getInt("noErrand");
                          tecLocation.clear();
                          dropLocation.clear();
                          tecDescription.clear();
                          setState(() {
                            val++;
                            loading = false;
                          });
                          data.setInt("noErrand", val);
                          if(value['Errand'] == 'Free'){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => new AlertDialog(
                                  title: new Text("Success"),
                                  content: new Text("Congratulations🎉, this order is free!!!"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context, rootNavigator:true).pop();
                                      },
                                    )
                                  ],
                                )
                              );                
                            freeNotification();
                          }else{
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => new AlertDialog(
                                title: new Text("Success"),
                                content: new Text("Proceed to history to track your order."),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator:true).pop();
                                    },
                                  )
                                ],
                              )
                            );
                          }
                          print("Order submitted");
                        }
                      }catch(Exception){
                        setState(() {
                          loading = false;
                        });
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => new AlertDialog(
                            title: new Text("Oops"),
                            content: new Text("No internet connection"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context, rootNavigator:true).pop();
                                },
                              )
                            ],
                          )
                        );
                      }
                    }
                  },
                  
                )
              )
            ),
            SizedBox(height: 15.0)
          ],
        )
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * .7,
        child: Drawer(
          child: Container(
            decoration: BoxDecoration(
              image: new DecorationImage(
                  image: AssetImage("assets/grep_nav.png"),
                  fit: BoxFit.cover
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  // ListView contains a group of widgets that scroll inside the drawer
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      SizedBox(height: 60.0,),
                      Row(
                        children: [
                          SizedBox(width: 27.0,),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 25.0,
                            child: Text(
                              "${widget.fullname[0]}".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 30.0
                              ),
                            ),
                          ),
                          SizedBox(width: 25.0,),
                          Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${widget.fullname.split(" ")[1]} ${widget.fullname.split(" ")[0][0]}.",
                                textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                      fontFamily: 'Spartan',
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              widget.noErrands < 50 ? Icon(Icons.star, color: Colors.black) :  (widget.noErrands < 150) ? Row(children: [Icon(Icons.star,color: Colors.black),Icon(Icons.star, color: Colors.black)],) : (widget.noErrands < 400) ? Row(children: [Icon(Icons.star, color: Colors.black),Icon(Icons.star, color: Colors.black),Icon(Icons.star, color: Colors.black)],) : Row(children: [Icon(Icons.star, color: Colors.black),Icon(Icons.star, color: Colors.black),Icon(Icons.star, color: Colors.black), Icon(Icons.star, color: Colors.black)],)
                            ],
                          )
                          
                        ],
                      ),
                      SizedBox(height: 50.0,),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Image.asset("assets/acc.png", scale: 3.0,),
                              title: Text("Profile",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Spartan',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Profile(fullname: widget.fullname, email: widget.email, phone: widget.phone, refcode: widget.refcode, address: widget.address),
                                ));
                              },
                            ),
                            ListTile(
                              leading: Image.asset("assets/time.png", scale: 1.5,),
                              title: Text("History",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Spartan',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => History(email: widget.email, fullname: widget.fullname, phone: widget.phone,),
                                ));
                              },
                            ),
                            ListTile(
                              leading: Image.asset("assets/money.png", scale: 1.5,),
                              title: Text("Payment",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Spartan',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Payment(fullname: widget.fullname,),
                                ));
                              },
                            ),
                            ListTile(
                              leading: Image.asset("assets/alarm.png", scale: 1.5,),
                              title: Text("Set Reminder",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Spartan',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              onTap: () async{ 
                                await _pickDate();                 
                              },
                            ),
                            ListTile(
                              leading: Image.asset("assets/bicycle.png", scale: 1.5,),
                              title: Text("Free Errands",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Spartan',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => FreeErrands(refcode: widget.refcode),
                                ));
                              },
                            ),
                            ListTile(
                              leading: Image.asset("assets/setting.png", scale: 3.0,),
                              title: Text("Settings",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Spartan',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Settings(),
                                ));
                              },
                            ),
                            
                          ],
                        )
                      )
                    ],
                  ),
                ),
                Container(
                  // This align moves the children to the bottom
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      SizedBox(height: 10.0),
                      ListTile(
                        title: Text("Logout",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Spartan',
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        onTap: () async {
                          var dir = await getApplicationDocumentsDirectory();
                          dir.deleteSync(recursive: true);
                          removeSharedData();
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Start()), (route) => false);
                        },
                        leading: Icon(Icons.logout, color: Colors.black),
                        trailing: Text("1.0.0",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
      
      
      
   );
  }
}
