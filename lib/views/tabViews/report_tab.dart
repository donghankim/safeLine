import 'package:flutter/material.dart';

class ReportTabBar extends StatefulWidget {
  const ReportTabBar({super.key});

  @override
  State<ReportTabBar> createState() => _ReportTabBarState();
}

class _ReportTabBarState extends State<ReportTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: const Text("Report Page")
      )
    );
  }
}
