import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCode extends StatefulWidget {
  QrCode({this.qr});

  final String qr;
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {

  GlobalKey globalKey = new GlobalKey();

  Future<void> saveQrCode() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      if (!await Directory("/storage/emulated/0/Grep").exists()){
        Directory("/storage/emulated/0/Grep").create();
      }
      final file = await File('/storage/emulated/0/Grep/image.png').create();
      await file.writeAsBytes(pngBytes);
    } catch(e) {
      print(e.toString());
    }
  }


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
                  child: RepaintBoundary(
                    key: globalKey,
                    child: QrImage(
                      data: widget.qr,
                      gapless: false,
                      foregroundColor: Colors.white,
                    ),
                  )
                )
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
              child: IconButton(
                iconSize: 30.0,
                splashColor: Color.fromRGBO(237,47,89, 1),
                icon: Icon(Icons.download_sharp, color: Colors.white),
                onPressed: () async {
                  if(Platform.isAndroid){
                    var storageStatus = await Permission.storage.status;
                    var accessMediaLocationStatus = await Permission.accessMediaLocation.status;
                    if(storageStatus.isGranted && accessMediaLocationStatus.isGranted){
                      saveQrCode();
                    }else{
                      await Permission.storage.request();
                    }
                  }
                },
              ),
            )
          ]
        )
      )
    );
  }
}