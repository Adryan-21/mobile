import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() => runApp(MemoGame());

class MemoGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memo Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
