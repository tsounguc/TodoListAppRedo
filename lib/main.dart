import 'package:flutter/material.dart';
import 'package:todolistappredo/Login_And_Auth/auth.dart';
import 'package:todolistappredo/Login_And_Auth/loginPage.dart';
import 'package:todolistappredo/Login_And_Auth/signUpPage.dart';
import 'package:todolistappredo/routingPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home: RoutingPage(new Auth()),
    );
  }
}
