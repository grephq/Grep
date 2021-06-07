import 'dart:async';
import 'dart:convert';
import 'package:start_jwt/json_web_token.dart';
import 'package:flutter/material.dart';
import 'package:grep_build3/pages/historyinfo.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';


class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
  History({this.email, this.fullname, this.phone});

  final String email;
  final String fullname;
  final String phone;
}

class _HistoryState extends State<History> {
  //StreamController _historyController;
  //final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Box box;
  List data = [];

  Future<bool> getAllData () async {
    await openBox();
    String url ='https://tomiwa.com.ng/grepworks/history.php';
    final jwt = new JsonWebTokenCodec(secret: 'OBbyzm1zv7m9oJ5wI5rNhuFHX37gPA');
    final encoded = jwt.encode({
      "email" : widget.email
    });
    try{
      var response = await http.post(url, body: {"history" : encoded});
      if(response.body.isNotEmpty){
        var decoded = jsonDecode(response.body);
        await putHistory(decoded);
      }
    }catch(SocketException){
      showSimpleNotification(
      Text("Oops"),
      background: Color.fromRGBO(237, 47, 89, 1),
      duration: Duration(seconds: 1),
      subtitle: Text("No internet connection.")
      );
    }

    var mymap = box.toMap().values.toList();
    if(mymap.isEmpty){
      data.add("Empty");
    }else{
      data = mymap;
    }
    return Future.value(true);
  }

  Future putHistory(history) async{
    await box.clear();
    for(var d in history){
      box.add(d);

    }
  }

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('history');
    return;
  }

  // Future fetchHistory() async {
  //   final response = await http.post('https://tomiwa.com.ng/grepworks/history.php', body: {"email" : widget.email});
  //   if(response.body.isNotEmpty){
  //     return jsonDecode(response.body);
  //   }
  // }

  // loadHistory() async {
  //   fetchHistory().then((value) async {
  //     _historyController.add(value);
  //   });
  // }

  // Future<Null> handleRefresh() async {
  //   fetchHistory().then((value) async {
  //     _historyController.add(value);
  //     return Null;
  //   });
  // }

  Future<void> updateData() async{
    String url ='https://tomiwa.com.ng/grepworks/history.php';
    final jwt = new JsonWebTokenCodec(secret: 'OBbyzm1zv7m9oJ5wI5rNhuFHX37gPA');
    final encoded = jwt.encode({
      "email" : widget.email
    });
    try{
      var response = await http.post(url, body: {"history" : encoded});
      if(response.body.isNotEmpty){
        var decoded = jsonDecode(response.body);
        await putHistory(decoded);
        setState(() {
          
        });
      }
    }catch(SocketException){
      showSimpleNotification(
      Text("Oops"),
      background: Color.fromRGBO(237, 47, 89, 1),
      duration: Duration(seconds: 1),
      subtitle: Text("No internet connection.")
      );
    }
  }

  // @override
  // void initState(){
  //   // _historyController = new StreamController();
  //   // loadHistory();
  //   super.initState();
  //   Timer.periodic(Duration(seconds: 3), (_) => handleRefresh());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0, 
        title: Text("History"),
        backgroundColor: Color(0xFFED2F59),
      ),
      body: FutureBuilder(
        future: getAllData(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(data.contains("Empty")){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/history.png"),
                    Text("No History",
                      style: TextStyle(
                        fontSize: 18.0
                      ),
                    )
                  ],
                )
              );
            }else{
             return Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    child: RefreshIndicator(
                      onRefresh: updateData,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index){
                          //var post = snapshot.data[index];
                          return Column(
                            children: [
                              SizedBox(height: 10.0,),
                              ListTile(
                                title: Text(data[index]['Description'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blueGrey[700]
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5.0),
                                    Text(data[index]['Date'],
                                      style: TextStyle(
                                        color: Colors.grey
                                      ),
                                    ),
                                    Text(data[index]['Status'].toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        color: data[index]['Status'].toUpperCase() != "Completed".toUpperCase()  ? ((data[index]['Status'].toUpperCase() == "Ongoing".toUpperCase()) ? Colors.yellow : Colors.red) : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 20.0),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => HistoryInfo(description: data[index]['Description'], pickup: data[index]['PickUp'], dropoff: data[index]['DropOff'] ,status: data[index]['Status'], id: data[index]['ID'], responder: data[index]['Responder'], number: data[index]['Number'], email: widget.email, fullname: widget.fullname, phone: widget.phone, date: data[index]['Date'],),
                                  ));
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                                child: Divider(
                                  height: 1.0,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            );
            }
          }else{
            return Center(child: CircularProgressIndicator());
            
          }
        },
      ),
    );
  }
}


// StreamBuilder(
//         stream: _historyController.stream,
//         builder: (BuildContext context, AsyncSnapshot snapshot){
          
//           if(snapshot.hasData){
//             return Column(
//               children: [
//                 Expanded(
//                   child: Scrollbar(
//                     child: RefreshIndicator(
//                       onRefresh: handleRefresh,
//                       child: ListView.builder(
//                         physics: const AlwaysScrollableScrollPhysics(),
//                         itemCount: snapshot.data.length,
//                         itemBuilder: (context, index){
//                           var post = snapshot.data[index];
//                           return Column(
//                             children: [
//                               SizedBox(height: 10.0,),
//                               ListTile(
//                                 title: Text(post['Description'],
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     color: Colors.blueGrey[700]
//                                   ),
//                                 ),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     SizedBox(height: 5.0),
//                                     Text(post['Date'],
//                                       style: TextStyle(
//                                         color: Colors.grey
//                                       ),
//                                     ),
//                                     Text(post['Status'].toUpperCase(),
//                                       style: TextStyle(
//                                         fontSize: 11.0,
//                                         color: post['Status'].toUpperCase() != "Completed".toUpperCase()  ? ((post['Status'].toUpperCase() == "Ongoing".toUpperCase()) ? Colors.yellow : Colors.red) : Colors.green,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 20.0),
//                                 onTap: (){
//                                   Navigator.push(context, MaterialPageRoute(
//                                     builder: (context) => HistoryInfo(description: post['Description'], location: post['Location'] ,status: post['Status'], id: post['ID'], responder: post['Responder'], number:post['Number'], email: widget.email, fullname: widget.fullname, phone: widget.phone, date: post['Date'],),
//                                   ));
//                                 },
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.only(left: 15.0, right: 15.0),
//                                 child: Divider(
//                                   height: 1.0,
//                                 ),
//                               )
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             );
//           }
//           if(snapshot.connectionState != ConnectionState.done){
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if(!snapshot.hasData && snapshot.connectionState == ConnectionState.done){
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text("No History",
//                     style: TextStyle(
//                       fontSize: 18.0
//                     ),
//                   )
//                 ],
//               ),
//             );
//           }
//         },
//       )