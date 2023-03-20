import 'package:flutter/material.dart';

class LeaderTabBar extends StatefulWidget {
  const LeaderTabBar({super.key});

  @override
  State<LeaderTabBar> createState() => _LeaderTabBarState();
}

class _LeaderTabBarState extends State<LeaderTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: const Text("Leaderboard Page")
      )
    );
  }
}
