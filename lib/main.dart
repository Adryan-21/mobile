import 'package:flutter/material.dart';
import 'package:mobile/login.dart';
import 'package:mobile/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(),
      routes: {
        '/dashboard': (context) => Dashboard(),
      },
    );
  }
}
