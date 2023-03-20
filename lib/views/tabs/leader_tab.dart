import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class LeaderTabBar extends StatefulWidget {
  const LeaderTabBar({super.key});

  @override
  State<LeaderTabBar> createState() => _LeaderTabBarState();
}

class Player {
  String name;
  String option;
  int points;
  DateTime? lastSubmissionTime;
  bool submit;

  Player(
      {required this.name,
      required this.option,
      required this.points,
      required this.lastSubmissionTime,
      required this.submit});
}

class _LeaderTabBarState extends State<LeaderTabBar> {
  List<Player> _leaderboard = [];
  String? _selectedOption;
  final TextEditingController _nameController = TextEditingController();

  void _addPoints(String name, String option) {
    final currentTime = DateTime.now();
    DateTime now = DateTime.now();
    int hour = now.hour;

    int count =
        _leaderboard.where((player) => player.option == option).length + 1;

    if (hour >= 8 && hour < 22) {
      Player? existingPlayer = _leaderboard.firstWhereOrNull(
        (player) => player.name == name,
      );

      if (existingPlayer != null) {
        if (existingPlayer.lastSubmissionTime != null &&
            now.difference(existingPlayer.lastSubmissionTime!).inMinutes < 10) {
          //final lastSubmissionTime = existingPlayer.lastSubmissionTime ?? DateTime(0);
          //final hoursSinceLastSubmission = currentTime.difference(lastSubmissionTime).inHours;
          //final isCooldownOver = hoursSinceLastSubmission >= 1;
          // setState(() {
          //  return 'You can only submit a report once per hour.';
          //});
          return;
        } else {
          existingPlayer.submit = false;
        }
        existingPlayer.option = option;
      } else {
        setState(() {
          _leaderboard.add(Player(
              name: name,
              option: option,
              points: 0,
              lastSubmissionTime: currentTime,
              submit: false));
        });
      }
      if (count > 1) {
        // Increment the points of all players who have chosen the same option as the current player
        if (existingPlayer?.lastSubmissionTime != null &&
            now.difference(existingPlayer!.lastSubmissionTime!).inMinutes <
                10) {
        } else {
          for (var player in _leaderboard) {
            if (player.option == option && player.submit == false) {
              player.submit = true;
              setState(() {
                player.points++;
              });
            }
          }
        }
      } else {
        // Do nothing, as only one player has chosen this option
      }
    } else {
      Player? existingPlayer = _leaderboard.firstWhereOrNull(
        (player) => player.name == name,
      );

      if (existingPlayer != null) {
        if (existingPlayer.lastSubmissionTime != null &&
            now.difference(existingPlayer.lastSubmissionTime!).inMinutes < 10) {
          existingPlayer.submit = true;
        } else {
          setState(() {
            existingPlayer.points++;
          });
        }
      } else {
        setState(() {
          _leaderboard.add(Player(
              name: name,
              points: 1,
              option: option,
              lastSubmissionTime: currentTime,
              submit: true));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedOption,
              hint: Text('Select Option'),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOption = newValue;
                });
              },
              items: [
                DropdownMenuItem(
                  child: Text('Delay'),
                  value: 'Delay',
                ),
                DropdownMenuItem(
                  child: Text('Violent Incident'),
                  value: 'Violent Incident',
                ),
                DropdownMenuItem(
                  child: Text('Full Capacity'),
                  value: 'Full Capacity',
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty && _selectedOption != null) {
                _addPoints(_nameController.text, _selectedOption!);
              }
            },
            child: Text('Select an Option'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _leaderboard.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_leaderboard[index].name),
                  trailing: Text(
                    _leaderboard[index].points.toString(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
