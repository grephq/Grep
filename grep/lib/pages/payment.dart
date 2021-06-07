import 'package:flutter/material.dart';



class Payment extends StatefulWidget {
  const Payment({Key key, this.fullname, this.balance, this.email}) : super(key: key);

  

  @override
  _PaymentState createState() => _PaymentState();
  final String fullname;
  final String balance;
  final String email;
}

class _PaymentState extends State<Payment> {

  bool showCVV = false;
  
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.account_balance_wallet, color: Colors.white, size: 100.0,),
              Text("Coming soon",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
                ),
              )
            ],
          ),
        )
      )
    );
  }
}