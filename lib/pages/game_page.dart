import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Map<int, Animation<double>> _flippedAnimations = {};

  int totalTime = 60; // Czas gry w sekundach
  bool isGameFinished = false;

  List<int> items = List<int>.generate(20, (index) => (index ~/ 2) + 1);
  List<int> shuffledItems = [];
  List<bool> itemVisibility = [];
  int? firstSelectedItem;
  int? secondSelectedItem;
  Timer? gameTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration:
          Duration(milliseconds: 500), // Dostosuj czas trwania według potrzeb
    );
    startGame();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    gameTimer?.cancel();
    super.dispose();
  }

  void startGame() {
    items.shuffle();
    shuffledItems = List<int>.from(items);
    itemVisibility = List<bool>.filled(20, true);
    firstSelectedItem = null;
    secondSelectedItem = null;
    isGameFinished = false;
    totalTime = 60;

    gameTimer?.cancel();
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!isGameFinished) {
        setState(() {
          totalTime--;
        });

        if (totalTime == 0) {
          timer.cancel();
          isGameFinished = true;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Koniec gry'),
                content: Text('Czas minął! Przegrałeś.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      startGame();
                    },
                    child: Text('Restart'),
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  var blockInput = false;
  void checkSelectedItems(int index) {
    if (firstSelectedItem == null) {
      firstSelectedItem = index;
      setState(() {
        itemVisibility[index] = false;
      });
    } else if (secondSelectedItem == null) {
      if (firstSelectedItem == index) {
        return; // Ignoruj kliknięcie na ten sam element
      }
      secondSelectedItem = index;
      setState(() {
        itemVisibility[index] = false;
      });

      // Sprawdzanie czy wybrane elementy są takie same
      if (shuffledItems[firstSelectedItem!] ==
          shuffledItems[secondSelectedItem!]) {
        // Elementy są takie same
        firstSelectedItem = null;
        secondSelectedItem = null;

        // Sprawdzanie czy wszystkie elementy zostały odkryte
        if (!itemVisibility.contains(true)) {
          // Gra zakończona sukcesem
          isGameFinished = true;
          gameTimer?.cancel();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Gratulacje!'),
                content: Text('Wygrałeś grę!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      startGame();
                    },
                    child: Text('Restart'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Elementy nie są takie same
        blockInput = true; // Zablokuj kliknięcia
        _animationController?.forward(from: 0.0).then((_) {
          setState(() {
            itemVisibility[firstSelectedItem!] = true;
            itemVisibility[secondSelectedItem!] = true;
          });
          Future.delayed(Duration(milliseconds: 1000), () {
            blockInput = false; // Odblokuj kliknięcia po zakończeniu animacji
            setState(() {
              firstSelectedItem = null;
              secondSelectedItem = null;
            });
          });
          _animationController
              ?.reverse(); // Przywróć kartę do pierwotnego położenia
        });
      }
    } else {
      // Kliknięto już dwa elementy, resetowanie wyboru
      firstSelectedItem = null;
      secondSelectedItem = null;
      setState(() {
        itemVisibility = List<bool>.from(itemVisibility);
      });
    }
  }

  Widget buildCard(int index) {
    if (!_flippedAnimations.containsKey(index)) {
      _flippedAnimations[index] = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _animationController!,
          curve: Interval(0.0, 0.5, curve: Curves.easeIn),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (blockInput) {
          return;
        }
        if (itemVisibility[index] &&
            firstSelectedItem != index &&
            secondSelectedItem != index) {
          setState(() {
            itemVisibility[index] = false;
          });
          checkSelectedItems(index);
        }
      },
      child: AnimatedBuilder(
        animation: _flippedAnimations[index]!,
        builder: (context, child) {
          double rotationValue = itemVisibility[index]
              ? _flippedAnimations[index]!.value * pi
              : (_flippedAnimations[index]!.value + 1) * pi;
          return Transform.rotate(
            angle: rotationValue,
            child: child,
          );
        },
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: itemVisibility[index] ? Color(0xFF89cff0 ) : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Visibility(
              visible: !itemVisibility[index],
              child: Text(
                '${shuffledItems[index]}',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memo Game'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 203, 243, 255),
            ],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Czas: $totalTime s',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemCount: shuffledItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildCard(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
