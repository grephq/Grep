import 'package:flutter/material.dart';
import 'dart:async';
import 'package:grep_build3/pages/start.dart';

class Splash extends StatefulWidget {


  @override
  _SplashState createState() => _SplashState();
 
}

class _SplashState extends State<Splash> {
  

  startTime() async{
    var duration = new Duration(seconds: 1);
     return new Timer(duration, startRoute);
  }

  startRoute(){
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => Start(),
    ));
  }

  void initState(){
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(237,47,89, 1),
      child: Center(
        child: Image.asset("assets/grep_logo_white.png",
          scale: 10.0,
        ),
      ),
    );
  }
}