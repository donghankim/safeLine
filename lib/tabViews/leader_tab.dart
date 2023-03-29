import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_line/constants.dart';
import 'dart:developer' as tools;

class LeaderTabBar extends StatefulWidget {
  const LeaderTabBar({super.key});

  @override
  State<LeaderTabBar> createState() => _LeaderTabBarState();
}

class _LeaderTabBarState extends State<LeaderTabBar> {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  List<int> orderedScores = [];
  List<String> allUsers = [];

  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  Future updateUserScores() async {
    await FirebaseFirestore.instance
        .collection('users')
        .orderBy('Score', descending: true)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (element) {
              var docData = element.data();
              orderedScores.add(docData['Score']);
              allUsers.add(docData['DisplayName']);
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: updateUserScores(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              podiumWidget(context),
              scoreViewWidget(context),
            ],
          );
        } else {
          return circularLoader;
        }
      },
    );
  }

  Widget scoreViewWidget(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60.0),
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: ListView.builder(
                itemCount: allUsers.length,
                itemBuilder: (context, index) {
                  return Align(
                      alignment: Alignment.bottomCenter,
                      child: _scoreCardWidget(context, allUsers[index],
                          orderedScores[index], index));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _scoreCardWidget(
      BuildContext context, String username, int score, int rank) {
    double cardHeight = 75;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: Text(
              (rank + 1).toString(),
              style: const TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  color: accentColor),
            ),
          ),
          SizedBox(
            width: 300,
            height: cardHeight,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            color: accentColor),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Current Score: $score',
                        style: const TextStyle(
                            fontSize: 10.0,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            color: accentColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Podium view
  Widget podiumWidget(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            children: [
              _podiumProfile(context, 2),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: _podiumBars(context, 2),
              )
            ],
          ),
          Column(
            children: [
              _podiumProfile(context, 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: _podiumBars(context, 1),
              )
            ],
          ),
          Column(
            children: [
              _podiumProfile(context, 3),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: _podiumBars(context, 3),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _podiumProfile(BuildContext context, int place) {
    String userName = allUsers[place - 1];

    return Column(
      children: [
        // const Icon(Icons.person, color: accentColor),
        MaterialButton(
          onPressed: () {},
          color: bgColor,
          textColor: accentColor,
          padding: const EdgeInsets.all(15),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.person,
            color: accentColor,
            size: 30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            userName,
            style: const TextStyle(
                fontSize: 15.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                color: accentColor),
          ),
        ),
      ],
    );
  }

  Stack _podiumBars(BuildContext context, int place) {
    double baseHeight = 200;
    double baseWidth = 80;
    double scaleFactor = 0.2 * (place - 1);

    return Stack(
      children: <Widget>[
        Container(
          clipBehavior: Clip.none,
          width: baseWidth,
          height: baseHeight - (scaleFactor * baseHeight),
          decoration: const BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
        ),

        // numbering
        Positioned(
          left: (baseWidth / 2) - 10,
          top: 10,
          child: SizedBox(
            width: 20,
            height: 20,
            child: Text(
              place.toString(),
              overflow: TextOverflow.visible,
              style: const TextStyle(
                height: 1.210227279663086,
                fontSize: 30.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
