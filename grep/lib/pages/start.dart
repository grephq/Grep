import 'package:flutter/material.dart';
import 'package:grep_build3/pages/login.dart';
import 'package:grep_build3/pages/register.dart';


class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.all(35.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .08,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/grep_logo.png",
                      scale: 20.0,
                    ),
                    SizedBox(width:10.0),
                    Image.asset("assets/grep_text_logo_black.png",
                      scale: 20.0,
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Image.asset("assets/Mobile-login.jpg",
                  scale: 4.0,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
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
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => Login(),
                      ));
                    },
                    color: Color.fromRGBO(237,47,89, 1),
                    child: Text("Sign In",
                      style: TextStyle(
                          fontFamily: 'Spartan',
                          fontWeight: FontWeight.w700,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                SizedBox(
                  height: 55.0,
                  width: 400.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      //side: BorderSide(color: Color.fromRGBO(237,47,89, 1)),
                    ),
                    elevation: 0.0,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Register(),
                        ));
                    },
                    color: Colors.white,
                    child: Text("Sign Up",
                      style: TextStyle(
                          color: Color.fromRGBO(237,47,89, 1),
                          fontFamily: 'Spartan',
                          fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
