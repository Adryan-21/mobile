import 'package:flutter/material.dart';
import 'game_page.dart';
import 'settings_page.dart';
import 'rank_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color _backgroundColor = Color.fromARGB(255, 255, 255, 255); // Domyślny kolor tła

  void _changeBackgroundColor() {
    setState(() {
      if (_backgroundColor == Color.fromARGB(255, 255, 255, 255)) {
        _backgroundColor = Colors.grey[700]!; // Zmienia na ciemny szary
      } else {
        _backgroundColor = Color.fromARGB(255, 255, 255, 255); // Zmienia na jasny
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memo Game'),
      ),
      body: Container(
        color: _backgroundColor, // Używa aktualnego koloru tła
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GamePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Color(0xFFf4c2c2),
                  elevation: 5,
                ),
                child: Text(
                  'START',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RankingPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Color(0xFFf4c2c2),
                  elevation: 5,
                ),
                child: Text(
                  'RANKING',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Color(0xFFf4c2c2),
                  elevation: 5,
                ),
                child: Text(
                  'Ustawienia',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changeBackgroundColor,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Color(0xFFf4c2c2),
                  elevation: 5,
                ),
                child: Text(
                  _backgroundColor == Color.fromARGB(255, 255, 255, 255) ? 'Zmień kolor tła na ciemny' : 'Zmień kolor tła na jasny',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
