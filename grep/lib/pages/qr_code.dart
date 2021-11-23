import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCode extends StatefulWidget {
  QrCode({this.qr});

  final String qr;
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.xmark, color: Colors.white),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300.0,
              width: 300.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  border: Border.all(
                    color: Colors.white,
                    width: 5.0
                  ),
                  color:  Color.fromRGBO(237,47,89, 1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: QrImage(
                    data: widget.qr,
                    gapless: false,
                    foregroundColor: Colors.white,
                  ),
                )
              ),
            ),
            // SizedBox(
            //   height: 40.0,
            // ),
            // Padding(
            //   padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            //   child: IconButton(
            //     iconSize: 45.0,
            //     splashColor: Color.fromRGBO(75, 0, 130, 1),
            //     icon: Icon(CupertinoIcons.viewfinder_circle_fill, color: Colors.white),
            //     onPressed: () async { 
                  
            //     },
            //   ),
            // )
          ]
        )
      )
    );
  }
}