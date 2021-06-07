import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grep_build3/pages/qr_code.dart';
import 'package:share/share.dart';
import 'package:overlay_support/overlay_support.dart';


// ignore: must_be_immutable
class FreeErrands extends StatefulWidget {
  FreeErrands({this.refcode});

  final String refcode;
  @override
  _FreeErrandsState createState() => _FreeErrandsState();
}

class _FreeErrandsState extends State<FreeErrands> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFFED2F59),
        actions: [
          IconButton(icon: Icon(Icons.qr_code), onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => QrCode(qr: widget.refcode,),
            ));
          })
        ],
        title: Text("Free Errands")
      ),
      body:SingleChildScrollView(
      child:Container(
        margin: EdgeInsets.only(left:15.0, right: 15.0, bottom: 25.0, top: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Color.fromRGBO(244, 244, 244, 1),
        ),
        child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .1,),
              Align(
                alignment: Alignment.center,
                child: Text("Refer & Earn",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20.0
                    )
                ),
              ),
              SizedBox(height: 25.0,),
              SizedBox(
                  width: 325.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Colors.white
                    ),
                    
                    child: Column(
                      children: [
                        SizedBox(height: 40.0,),
                        SizedBox(
                            child: Container(
                                child: Image.asset("assets/refer_img.jpg",
                                  scale: 16.0,
                                )
                            )
                        ),
                        SizedBox(height: 35.0,),
                        Align(
                          alignment: Alignment.center,
                          child: Text("Your Referral Code\n",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SelectableText(widget.refcode,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          height: 45.0,
                          width: 250.0,
                          child: RaisedButton(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.white),
                            ),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: "${widget.refcode}"));
                              //showToast();
                              showSimpleNotification(
                              Text("Copied"),
                              background: Color.fromRGBO(237,47,89, 1),
                              duration: Duration(seconds: 2),
                              subtitle: Text("Text has been copied to clipboard")
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.copy),
                                Text("  Copy",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0,),
                        Divider(
                          color: Color.fromRGBO(244, 244, 244, 1),
                          thickness: 15.0,
                        ),
                        SizedBox(height: 30.0,),
                        Align(
                          alignment: Alignment.center,
                          child: Text("Share our app now and earn free errands",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text("after 5 referrals.",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0,),
                        SizedBox(
                          height: 45.0,
                          width: 250.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                              side: BorderSide(color: Color.fromRGBO(237,47,89, 1)),
                            ),
                            color: Color.fromRGBO(237,47,89, 1),
                            onPressed: (){
                              String text = "I use the Grep app to run my errand and I know you will like it. Try it.";
                              final RenderBox box = context.findRenderObject();
                              Share.share(text,
                                  sharePositionOrigin:
                                  box.localToGlobal(Offset.zero) &
                                  box.size);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.share, color: Colors.white,),
                                Text("  Share Now",
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height:25.0)
                      ],
                    ),
                    
                  )
              ),
              SizedBox(height: 60.0,),
            ],
          ),
        ),
      ),
    );
  }
}
