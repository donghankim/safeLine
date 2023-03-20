// home page widgets
import 'package:flutter/material.dart';
import 'package:safe_line/routes.dart';
import 'package:safe_line/views/tabs/all_tabs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> allTabs = const [
    TabWidget(iconPath: 'asset/icons/reports_icon.png'),
    TabWidget(iconPath: 'asset/icons/news_icon.png'),
    TabWidget(iconPath: 'asset/icons/subway_icon.png'),
    TabWidget(iconPath: 'asset/icons/leader_icon.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: allTabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "Safe Line",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: Icon(Icons.person, color: Colors.grey[800], size: 32),
                onPressed: () async {
                  Navigator.pushNamed(context, settingsRoute);
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 32,
              ),
              TabBar(
                tabs: allTabs,
                isScrollable: true,
              ),
              Expanded(
                  child: TabBarView(
                children: [
                  ReportTabBar(),
                  NewsTabBar(),
                  MapTabBar(),
                  LeaderTabBar(),
                ],
              ))
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

class TabWidget extends StatelessWidget {
  final String iconPath;

  const TabWidget({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 64,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(iconPath),
      ),
    );
  }
}
