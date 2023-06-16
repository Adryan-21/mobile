import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic>? userData;

  Future<void> fetchUserData() async {
    final response = await http.get(Uri.https('randomuser.me', '/api/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        userData = data['results'][0];
      });
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ustawienia'),
      ),
      body: Center(
        child: userData != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(userData!['picture']['large']),
                    radius: 50,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${userData!['name']['first']} ${userData!['name']['last']}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Email: ${userData!['email']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
