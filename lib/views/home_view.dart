// home page widgets
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_line/constants.dart';
import 'package:safe_line/models/users.dart';
import 'package:safe_line/models/report.dart';
import 'package:safe_line/tabViews/all_tabs.dart';
import 'package:safe_line/customWidgets/toggle_button.dart';

TabBar get _allTabs => const TabBar(
      unselectedLabelColor: Color.fromARGB(255, 197, 196, 196),
      indicatorColor: Colors.white,
      labelPadding: EdgeInsets.zero,
      tabs: [
        Tab(
          text: "Subway",
          icon: Icon(Icons.directions_subway),
        ),
        Tab(
          text: "Feed",
          icon: Icon(Icons.feed),
        ),
        Tab(
          text: "Leaderboard",
          icon: Icon(Icons.leaderboard),
        ),
        Tab(
          text: "Profile",
          icon: Icon(Icons.person),
        ),
      ],
    );

List<SubwayButton> allStations = [];

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
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: accentColor,
          bottom: PreferredSize(
              preferredSize: _allTabs.preferredSize, child: _allTabs),
        ),
        body: Center(
          child: Column(
            children: const [
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(0, 120, 10, 0),
          child: SizedBox(
            width: 70,
            height: 70,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () async {
                  await reportIncident(context);
                },
                backgroundColor: accentColor,
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      ),
    );
  }

  // reporting incidents
  Future<void> reportIncident(BuildContext context) async {
    final TextEditingController _descriptionController =
        TextEditingController();
    String dropdownVal = 'Uptown';

    return await showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            backgroundColor: bgColor,
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Train Line",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 20),
                      DropdownButton<String>(
                        value: dropdownVal,
                        underline: Container(height: 2, color: accentColor),
                        onChanged: (String? newVal) {
                          setState(() {
                            dropdownVal = newVal!;
                          });
                        },
                        items: const [
                          DropdownMenuItem<String>(
                            alignment: Alignment.center,
                            value: 'Uptown',
                            child: Text(
                              "Uptown",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Downtown',
                            child: Text("Downtown"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // subway line buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SubwayButton(
                          buttonText: "1",
                          buttonColor: Colors.deepOrange,
                          state: false),
                      SubwayButton(
                          buttonText: "2",
                          buttonColor: Colors.deepOrange,
                          state: false),
                      SubwayButton(
                          buttonText: "3",
                          buttonColor: Colors.deepOrange,
                          state: false),
                      SubwayButton(
                          buttonText: "4",
                          buttonColor: Colors.green,
                          state: false),
                      SubwayButton(
                          buttonText: "5",
                          buttonColor: Colors.green,
                          state: false),
                      SubwayButton(
                          buttonText: "6",
                          buttonColor: Colors.green,
                          state: false),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SubwayButton(
                          buttonText: "A",
                          buttonColor: Colors.lightBlue,
                          state: false),
                      SubwayButton(
                          buttonText: "C",
                          buttonColor: Colors.lightBlue,
                          state: false),
                      SubwayButton(
                          buttonText: "E",
                          buttonColor: Colors.lightBlue,
                          state: false),
                      SubwayButton(
                          buttonText: "SIR",
                          buttonColor: Colors.blue,
                          state: false),
                      SubwayButton(
                          buttonText: "G",
                          buttonColor: Colors.lightGreen,
                          state: false),
                      SubwayButton(
                          buttonText: "7",
                          buttonColor: Colors.purple,
                          state: false),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SubwayButton(
                          buttonText: "B",
                          buttonColor: Colors.orange,
                          state: false),
                      SubwayButton(
                          buttonText: "D",
                          buttonColor: Colors.orange,
                          state: false),
                      SubwayButton(
                          buttonText: "F",
                          buttonColor: Colors.orange,
                          state: false),
                      SubwayButton(
                          buttonText: "M",
                          buttonColor: Colors.orange,
                          state: false),
                      SubwayButton(
                          buttonText: "J",
                          buttonColor: Colors.brown,
                          state: false),
                      SubwayButton(
                          buttonText: "Z",
                          buttonColor: Colors.pink,
                          state: false),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SubwayButton(
                          buttonText: "N",
                          buttonColor: Colors.yellow,
                          state: false),
                      SubwayButton(
                          buttonText: "Q",
                          buttonColor: Colors.yellow,
                          state: false),
                      SubwayButton(
                          buttonText: "R",
                          buttonColor: Colors.yellow,
                          state: false),
                      SubwayButton(
                          buttonText: "W",
                          buttonColor: Colors.yellow,
                          state: false),
                      SubwayButton(
                          buttonText: "L",
                          buttonColor: Colors.grey,
                          state: false),
                      SubwayButton(
                          buttonText: "S",
                          buttonColor: Colors.grey,
                          state: false),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SubwayButton(
                          buttonText: "SF",
                          buttonColor: Colors.grey,
                          state: false),
                      SubwayButton(
                          buttonText: "SR",
                          buttonColor: Colors.grey,
                          state: false),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Describe the Incident",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: SizedBox(
                      height: 200,
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      Report newIncident = Report(widget.currUser.id, "train1",
                          _descriptionController.text);
                      await FirebaseFirestore.instance
                          .collection('reports')
                          .add(
                        {
                          'userId': newIncident.userId,
                          'trainId': newIncident.trainId,
                          'postTime': newIncident.postTime,
                          'description': newIncident.description,
                          'validity': newIncident.validityScore,
                        },
                      );
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Report Saved!"),
                          backgroundColor: accentColor,
                          duration: Duration(seconds: 1),
                        ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 94, 78, 228),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                    child: const Text("Submit"),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
