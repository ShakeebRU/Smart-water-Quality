// ignore_for_file: prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import 'package:myapp/themeh_helper.dart';
import 'package:myapp/dashboardpage.dart';
import 'package:myapp/header.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:email_auth/email_auth.dart';

class MyForgotPasswordVerificationPage extends StatefulWidget {
  const MyForgotPasswordVerificationPage({Key? key, required this.title})
      : super(key: key);
  final String title;
  @override
  _MyForgotPasswordVerificationPageState createState() =>
      _MyForgotPasswordVerificationPageState();
}

class _MyForgotPasswordVerificationPageState
    extends State<MyForgotPasswordVerificationPage> {
  final _formKey = GlobalKey<FormState>();

  EmailAuth emailAuth = EmailAuth(sessionName: "Smart Water");
  String otp = "";
  bool _pinSuccess = false;

  String _name = "";
  // ignore: prefer_final_fields, unused_field
  String _email = "";

  // ignore: unused_field
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();

  void getEmail(DatabaseReference databaseReference) async {
    var result = await databaseReference.child(_name).once();
    _email = result.snapshot.value.toString();
  }

  @override
  void initState() {
    super.initState();
    _name = widget.title;
    getEmail(_ref);
  }

  void sendOTP() async {
    EmailAuth emailAuth = new EmailAuth(sessionName: "Smart Water");
    bool result = await emailAuth.sendOtp(recipientMail: _email, otpLength: 4);
  }

  bool verify() {
    bool val = emailAuth.validateOtp(recipientMail: _email, userOtp: otp);
    return val;
  }

  Future<void> setpass() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref(_name);
      await ref.update({
        "password": otp,
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyDashBoard(title: _name)),
          (Route<dynamic> route) => false);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("May You have any internet issue...!")));
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
                child: HeaderWidget(
                    _headerHeight, true, Icons.privacy_tip_outlined),
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
                              'Verification',
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
                              'Enter the verification code we just sent you on your email address.',
                              style: TextStyle(
                                  // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
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
                            OTPTextField(
                              length: 6,
                              width: 300,
                              fieldWidth: 50,
                              style: TextStyle(fontSize: 30),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.underline,
                              onCompleted: (pin) {
                                otp = pin;
                                if (verify()) {
                                  setState(() {
                                    _pinSuccess = true;
                                  });
                                } else {
                                  setState(() {
                                    _pinSuccess = false;
                                  });
                                }
                              },
                            ),
                            SizedBox(height: 50.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "If you didn't receive a code! ",
                                    style: TextStyle(
                                      color: Colors.black38,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Resend',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        sendOTP();
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ThemeHelper().alartDialog(
                                                "Successful",
                                                "Verification code resend successful.",
                                                context);
                                          },
                                        );
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40.0),
                            Container(
                              decoration: _pinSuccess
                                  ? ThemeHelper().buttonBoxDecoration(context)
                                  : ThemeHelper().buttonBoxDecoration(
                                      context, "#AAAAAA", "#757575"),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Verify".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: _pinSuccess
                                    ? () {
                                        setpass();
                                      }
                                    : null,
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
