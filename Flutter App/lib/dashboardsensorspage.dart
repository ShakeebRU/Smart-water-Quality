// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:myapp/dashboardpage.dart';
import 'package:myapp/logoutanimation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/changepassword.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyDashBoardSensors extends StatefulWidget {
  const MyDashBoardSensors({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _MyDashBoardSensorsState createState() => _MyDashBoardSensorsState();
}

class _MyDashBoardSensorsState extends State<MyDashBoardSensors> {
  final double _drawerIconSize = 24;

  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  String _name = "";
  String _username = "";
  var data;
  List<String> tds = <String>['', '', '', '', '', '', ''];
  List<String> td = <String>['', '', '', '', '', '', ''];
  List<String> temp = <String>['', '', '', '', '', '', ''];
  List<String> ph = <String>['', '', '', '', '', '', ''];
  String url = 'http://192.168.43.169:5000/';

  @override
  void initState() {
    _apicall();
    super.initState();
    _name = widget.title;
    _activateListeners();
  }

  fetchdata(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    return response.body;
  }

  bool isLoadingEnded = false;
  Future<void> _apicall() async {
    data = await fetchdata(url);
    var decoded = jsonDecode(data);
    isLoadingEnded = true;
    setState(() {
      tds[0] = decoded['tds1'];
      tds[1] = decoded['tds2'];
      tds[2] = decoded['tds3'];
      tds[3] = decoded['tds4'];
      tds[4] = decoded['tds5'];
      tds[5] = decoded['tds6'];
      tds[6] = decoded['tds7'];
      td[0] = decoded['td1'];
      td[1] = decoded['td2'];
      td[2] = decoded['td3'];
      td[3] = decoded['td4'];
      td[4] = decoded['td5'];
      td[5] = decoded['td6'];
      td[6] = decoded['td7'];
      temp[0] = decoded['tempm1'];
      temp[1] = decoded['tempm2'];
      temp[2] = decoded['tempm3'];
      temp[3] = decoded['tempm4'];
      temp[4] = decoded['tempm5'];
      temp[5] = decoded['tempm6'];
      temp[6] = decoded['tempm7'];
      ph[0] = decoded['ph1'];
      ph[1] = decoded['ph2'];
      ph[2] = decoded['ph3'];
      ph[3] = decoded['ph4'];
      ph[4] = decoded['ph5'];
      ph[5] = decoded['ph6'];
      ph[6] = decoded['ph7'];
    });
  }

  void _activateListeners() {
    _ref.child('$_name/name').onValue.listen((event) {
      final String username = event.snapshot.value.toString();
      setState(() {
        _username = username;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingEnded
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                "Water Forecast",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              elevation: 0.5,
              iconTheme: IconThemeData(color: Colors.white),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                      Theme.of(context).primaryColor,
                      Theme.of(context).colorScheme.secondary,
                    ])),
              ),
            ),
            drawer: Drawer(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [
                      0.0,
                      1.0
                    ],
                        colors: [
                      Theme.of(context).primaryColor.withOpacity(0.2),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                    ])),
                child: ListView(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.0, 1.0],
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          _username,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.screen_lock_landscape_rounded,
                        size: _drawerIconSize,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Dashboard',
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyDashBoard(
                                      title: _name,
                                    )));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.screen_lock_landscape_rounded,
                        size: _drawerIconSize,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Change Password',
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePasswordPage(
                                      title: _name,
                                    )));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.screen_lock_landscape_rounded,
                        size: _drawerIconSize,
                        color: Colors.black,
                      ),
                      title: Text(
                        'logOut',
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DashBox(title: "Profile")));
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Forcasted Values',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 4.0, top: 6.0),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Sensor values on Day-1",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Card(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          ...ListTile.divideTiles(
                                            color: Colors.grey,
                                            tiles: [
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                //leading: Text(""),
                                                title: Text("PH Value"),
                                                trailing: Text(ph[0]),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("Turbidity"),
                                                trailing: Text(td[0] + " NTU"),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("TDS Value"),
                                                trailing: Text(tds[0] + " ppm"),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("Temperature"),
                                                trailing: Text(temp[0] + " C"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 4.0, top: 6.0),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Sensor values on Day-2",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Card(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          ...ListTile.divideTiles(
                                            color: Colors.grey,
                                            tiles: [
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                //leading: Text(""),
                                                title: Text("PH Value"),
                                                trailing: Text(ph[1]),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("Turbidity"),
                                                trailing: Text(td[1] + " NTU"),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("TDS Value"),
                                                trailing: Text(tds[1] + " ppm"),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("Temperature"),
                                                trailing: Text(temp[1] + " C"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 4.0, top: 6.0),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Sensor values on Day-3",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Card(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          ...ListTile.divideTiles(
                                            color: Colors.grey,
                                            tiles: [
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                //leading: Text(""),
                                                title: Text("PH Value"),
                                                trailing: Text(ph[2]),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("Turbidity"),
                                                trailing: Text(td[2] + " NTU"),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("TDS Value"),
                                                trailing: Text(tds[2] + " ppm"),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("Temperature"),
                                                trailing: Text(temp[2] + " C"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 4.0, top: 6.0),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Sensor values on Day-4",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Card(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          ...ListTile.divideTiles(
                                            color: Colors.grey,
                                            tiles: [
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                //leading: Text(""),
                                                title: Text("PH Value"),
                                                trailing: Text(ph[3]),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("Turbidity"),
                                                trailing: Text(td[3] + " NTU"),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("TDS Value"),
                                                trailing: Text(tds[3] + " ppm"),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("Temperature"),
                                                trailing: Text(temp[3] + " C"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 4.0, top: 6.0),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Sensor values on Day-5",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Card(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          ...ListTile.divideTiles(
                                            color: Colors.grey,
                                            tiles: [
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                //leading: Text(""),
                                                title: Text("PH Value"),
                                                trailing: Text(ph[4]),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("Turbidity"),
                                                trailing: Text(td[4] + " NTU"),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("TDS Value"),
                                                trailing: Text(tds[4] + " ppm"),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("Temperature"),
                                                trailing: Text(temp[4] + " C"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 4.0, top: 6.0),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Sensor values on Day-6",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Card(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          ...ListTile.divideTiles(
                                            color: Colors.grey,
                                            tiles: [
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                //leading: Text(""),
                                                title: Text("PH Value"),
                                                trailing: Text(ph[5]),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("Turbidity"),
                                                trailing: Text(td[5] + " NTU"),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("TDS Value"),
                                                trailing: Text(tds[5] + " ppm"),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("Temperature"),
                                                trailing: Text(temp[5] + " C"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 8.0, bottom: 4.0, top: 6.0),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Sensor values on Day-7",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Card(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          ...ListTile.divideTiles(
                                            color: Colors.grey,
                                            tiles: [
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                //leading: Text(""),
                                                title: Text("PH Value"),
                                                trailing: Text(ph[6]),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("Turbidity"),
                                                trailing: Text(td[6] + " NTU"),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("TDS Value"),
                                                trailing: Text(tds[6] + " ppm"),
                                              ),
                                              ListTile(
                                                //leading: Text(""),
                                                title: Text("Temperature"),
                                                trailing: Text(temp[6] + " C"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
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
        : Center(child: new CircularProgressIndicator());
  }
}
