// home page widgets
import 'package:flutter/material.dart';
import 'package:safe_line/models/users.dart';
import 'package:safe_line/tabViews/all_tabs.dart';
import 'package:safe_line/constants.dart';

class HomePage extends StatefulWidget {
  final AppUser currUser;
  const HomePage({super.key, required this.currUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 2,
      length: 4,
      child: Scaffold(
        backgroundColor: slBgColor,
        appBar: AppBar(
          toolbarHeight: 10,
          backgroundColor: accentColor,
          bottom: PreferredSize(
              preferredSize: _allTabs.preferredSize, child: _allTabs),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    MapTabBar(),
                    NewsTabBar(),
                    LeaderTabBar(),
                    ProfileTabBar(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

TabBar get _allTabs => const TabBar(
      unselectedLabelColor: Colors.white,
      indicatorColor: Colors.black,
      labelPadding: EdgeInsets.zero,
      tabs: [
        Tab(
            text: "Subway",
            icon: Icon(Icons.directions_subway, color: slBgColor)),
        Tab(text: "News", icon: Icon(Icons.feed, color: slBgColor)),
        Tab(
            text: "Leaderboard",
            icon: Icon(Icons.leaderboard, color: slBgColor)),
        Tab(text: "Profile", icon: Icon(Icons.person, color: slBgColor))
      ],
    );

// not used
class TabWidget extends StatelessWidget {
  final String icon;

  const TabWidget({super.key, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 70,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 232, 232, 232),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(icon),
        // child: Icon(Icons.{$.icon}),
      ),
    );
  }
}
