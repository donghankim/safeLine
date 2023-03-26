import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';

class NewsTabBar extends StatefulWidget {
  const NewsTabBar({super.key});

  @override
  State<NewsTabBar> createState() => _NewsTabBarState();
}

class _NewsTabBarState extends State<NewsTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: const Text("News Page")
      )
    );
  }
}
