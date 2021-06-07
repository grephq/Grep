import 'dart:convert';
import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:grep_build3/pages/homepage.dart';
import 'package:start_jwt/json_web_token.dart';
import 'package:grep_build3/pages/start.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';
import 'loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String fullname, email, phone, password, referrer;
  bool loading = false;
  bool referred = false;
  FocusNode myFocusNode = new FocusNode();
  SharedPreferences logindata;
  TextEditingController tecRef = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  Future<void> _scan() async {
    try{
      String codeScanner = await BarcodeScanner.scan();
      setState(() {
        tecRef.text = codeScanner;
      });
    } on PlatformException catch(e){
      String codeScanner = await BarcodeScanner.scan();
      setState(() {
        tecRef.text = codeScanner;
      });
    }on FormatException{
      
    } catch (Exception) {
      
    }
  }

  Future setSharedData(String fullname, String email, String phone, String refcode, String errands, String birthday, int noErrands, String address) async{
    logindata = await SharedPreferences.getInstance();
    logindata.setBool("login", true);
    logindata.setString("fullname", fullname);
    logindata.setString("email", email);
    logindata.setString("phone", phone);
    logindata.setString("refcode", refcode);
    logindata.setString("free", errands);
    logindata.setString("birthday", birthday);
    logindata.setInt("noErrand", noErrands);
    logindata.setString("address", address);
    //logindata.setBool("showShowcase", true);
  }

  Future checkEmailExists(String email, String fullname, String phone, String password, String referrer) async{
    try{
      Response k = await post("https://tomiwa.com.ng/grepworks/checkemailexist.php", body: {
        "email" : email
      });
      if(k.body.isNotEmpty){
        referralSystem(referrer, email, fullname, phone, password);
      }else{
        setState(() {
          loading = false;
        });
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Text("Invalid Email"),
              content: new Text("The email belongs to an existing account"),
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
    }catch(Exception){
      setState(() {
        loading = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) => new AlertDialog(
            title: new Text("Oops"),
            content: new Text("No internet connection"),
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

  Future register(String fullname, String email, String phone, String password) async {
    var values;
    final jwt = new JsonWebTokenCodec(secret: 'OBbyzm1zv7m9oJ5wI5rNhuFHX37gPA');
    final enc = jwt.encode({
      "fullname" : fullname,
      "email" : email.toLowerCase(),
      "phone" : phone,
      "pwd" : password,
      "refcode" : "${fullname[0]}${fullname[1]}${fullname[2]}${email[0]}${email[1]}${email[2]}${phone[7]}${phone[5]}${phone[6]}".toUpperCase()
    });
    try{
      Response response = await post("https://tomiwa.com.ng/grepworks/grepregister200.php", body: {
        "register" : enc
      });
      if(response.body.isNotEmpty){
        final e = jwt.encode({
          "email" : email,
          "pwd" : password
        });
        try{
          Response response = await post("https://tomiwa.com.ng/grepworks/greplogin257.php", body: {
            "login" : e
          });
          
          values = jsonDecode(response.body);
          print(values['FullName']);
          if(response.body.isNotEmpty){
            setSharedData(values['FullName'], values['Email'], values['Phone'], values['ReferralCode'], values['FreeErrands'], values['Birthday'], int.parse(values['NoErrands']), values['Address']);
            setState(() {
              loading = false;
            });
            //initDatabase(values['FirstName'], values['LastName'], values['Email'], values['Phone']);

          }else{
            print("something went wrong");
          }
        }catch(Exception){
          setState(() {
            loading = false;
          });
          print(jwt.decode(response.body));
          values = jwt.decode(response.body);
          print(values['FullName']);
          print("Sign in Failed");
        }
        setState(() {
          loading = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
              title: new Text("Registration Successful"),
              content: new Text("Your account has been created"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomePage(fullname: values['FullName'], email: values['Email'], phone: values['Phone'], refcode: values['ReferralCode'], free: values['FreeErrands'], birthday: values['Birthday'], address: values['Address'], noErrands: int.parse(values['NoErrands']),)), (route) => false);
                  },
                )
              ],
            )
        );
        

      }
    }catch(Exception){
      showDialog(
          context: context,
          builder: (BuildContext context) => new AlertDialog(
            title: new Text("Oops"),
            content: new Text("No internet connection"),
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

  Future referralSystem(String referrer, String email, String fullname, String phone, String password) async{
    if(referred){
      
      try{
        Response r = await post("https://tomiwa.com.ng/grepworks/referrercheck.php", body: {
          "referrer" : referrer
        });
          print(r.body);
        if(r.body.isNotEmpty){
          var refemail = jsonDecode(r.body);
   
          Response f = await post("https://tomiwa.com.ng/grepworks/freeerrand.php", body: {
            "referrer" : refemail['Referrer']
          });
          if(f.body.isNotEmpty){
            register(fullname, email, phone, password);
          }else{
            print("ref user not updated");
          }
        }else{
          setState(() {
            loading = false;
            referred = false;
            tecRef.clear();
          });
          showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                title: new Text("Incorrect Referral Code"),
                content: new Text("The referral code does not exist"),
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
      }catch(Exception){
        print("could not connect");
        setState(() {
          loading = false;
        });
      }
    }else{
      register(fullname, email, phone, password);
    }
  }
  bool _checkBoxValue = false;
  void checkBoxState(){
    _checkBoxValue = !_checkBoxValue;
  }
  String pwdValidator(String value) {
    if (value.isEmpty) {
      return '*Password cannot be empty';
    } else if(value.length < 8){
      return '*Password must 8 characters or more';
    }else {
      return null;
    }
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
  String nameValidator(String value){
    Pattern pattern =
        r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    RegExp regex = new RegExp(pattern);
    Pattern p2 = r'.*\s.*';
    RegExp r2 = new RegExp(p2);
    if (!regex.hasMatch(value))
      return '*Enter a valid name';
    else if(!r2.hasMatch(value))
      return '*Enter your lastname and firstname';
    else
      return null;

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

  Widget registerButton(){
    return loading ? CircleLoading() : SizedBox(
      height: 55.0,
      width: 400.0,
      child: RaisedButton(
        // disabledColor: Colors.grey,
        // disabledTextColor: Colors.black12,
        onPressed: _checkBoxValue ? () async {
          if(_formKey.currentState.validate()){
            setState(() {
              loading = true;
            });
            checkEmailExists(email, fullname, phone, password, referrer);
          }
        } : null,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
          //side: BorderSide(color: Color.fromRGBO(237,47,89, 1)),
        ),
        color: Color.fromRGBO(237,47,89, 1),
        child: Text("Sign Up",
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
    return Scaffold(
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
          child: Container(
            margin: EdgeInsets.only(bottom:35.0, left:35.0, right:35.0, top:10.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * .008,
                ),
                Text("Register",
                  style: TextStyle(
                    fontFamily: 'Spartan',
                    fontWeight: FontWeight.w700,
                    fontSize: 40
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .07,
                ),
                Form(
                    key: _formKey,
                    //autovalidate: _autoValidate,
                    child: Column(
                      children: [
                        TextFormField(
                          //controller: tecEmail,
                          cursorColor: Color.fromRGBO(237,47,89, 1),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          validator: nameValidator,
                          onChanged: (_fullname)=> fullname = _fullname,
                          decoration: new InputDecoration(
                            hintText: "Full Name",
                            prefixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 0.0),
                              child: Icon(
                                Icons.person_outline_outlined,
                                color: Color.fromRGBO(237,47,89, 1),
                              ),
                            ) ,
                            //labelText: "First Name",
                            labelStyle: TextStyle(
                                color: myFocusNode.hasFocus ? Colors.grey : Colors.grey
                            ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: const BorderSide(color: Colors.pink, width: 2.0),
                            // ),
                            // border: new OutlineInputBorder(
                            //   borderRadius: new BorderRadius.circular(5.0),
                            // ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          //controller: tecEmail,
                          cursorColor: Color.fromRGBO(237,47,89, 1),
                          validator: emailValidator,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_email)=> email = _email,
                          decoration: new InputDecoration(
                            hintText: "Email",
                            prefixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 0.0),
                              child: Icon(
                                Icons.alternate_email,
                                color: Color.fromRGBO(237,47,89, 1),
                              ),
                            ) ,
                            //labelText: "E-Mail",
                            labelStyle: TextStyle(
                                color: myFocusNode.hasFocus ? Colors.grey : Colors.grey
                            ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: const BorderSide(color: Colors.pink, width: 2.0),
                            // ),
                            // border: new OutlineInputBorder(
                            //   borderRadius: new BorderRadius.circular(5.0),
                            // ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          //controller: tecEmail,
                          cursorColor: Color.fromRGBO(237,47,89, 1),
                          validator: phoneNoValidator,
                          keyboardType: TextInputType.phone,
                          onChanged: (_phone)=> phone = _phone,
                          decoration: new InputDecoration(
                            hintText: "Phone Number",
                            prefixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 0.0),
                              child: Icon(
                                Icons.phone,
                                color: Color.fromRGBO(237,47,89, 1),
                              ),
                            ) ,
                            //labelText: "Phone Number",
                            labelStyle: TextStyle(
                                color: myFocusNode.hasFocus ? Colors.grey : Colors.grey
                            ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: const BorderSide(color: Colors.pink, width: 2.0),
                            // ),
                            // border: new OutlineInputBorder(
                            //   borderRadius: new BorderRadius.circular(5.0),
                            // ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          //controller: tecPassword,
                          validator: pwdValidator,
                          onChanged: (_password)=> password = _password,
                          enableSuggestions: false,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !_passwordVisible,
                          cursorColor: Color.fromRGBO(237,47,89, 1),
                          decoration: new InputDecoration(
                            hintText: "Password",
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
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 0.0),
                              child: Icon(
                                Icons.lock_outline,
                                color: Color.fromRGBO(237,47,89, 1),
                              ),
                            ) ,
                            //labelText: "Password",
                            labelStyle: TextStyle(
                                color: myFocusNode.hasFocus ? Colors.grey : Colors.grey
                            ),
                            // border: new OutlineInputBorder(
                            //   borderRadius: new BorderRadius.circular(5.0),
                            // ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: const BorderSide(color: Colors.pink, width: 2.0),
                            // ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        TextFormField(
                          controller: tecRef,
                          onChanged: (_ref){
                             referrer = _ref;
                             setState(() {
                               referred = true;
                             });
                          },
                          cursorColor: Color.fromRGBO(237,47,89, 1),
                          decoration: new InputDecoration(
                            hintText: "Referral Code: Optional",
                            suffixIcon: IconButton(
                              icon : Icon(
                                Icons.camera_alt_outlined,
                                color: Color.fromRGBO(237,47,89, 1),
                              ),
                              onPressed: (){
                                _scan();
                              },
                            ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 25.0, 0.0),
                              child: Icon(
                                Icons.qr_code_scanner,
                                color: Color.fromRGBO(237,47,89, 1),
                              ),
                            ) ,
                            //labelText: "Password",
                            labelStyle: TextStyle(
                                color: myFocusNode.hasFocus ? Colors.grey : Colors.grey
                            ),
                            // border: new OutlineInputBorder(
                            //   borderRadius: new BorderRadius.circular(5.0),
                            // ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: const BorderSide(color: Colors.pink, width: 2.0),
                            // ),
                          ),
                        ),
                      ],
                    ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      value: _checkBoxValue,
                      activeColor: Color.fromRGBO(237,47,89, 1),
                      onChanged: (_checkBoxValue){
                        setState(() {
                          checkBoxState();
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Agree to our "),
                        FlatButton(
                          padding: EdgeInsets.only(right: 5.0),
                          onPressed: () {
                            
                          },
                          color: Colors.white,
                          child: Text("Terms & Conditions",
                            style: TextStyle(
                                color: Color.fromRGBO(237,47,89, 1)
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20,),
                registerButton(),
                SizedBox(
                  height: 20,
                ),
                
              ],
            ),
          ),
        ),
    );
  }
}
