import 'dart:io';
import 'package:grep_build3/pages/forgotpassword.dart';
import 'package:grep_build3/pages/start.dart';
import 'loading.dart';
import 'package:grep_build3/pages/homepage.dart';
import 'package:grep_build3/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:start_jwt/json_web_token.dart';
import 'dart:convert';


class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email, password;
  bool loading = false;
  SharedPreferences logindata;
  FocusNode myFocusNode = new FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController tecEmail = new TextEditingController();
  TextEditingController tecPassword = new TextEditingController();
  bool _passwordVisible = true;

  Future setSharedData(String fullname, String email, String phone, String refcode, String errands, String birthday, int noErrands, String address) async{
    logindata = await SharedPreferences.getInstance();
    logindata.setBool("login", true);
    logindata.setString("fullname", fullname);
    logindata.setString("email", email);
    logindata.setString("phone", phone);
    logindata.setString("birthday", birthday.toString());
    logindata.setString("refcode", refcode);
    logindata.setString("free", errands);
    logindata.setInt("noErrand", noErrands);
    logindata.setString("address", address);
    //logindata.setBool("showShowcase", true);
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
  String pwdValidator(String value) {
    if (value.isEmpty) {
      return '*Password cannot be empty';
    } else {
      return null;
    }
  }


 

  Widget loginButton(){
    return SizedBox(
      height: 55.0,
      width: 400.0,
      child: RaisedButton(
        onPressed: () async {
          if(_formKey.currentState.validate()){
            try{
              final result = await InternetAddress.lookup('google.com');
              if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
                setState(() {
                  loading = true;
                });
                final jwt = new JsonWebTokenCodec(secret: 'OBbyzm1zv7m9oJ5wI5rNhuFHX37gPA');
              try{
                final encoded = jwt.encode({
                  "email" : email,
                  "pwd" : password
                });
                print(encoded);
                Response response = await post("https://tomiwa.com.ng/grepworks/greplogin257.php", body: {
                  "login" : encoded
                });
                var values = jsonDecode(response.body);
                print(values);
                if(response.body.isNotEmpty){
                  setSharedData(values['FullName'], values['Email'], values['Phone'], values['ReferralCode'], values['FreeErrands'], values['Birthday'], int.parse(values['NoErrands']), values['Address']);
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    HomePage(fullname: values['FullName'], email: values['Email'], phone: values['Phone'], refcode: values['ReferralCode'], free: values['FreeErrands'], birthday: values['Birthday'], address: values['Address'], noErrands: int.parse(values['NoErrands']),)
                  ), (route) => false);
                  print("it is working");

                }else{
                  print("something went wrong");
                }
              }catch(Exception){
                setState(() {
                  loading = false;
                });
                print("Sign in Failed");
                showDialog(
                    context: context,
                    builder: (BuildContext context) => new AlertDialog(
                      title: new Text("Login Failed"),
                      content: new Text("Invalid username or password"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context, rootNavigator:true).pop();
                          },
                        )
                      ],
                    )
                  );
                }
              }
            } on SocketException catch (_) {
              showDialog(
                    context: context,
                    builder: (BuildContext context) => new AlertDialog(
                      title: new Text("Oops"),
                      content: new Text("No Internet Connection ..."),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context, rootNavigator:true).pop();
                          },
                        )
                      ],
                    )
                  );
            }
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
          side: BorderSide(color: Color.fromRGBO(237,47,89, 1)),
        ),
        color: Color.fromRGBO(237,47,89, 1),
        child: Text("Sign In",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Spartan',
              fontWeight: FontWeight.w700
          ),
        ),
      ),
    );
  }


  Widget build(BuildContext context) {
    return loading ? WaveLoading() : Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Start()));
            },
          ), 
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
         child : Container(
            margin: EdgeInsets.all(35.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Image.asset("assets/grep_text_logo_black.png",
                  scale: 14.5
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        cursorColor: Color.fromRGBO(237,47,89, 1),
                        validator: emailValidator,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_email)=> email = _email,
                        decoration: new InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                              color: myFocusNode.hasFocus ? Colors.grey : Colors.grey
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.pink, width: 2.0),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Icon(
                              Icons.mail_outline,
                              color: Color.fromRGBO(237,47,89, 1),
                            ),
                          ) ,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: pwdValidator,
                        enableSuggestions: false,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (_password)=> password = _password,
                        obscureText: _passwordVisible,
                        cursorColor: Color.fromRGBO(237,47,89, 1),
                        decoration: new InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                              color: myFocusNode.hasFocus ? Colors.grey : Colors.grey
                          ),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.pink, width: 2.0),
                          ),
                          suffixIcon: IconButton(
                            icon : Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: (){
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Icon(
                              Icons.lock_outline,
                              color: Color.fromRGBO(237,47,89, 1),
                            ),
                          ) ,
                        ),
                      ),
                    ],
                  )
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Forgotpassword()
                        ));
                      },
                      color: Colors.white,
                      child: Text("Forgot Password?",
                        style: TextStyle(
                            color: Color.fromRGBO(237,47,89, 1)
                        ),
                      ),
                    ),
                  ]
                ),
                loginButton(),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  color: Colors.grey,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  color: Colors.white,
                  child: Text("Don't have an account? Register",
                    style: TextStyle(
                        color: Color.fromRGBO(237,47,89, 1)
                    ),
                  ),
                ),
                
                
              ],
            ),
          ),
        ),
    );
  }
}
