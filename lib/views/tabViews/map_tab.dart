import 'package:flutter/material.dart';

class MapTabBar extends StatefulWidget {
  const MapTabBar({super.key});

  @override
  State<MapTabBar> createState() => _MapTabBarState();
}

class _MapTabBarState extends State<MapTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: const Text("Map Page")
      )
    );
  }
}
