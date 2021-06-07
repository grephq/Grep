import 'package:flutter/material.dart';
import 'package:grep_build3/pages/loading.dart';
import 'package:http/http.dart';

class Forgotpassword extends StatefulWidget {
  @override
  _ForgotpasswordState createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {

  FocusNode myFocusNode = new FocusNode();
  String email;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String url= "https://tomiwa.com.ng/grepworks/reset/forgotpassword.php";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        backgroundColor: Color(0xFFED2F59)
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
        margin: EdgeInsets.all(35.0),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .20),
            Text("Reset Password",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40.0
              ),
            ),
            SizedBox(height: 25.0),
            Form(
              key: _formKey,
              child: TextFormField(
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
                  labelStyle: TextStyle(
                      color: myFocusNode.hasFocus ? Colors.grey : Colors.grey
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            _isLoading ? CircleLoading() : SizedBox(
              height: 55.0,
              width: 400.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  side: BorderSide(color: Color.fromRGBO(237,47,89, 1)),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                   setState(() {
                     _isLoading = true;
                   });
                    Response response = await post(url, body:{
                      "email" : email
                    });
                    print(response.body);
                    if(response.statusCode == 200){
                      setState(() {
                        _isLoading = false;
                      });
                      showDialog(
                        context: context,
                        builder: (_) => new AlertDialog(
                          title: new Text("Notice"),
                          content: new Text("You will receive a mail if this email is registered with us"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        )
                      );
                    }else{
                      setState(() {
                        _isLoading = false;
                      });
                      showDialog(
                        context: context,
                        builder: (_) => new AlertDialog(
                          title: new Text("Oops"),
                          content: new Text("Soemthing went wrong"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        )
                      );
                    }
                  }
                },
                color: Color.fromRGBO(237,47,89, 1),
                child: Text("Reset",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}
