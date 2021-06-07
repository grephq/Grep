import 'package:flutter/material.dart';


// ignore: must_be_immutable
class HistoryInfo extends StatefulWidget {
  @override
  HistoryInfo({this.description, this.pickup, this.dropoff, this.status, this.date, this.id, this.responder, this.number, this.fullname, this.email, this.phone});

  String description;
  String pickup;
  String dropoff;
  String status;
  String date;
  String id;
  String responder;
  String number;
  String email;
  String fullname;
  String phone;

  _HistoryInfoState createState() => _HistoryInfoState();
}


class _HistoryInfoState extends State<HistoryInfo> {


String message;

bool loading = false;
bool available = true;
bool ongoing = false;
bool completed = false;

void initState(){
  if(widget.status.toUpperCase() == "ONGOING" ){
    setState(() {
      ongoing = true;
    });
  }
  if(widget.status.toUpperCase() == "COMPLETED" ){
    setState(() {
      ongoing = true;
      completed = true;
    });
  }
  super.initState();
}

String reviewValidate(String value){
  if(value.isEmpty){
    return "*This field cannot be empty";
  }else{
    return null;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black
        ),
        
      ),
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Order Status",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey[700]
                      ),
                    ),
                    Image.asset("assets/pay.png", scale: 10.0,)
                  ],
                ),
                SizedBox(height: 10.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .9,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Colors.white
                    ),
                    //color: Colors.white,
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 15.0,),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Your order ID",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black87
                                ),
                              ),
                            )
                          ),
                          SizedBox(height: 15.0,),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: SelectableText(widget.id,
                                style: TextStyle(
                                fontSize: 25.0,
                                color: Color.fromRGBO(237, 47, 89, 1),
                                )
                              )
                            )
                          ),
                          SizedBox(height: 10.0),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(widget.date,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey
                                ),
                              ),
                            )
                          ),
                          SizedBox(height: 20.0),
                          Divider(height: 1.0),
                          SizedBox(height: 30.0),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                child: Checkbox(
                                  value: available,
                                  activeColor: Color.fromRGBO(237,47,89, 1),
                                  onChanged: (_checkBoxValue){
                                    
                                  },
                                ),
                              ),
                              SizedBox(width: 30.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                    child: Text("Available",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blueGrey[700]
                                      ),
                                    )
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                child: Checkbox(
                                  value: ongoing,
                                  activeColor: Color.fromRGBO(237,47,89, 1),
                                  onChanged: (_checkBoxValue){
                                    
                                  },
                                ),
                              ),
                              SizedBox(width: 30.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                    child: Text("Ongoing",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blueGrey[700]
                                      ),
                                    )
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                child: Checkbox(
                                  value: completed,
                                  activeColor: Color.fromRGBO(237,47,89, 1),
                                  onChanged: (_checkBoxValue){
                                    
                                  },
                                ),
                              ),
                              SizedBox(width: 30.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                    child: Text("Completed",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blueGrey[700]
                                      ),
                                    )
                                  )
                                ],
                              ),
                              
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Divider(height: 1.0,),
                          SizedBox(height: 15.0,),
                          Align(
                            alignment: Alignment.center,
                            child: Text("Accepted By",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black87
                              ),
                            ),
                          ),
                          SizedBox(height: 15.0,),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Name: ",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black87
                                    ),
                                  ),
                                )
                              ),
                              SizedBox(width: 30.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                    child: Text(widget.status.toUpperCase() == "AVAILABLE" ? "" : widget.responder,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blueGrey[700]
                                      ),
                                    )
                                  )
                                ],
                              ),
                              
                            ],
                          ),
                          SizedBox(height:60.0)
                        ],
                      )
                    )
                  )
                ),
                SizedBox(height:20.0)
              ],
            ),
          ),
        )
      )
    );
  }
}