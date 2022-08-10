// ignore_for_file: prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myapp/header.dart';
import 'package:myapp/themeh_helper.dart';
import 'package:myapp/forgetpsdvarifypage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:email_auth/email_auth.dart';

class MyForgetPaswdPage extends StatefulWidget {
  const MyForgetPaswdPage({Key? key}) : super(key: key);

  @override
  _MyForgetPaswdPageState createState() => _MyForgetPaswdPageState();
}

class _MyForgetPaswdPageState extends State<MyForgetPaswdPage> {
  final _formKey = GlobalKey<FormState>();

  String usernameV = "";
  String _email = "";
  final username = TextEditingController();

  void callEmail() {
    _ref.child('$usernameV/email').onValue.listen((event) {
      final String email = event.snapshot.value.toString();
      setState(() {
        _email = email;
      });
    });
  }

  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  Future<bool> isUserRegistered(DatabaseReference databaseReference) async {
    var result = await databaseReference.once();
    if (result.snapshot.value != null) {
      callEmail();
      return true;
    } else {
      return false;
    }
  }

  void sendOTP() async {
    EmailAuth emailAuth = new EmailAuth(sessionName: "Smart Water");
    bool result = await emailAuth.sendOtp(recipientMail: _email, otpLength: 4);
    if (result == true) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("OTP Send"),
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MyForgotPasswordVerificationPage(title: _email)),
        );
      });
    } else {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("OTP Sending failed")));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _headerHeight = 300;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ignore: sized_box_for_whitespace
              Container(
                height: _headerHeight,
                child:
                    HeaderWidget(_headerHeight, true, Icons.password_rounded),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Enter the Username associated with your account.',
                              style: TextStyle(
                                  // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'We will email you a verification code to check your authenticity.',
                              style: TextStyle(
                                color: Colors.black38,
                                // fontSize: 20,
                              ),
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TextFormField(
                                decoration: ThemeHelper().textInputDecoration(
                                    "Usernme", "Enter your username"),
                                controller: username,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Enter your username";
                                  }
                                  return null;
                                },
                              ),
                              decoration:
                                  ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 40.0),
                            Container(
                              decoration:
                                  ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Send".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    usernameV = username.text;
                                    if (await isUserRegistered(
                                        _ref.child(usernameV))) {
                                      sendOTP();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("username dosn't exist"),
                                      ));
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: "Remember your password? "),
                                  TextSpan(
                                    text: 'Login',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Navigator.push(
                                        // context,
                                        //  MaterialPageRoute(
                                        //      builder: (context) => MyLogin()),
                                        //);
                                        Navigator.of(context).pop();
                                      },
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
