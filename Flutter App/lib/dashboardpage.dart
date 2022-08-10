// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myapp/dashboardsensorspage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/logoutanimation.dart';
import 'package:myapp/changepassword.dart';

class MyDashBoard extends StatefulWidget {
  const MyDashBoard({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  _MyDashBoardState createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  final double _drawerIconSize = 24;

  Color _qualitycolor = Colors.black12;
  final DatabaseReference _ref = FirebaseDatabase.instance.ref();
  int tmp = 0;
  int turb = 0;
  int ph = 0;
  int tds = 0;
  String _name = "";
  String _tds = "";
  String _turbidity = "";
  String _temperature = "";
  String _waterlevel = "";
  String _ph = "";
  String _username = "";
  String _qulity = "";
  String _waterstate = "";

  @override
  void initState() {
    super.initState();
    _name = widget.title;
    _activateListeners();
  }

  void _quality() {
    double comptds = double.parse(_tds);
    double comptemp = double.parse(_temperature);
    double compturb = double.parse(_turbidity);
    double compph = double.parse(_ph);

    if (comptemp > 6 && comptemp < 43.0) {
      tmp = 1;
    } else {
      tmp = 0;
    }
    if (compph > 6.5 && compph < 8.5) {
      ph = 1;
    } else {
      ph = 0;
    }
    if (comptds > 50 && comptds < 1000) {
      tds = 1;
    } else {
      tds = 0;
    }
    if (compturb > 0.1 && compturb < 5.0) {
      turb = 1;
    } else {
      turb = 0;
    }
    int result = ((5 * tmp) + (50 * turb) + (25 * tds) + (20 * ph));
    _qulity = result.toString() + "%";
    if (result >= 75) {
      _waterstate = "Drinkable";
      _qualitycolor = Colors.blueAccent;
    } else {
      _waterstate = "Not Drinkable";
      _qualitycolor = Colors.redAccent;
    }
  }

  void _activateListeners() {
    _ref.child('$_name/ph').onValue.listen((event) {
      final String ph = event.snapshot.value.toString();
      setState(() {
        _ph = ph;
        _quality();
      });
    });
    _ref.child('$_name/turbidity').onValue.listen((event) {
      final String turbidity = event.snapshot.value.toString();
      setState(() {
        _turbidity = turbidity;
        _quality();
      });
    });
    _ref.child('$_name/waterlevel').onValue.listen((event) {
      final String waterlevel = event.snapshot.value.toString();
      setState(() {
        _waterlevel = waterlevel;
        _quality();
      });
    });
    _ref.child('$_name/tds').onValue.listen((event) {
      final String tds = event.snapshot.value.toString();
      setState(() {
        _tds = tds;
        _quality();
      });
    });
    _ref.child('$_name/temp').onValue.listen((event) {
      final String temperature = event.snapshot.value.toString();
      setState(() {
        _temperature = temperature;
        _quality();
      });
    });
    _ref.child('$_name/name').onValue.listen((event) {
      final String username = event.snapshot.value.toString();
      setState(() {
        _username = username;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _name = widget.title;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                Theme.of(context).primaryColor.withOpacity(0.3),
                Theme.of(context).colorScheme.secondary.withOpacity(0.4),
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
                  'Water Forecast',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyDashBoardSensors(
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
                  'change Password',
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
                  'LogOut',
                  style: TextStyle(fontSize: 17, color: Colors.black),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashBox(title: "Profile")));
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
                    'Quality level',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    _qulity,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _waterstate,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _qualitycolor),
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
                            "Sesors Values",
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
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          //leading: Text(""),
                                          title: Text("Water level"),
                                          trailing: Text(_waterlevel + " %"),
                                        ),
                                        ListTile(
                                          //leading: Text(""),
                                          title: Text("PH Value"),
                                          trailing: Text(_ph),
                                        ),
                                        ListTile(
                                          //leading: Text(""),
                                          title: Text("Turbidity"),
                                          trailing: Text(_turbidity + " NTU"),
                                        ),
                                        ListTile(
                                          //leading: Text(""),
                                          title: Text("TDS Value"),
                                          trailing: Text(_tds + " ppm"),
                                        ),
                                        ListTile(
                                          //leading: Text(""),
                                          title: Text("Temperature"),
                                          trailing: Text(_temperature + " C"),
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
    );
  }
}
