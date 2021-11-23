import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:start_jwt/json_web_token.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
  Profile({this.fullname, this.email, this.phone, this.refcode, this.address});

  String fullname;
  String email;
  String phone;
  String refcode;
  String address;
}

class _ProfileState extends State<Profile> {

  bool loading = false;
  TextEditingController tecEmail = new TextEditingController();
  TextEditingController tecPhone = new TextEditingController();
  TextEditingController tecAddress = new TextEditingController();
  DateTime pickedDate;
  final GlobalKey<FormState> keyEmail = GlobalKey<FormState>();
  final GlobalKey<FormState> keyPhone = GlobalKey<FormState>();
  final GlobalKey<FormState> keyAddress = GlobalKey<FormState>();
  SharedPreferences data;
  String email, phone, address;
  final jwt = new JsonWebTokenCodec(secret: 'OBbyzm1zv7m9oJ5wI5rNhuFHX37gPA');
  
  String validator(String value){
    if(value.isEmpty){
      return "*This field cannot be empty";
    }else{
      return null;
    }
  }
  
  void initState(){
    super.initState();
    print(widget.address);
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return '*Required';
    if (!regex.hasMatch(value))
      return '*Enter a valid email';
    else
      return null;
  }

  String phoneNoValidator(String value){
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{11,13}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return '*Enter mobile number';
    }
    else if (!regExp.hasMatch(value)) {
      return '*Enter valid mobile number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 238, 238, 1),
      appBar: AppBar(
        title: Text("Profile",),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Color(0xFFED2F59),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 230,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)),
                      color: Color(0xFFED2F59)
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(height:20.0),
                            Icon(CupertinoIcons.person_alt_circle_fill, size: 95.0, color: Colors.white,),
                            SizedBox(height: 30.0),
                            Text(widget.fullname,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 25.0
                              ),
                            )
                          ],
                        )
                      ),
                    )
                  )
                ),
                SizedBox(height: 25.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .9,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Colors.white
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(height: 10.0),
                            ListTile(
                              title: Text("Email",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: (){
                                  showDialog(
                                      context: context,
                                      builder: (_) => new AlertDialog(
                                        title: new Text("Edit Email"),
                                        content: StatefulBuilder(
                                          builder: (context, setState) {
                                            return loading ? SizedBox(
                                              height: 50.0,
                                              width: 50.0,
                                              child: Center(
                                                child: LinearProgressIndicator(),
                                              ),
                                            ) : Form(
                                              key: keyEmail,
                                              child: TextFormField(
                                                onChanged: (_email)=> email = _email,
                                                controller: tecEmail,
                                                validator: emailValidator,
                                                cursorColor: Color.fromRGBO(237,47,89, 1),
                                                keyboardType: TextInputType.text,
                                                textCapitalization: TextCapitalization.words,
                                              ),
                                            );
                                          }
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Close'),
                                            onPressed: () {
                                              Navigator.of(context, rootNavigator:true).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Submit'),
                                            onPressed: () async{
                                              if(keyEmail.currentState.validate()){
                                                try{
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  final e = jwt.encode({
                                                    "newemail" : email,
                                                    "email_" : widget.email
                                                  });
                                                  Response response = await post("https://tomiwa.com.ng/grepworks/update.php", body: {
                                                    "email" : e
                                                  });
                                                  if(response.body.isNotEmpty){
                                                    data = await SharedPreferences.getInstance();
                                                    data.setString("email", email);
                                                    setState(() {
                                                      widget.email = email;
                                                      loading = false;
                                                    });
                                                    tecEmail.clear();
                                                    Navigator.of(context, rootNavigator:true).pop();
                                                  }
                                                }catch(Exception){
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                  showSimpleNotification(
                                                  Text("Oops"),
                                                  background: Color.fromRGBO(237, 47, 89, 1),
                                                  duration: Duration(seconds: 1),
                                                  subtitle: Text("No internet connection.")
                                                  );
                                                }
                                              }
                                            },
                                          )
                                        ],
                                      )
                                  );  
                                },
                              ),
                              subtitle: Text(widget.email),
                            ),
                            Divider(height: 1.0),
                            SizedBox(height: 10.0),
                            ListTile(
                              title: Text("Phone",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: (){
                                  showDialog(
                                      context: context,
                                      builder: (_) => new AlertDialog(
                                        title: new Text("Edit Phone"),
                                        content: StatefulBuilder(
                                          builder: (context, setState) {
                                            return loading ? SizedBox(
                                              height: 50.0,
                                              width: 50.0,
                                              child: Center(
                                                child: LinearProgressIndicator(),
                                              ),
                                            ) : Form(
                                              key: keyPhone,
                                              child: TextFormField(
                                                onChanged: (_phone)=> phone = _phone,
                                                controller: tecPhone,
                                                validator: phoneNoValidator,
                                                cursorColor: Color.fromRGBO(237,47,89, 1),
                                                keyboardType: TextInputType.text,
                                                textCapitalization: TextCapitalization.words,
                                              ),
                                            );
                                          }
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Close'),
                                            onPressed: () {
                                              Navigator.of(context, rootNavigator:true).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Submit'),
                                            onPressed: () async{
                                              if(keyPhone.currentState.validate()){
                                                try{
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  final p = jwt.encode({
                                                    "email" : widget.email,
                                                    "phone_" : phone,
                                                  });
                                                  Response response = await post("https://tomiwa.com.ng/grepworks/update.php", body: {
                                                    "phone" : p
                                                  });
                                                  if(response.body.isNotEmpty){
                                                    data = await SharedPreferences.getInstance();
                                                    data.setString("phone", phone);
                                                    setState(() {
                                                      widget.phone = phone;
                                                      loading = false;
                                                    });
                                                    tecPhone.clear();
                                                    Navigator.of(context, rootNavigator:true).pop();
                                                  }
                                                }catch(Exception){
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                  showSimpleNotification(
                                                  Text("Oops"),
                                                  background: Color.fromRGBO(237, 47, 89, 1),
                                                  duration: Duration(seconds: 1),
                                                  subtitle: Text("No internet connection.")
                                                  );
                                                }
                                              }
                                            },
                                          )
                                        ],
                                      )
                                  );
                                },
                              ),
                              subtitle: Text(widget.phone)
                            ),
                            Divider(height: 1.0),
                            SizedBox(height: 10.0),
                            ListTile(
                              title: Text("Referral Code",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              subtitle: SelectableText(widget.refcode)
                            ),
                            Divider(height: 1.0),
                            SizedBox(height: 10.0),   
                            ListTile(
                              title: Text("Address",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: (){
                                  showDialog(
                                      context: context,
                                      builder: (_) => new AlertDialog(
                                        title: new Text("Edit Address"),
                                        content: StatefulBuilder(
                                          builder: (context, setState) {
                                            return loading ? SizedBox(
                                              height: 50.0,
                                              width: 50.0,
                                              child: Center(
                                                child: LinearProgressIndicator(),
                                              ),
                                            ) : Form(
                                              key: keyAddress,
                                              child: TextFormField(
                                                onChanged: (_address)=> address = _address,
                                                controller: tecAddress,
                                                validator: validator,
                                                cursorColor: Color.fromRGBO(237,47,89, 1),
                                                keyboardType: TextInputType.text,
                                                textCapitalization: TextCapitalization.words,
                                              ),
                                            );
                                          }
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Close'),
                                            onPressed: () {
                                              Navigator.of(context, rootNavigator:true).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Submit'),
                                            onPressed: () async{
                                              //print(widget.address);
                                              if(keyAddress.currentState.validate()){
                                                try{
                                                  setState(() {
                                                    loading = true;
                                                  });
                                                  final a = jwt.encode({
                                                    "email" : widget.email,
                                                    "address_" : address,
                                                  });
                                                  Response response = await post("https://tomiwa.com.ng/grepworks/update.php", body: {
                                                    "address" : a
                                                  });
                                                  if(response.body.isNotEmpty){
                                                    data = await SharedPreferences.getInstance();
                                                    data.setString("address", address);
                                                    print(data.getString("address"));
                                                    setState(() {
                                                      widget.address = address;
                                                      loading = false;
                                                    });
                                                    tecAddress.clear();
                                                    print("success");
                                                    Navigator.of(context, rootNavigator:true).pop();
                                                  }
                                                }catch(Exception){
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                  showSimpleNotification(
                                                  Text("Oops"),
                                                  background: Color.fromRGBO(237, 47, 89, 1),
                                                  duration: Duration(seconds: 1),
                                                  subtitle: Text("No internet connection.")
                                                  );
                                                }
                                              }
                                            },
                                          )
                                        ],
                                      )
                                  );
                                },
                              ),
                              subtitle: SelectableText(widget.address == null ? "" : widget.address)
                            ),
                            Divider(height: 1.0),
                            SizedBox(height: 10.0),        
                          ],
                        )
                      ),
                    )
                    )
                  )
                )
              ],
            ),
          ),
        ),
      )
      
    );
  }
}