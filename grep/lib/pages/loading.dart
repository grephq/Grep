import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WaveLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(237,47,89, 1),
      child: Center(
        child: SpinKitWave(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}



class CircleLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   shape: BoxShape.rectangle,
      //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
      // ),
      color: Color.fromRGBO(237,47,89, 1),
      child: Center(
        child: SpinKitFadingCircle(
          color: Colors.white,
          size: 55.0,
        ),
      ),
    );
  }
}