import 'package:noti_app/pages/home.dart';
import 'package:noti_app/pages/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      routes: {
        '/main': (context) => LoginPage(),
        '/home': (context) => HomePage()
      },
    );
  }
}
