import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safe_line/constants.dart';
import 'package:safe_line/auth/auth_service.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currUser = AuthService.firebase().currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: deviceAppBar(context),
      body: Container(
        color: bgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('asset/icons/profile.png'),
            ),
            const SizedBox(height: 15),
            profileOverviewWidget(context),
            topReportsWidget(context),
            Expanded(child: profileSettingWidget(context)),
          ],
        ),
      ),
    );
  }

  Widget topReportsWidget(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 275,
      child: Container(
        margin: const EdgeInsets.fromLTRB(5, 25, 5, 15),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('reports')
              .where('userId', isEqualTo: currUser?.id)
              .snapshots(),
          builder:
              (BuildContext content, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return circularLoader;
            } else {
              List<int> scoreArr = [];
              List<String> postArr = [];
              DateFormat dateFormat = DateFormat('MMMM d, y');
              for (var report in snapshot.data!.docs) {
                scoreArr.add(report['validity']);
                postArr.add(dateFormat.format(report['postTime'].toDate()));
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Top Reports",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  reportSummary(12, postArr[0]),
                  reportSummary(3, postArr[5]),
                  reportSummary(1, postArr[20]),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Row reportSummary(int score, String postTime) {
    return Row(
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: Image.asset('asset/icons/votes.png'),
        ),
        const SizedBox(width: 10),
        Text(
          score.toString(),
          style: const TextStyle(
              fontSize: 20.0,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        const SizedBox(width: 20),
        Text(
          postTime.toString(),
          style: const TextStyle(
              fontSize: 20.0,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
      ],
    );
  }

  Widget profileOverviewWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 35,
          child: Image.asset('asset/badges/verified.png'),
        ),
        SizedBox(
          width: 125,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Karma Level",
                style: TextStyle(
                    color: accentColor, fontFamily: 'Inter', fontSize: 12),
              ),
              Text(
                "Rookie",
                style: TextStyle(
                  color: accentColor,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Text(
                "1500 left to go to Helping Hand",
                style: TextStyle(
                  color: accentColor,
                  fontFamily: 'Inter',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Image.asset('asset/badges/karma_points.png'),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "5000",
                    style: TextStyle(
                      color: accentColor,
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Karma Points",
                    style: TextStyle(
                      color: accentColor,
                      fontFamily: 'Inter',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget profileSettingWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  // change password
                },
                child: const Text(
                  "Change Password",
                  style: TextStyle(
                    decorationStyle: TextDecorationStyle.dashed,
                    color: accentColor,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await AuthService.firebase().logout(context);
                },
                child: const Text(
                  "Log Out",
                  style: TextStyle(
                    color: accentColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // delete account
                },
                child: const Text(
                  "Delete Account",
                  style: TextStyle(
                    color: accentColor,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Show information about safeLine
                },
                child: const Text(
                  "About SafeLine",
                  style: TextStyle(
                    color: accentColor,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
