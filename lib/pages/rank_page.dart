import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:flutter/services.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  bool isGridView = false;
  final faker = Faker();

  List<Player> players = [];

  @override
  void initState() {
    super.initState();
    generateRandomPlayers();
  }

  void generateRandomPlayers() {
    players.clear();
    for (var i = 0; i < 10; i++) {
      final playerName = faker.person.name();
      final playerScore = faker.randomGenerator.integer(100);
      players.add(Player(name: playerName, score: playerScore));
    }
    players.sort((a, b) => b.score.compareTo(a.score)); // Sortowanie graczy w kolejności malejącej według wyników
  }

  Widget _buildTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text('Miejsce')),
        DataColumn(label: Text('Gracz')),
        DataColumn(label: Text('Wynik')),
      ],
      rows: List<DataRow>.generate(
        players.length,
        (index) => DataRow(
          cells: [
            DataCell(Text((index + 1).toString())),
            DataCell(Text(players[index].name)),
            DataCell(Text(players[index].score.toString())),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemCount: players.length,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Miejsce: ${(index + 1)}'),
                Text('Gracz: ${players[index].name}'),
                Text('Wynik: ${players[index].score}'),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleLayout() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking graczy'),
      ),
      body: Column(
        children: [
          ToggleButtons(
            isSelected: [isGridView, !isGridView],
            onPressed: (index) {
              _toggleLayout();
            },
            children: [
              Icon(Icons.view_list),
              Icon(Icons.grid_on),
            ],
          ),
          Expanded(
            child: isGridView ? _buildGrid() : _buildTable(),
          ),
        ],
      ),
    );
  }
}

class Player {
  final String name;
  final int score;

  Player({required this.name, required this.score});
}
