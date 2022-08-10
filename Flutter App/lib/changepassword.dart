// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:myapp/themeh_helper.dart';
import 'package:myapp/header.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/dashboardpage.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _ChangepasswordPageState createState() => _ChangepasswordPageState();
}

class _ChangepasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  String _name = " ";
  String _passwordcopy = " ";
  String _passwordV = " ";

  final password = TextEditingController();
  final passwordNew = TextEditingController();
  final passwordValid = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name = widget.title;
    _activateListeners();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    password.dispose();
    passwordNew.dispose();
    passwordValid.dispose();
    super.dispose();
  }

  void _activateListeners() {
    _ref.child('$_name/password').onValue.listen((event) {
      final String password = event.snapshot.value.toString();
      setState(() {
        _passwordV = password;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // ignore: sized_box_for_whitespace
            Container(
              height: 150,
              child: HeaderWidget(150, false, Icons.lock_open_rounded),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                'Old Password', 'Enter your old password'),
                            controller: password,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please Re-enter your password";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                'New Password', 'Enter your New Password'),
                            controller: passwordNew,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                'New Password', 'Re-Enter your New Password'),
                            controller: passwordValid,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please Re-enter your password";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Change Password".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (password.text == _passwordV) {
                                  _passwordcopy = passwordNew.text;
                                  try {
                                    DatabaseReference ref =
                                        FirebaseDatabase.instance.ref(_name);
                                    await ref.update({
                                      "password": _passwordcopy,
                                    });
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyDashBoard(title: _name)),
                                        (Route<dynamic> route) => false);
                                  } catch (err) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "May You have any internet issue...!")));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Old Password is incorrect"),
                                  ));
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
