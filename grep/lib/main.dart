import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grep_build3/pages/homesplash.dart';
import 'package:grep_build3/pages/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  await Hive.initFlutter();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => {
     runApp(StartPoint())
  });

}

class StartPoint extends StatefulWidget {
  @override
  _StartPointState createState() => _StartPointState();
}

class _StartPointState extends State<StartPoint> {

  SharedPreferences logindata;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool newuser;
  bool isLoggedIn = false;
  String fullname, email, phone, refcode, birthday, address;
  int noErrands;

  void registerNotification() async {
  // 1. Initialize the Firebase app
  await Firebase.initializeApp();

  // 2. On iOS, this helps to take the user permissions
  await _firebaseMessaging.requestNotificationPermissions(
    IosNotificationSettings(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    ),
  );
  _firebaseMessaging.configure(
      onMessage: (message) async {
        print(message);
        showSimpleNotification(
        Text("${message['notification']['title']}"),
        background: Colors.green,
        duration: Duration(seconds: 7),
        subtitle: Text("${message['notification']['body']}")
        );
      },
      onLaunch: (message) async {
        print(message);
      },
      onResume: (message) async {
       print(message);
      },
    );  
}


  void initState() {
    registerNotification();
    super.initState();
    checkIfAlreadyLogin();
  }
 

  Future checkIfAlreadyLogin() async {
    logindata = await SharedPreferences.getInstance();
    newuser = logindata.getBool('login');
    print(newuser);
    if (newuser == true) {
      setState(() {
        isLoggedIn = !isLoggedIn;
      });
      try{
        setState(() {
          fullname = logindata.getString("fullname");
          email = logindata.getString("email");
          phone = logindata.getString("phone");
          refcode = logindata.getString("refcode");
          birthday = logindata.getString("birthday");
          address = logindata.getString("address");
          print(address);
          noErrands = logindata.getInt("noErrand");
        });
      }catch(Exception){
          print("something went wrong");
      }
    }
  }

 @override
 Widget build(BuildContext context) {
   return OverlaySupport(
    child: MaterialApp(
      title: 'Grep',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      color: Color.fromRGBO(237,47,89, 1),
      
      home: isLoggedIn ? HomeSplash(isLoggedIn: true, fullname: fullname, email: email, phone: phone, refcode: refcode, birthday: birthday, address: address, noErrands: noErrands,) : Splash(),
    )
  );
 }
}

