import 'package:flutter/material.dart';
import 'package:grep_build3/pages/start.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isdark = false;
  SharedPreferences logindata;
  Box box;

  _launchURL(String url) async{
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'Could not launch $url';
    }
  }

  Future removeSharedData() async{
    logindata = await SharedPreferences.getInstance();
    logindata.setBool("login", false);
    logindata.remove("fullname");
    logindata.remove("email");
    logindata.remove("phone");
    logindata.remove("refcode");
    logindata.remove("free");
    logindata.remove("birthday");
    logindata.remove("showShowcase");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Settings"),
        backgroundColor: Color(0xFFED2F59),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height:30.0),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Support"),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: Text("How Grep works"),
                    trailing: Icon(Icons.code),
                    onTap: () {
                    _launchURL("https://greperrands.com/");
                  },
                  ),
                  Divider(height:1.0),
                  ListTile(
                    title: Text("Contact Us"),
                    onTap: () {
                      _launchURL("https://greperrands.com/contact-us.html");
                    },
                    trailing: Image.asset("assets/phone.png", scale: 3.0,),
                  ),
                  Divider(height:1.0),
                  ListTile(
                    title: Text("Help Center (FAQs)"),
                    trailing: Image.asset("assets/info.png", scale: 3.0,),
                    onTap: () {
                      _launchURL("https://greperrands.com");
                    },
                  ),
                  Divider(height:1.0),
                  ListTile(
                    title: Text("Give us feedback"),
                    trailing: Image.asset("assets/feedback.png", scale: 3.0,),
                    onTap: () {
                      _launchURL("https://greperrands.com/contact-us.html");
                    },
                  ),
                  Divider(height:1.0),
                ],
              )
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Legal"),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: Text("Terms of Service"),
                    trailing: Icon(Icons.description),
                    onTap: () {
                      _launchURL("https://greperrands.com");
                    },
                  ),
                  Divider(height:1.0),
                  ListTile(
                    title: Text("Privacy"),
                    trailing: Image.asset("assets/security.png", scale: 3.0,),
                    onTap: () {
                      _launchURL("https://greperrands.com");
                    },
                  ),
                  Divider(height:1.0),
                  ListTile(
                    title: Text("Logout"),
                    trailing: Icon(Icons.logout),
                    onTap: () async{
                      var dir = await getApplicationDocumentsDirectory();
                      dir.deleteSync(recursive: true);
                      await removeSharedData();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Start()), (route) => false);
                      
                    },
                  ),
                  Divider(height:1.0),
                ],
              )
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.center,
              child: Text("Version: 1.0.0")
            )
          ],
        )
      )
    );
  }
}
