import 'package:flutter/material.dart';
import 'dart:async';
import 'package:grep_build3/pages/homepage.dart';

class HomeSplash extends StatefulWidget {
  const HomeSplash({Key key, this.isLoggedIn, this.fullname, this.email, this.phone, this.refcode, this.free, this.birthday, this.address, this.noErrands}) : super(key: key);

 

  @override
  _HomeSplashState createState() => _HomeSplashState();
  final bool isLoggedIn;
  final String fullname;
  final String email;
  final String phone;
  final String refcode;
  final String free;
  final String birthday;
  final String address;
  final int noErrands;
}

class _HomeSplashState extends State<HomeSplash> {

  startTime() async{
    var duration = new Duration(seconds: 1);
    return new Timer(duration, homeRoute);
  }

  homeRoute(){
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => HomePage(fullname: widget.fullname, email: widget.email, phone: widget.phone, refcode: widget.refcode, birthday: widget.birthday, address: widget.address, noErrands: widget.noErrands,),
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