// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myapp/logoutanimation.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: unused_local_variable
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Color _primaryColor = HexColor('#01017a');
  final Color _accentColor = HexColor('#4871f7');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Water',
      theme: ThemeData(
        primaryColor: _primaryColor,
        scaffoldBackgroundColor: Colors.grey.shade100,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
            .copyWith(secondary: _accentColor),
      ),
      home: DashBox(title: 'Smart Water'),
    );
  }
}
