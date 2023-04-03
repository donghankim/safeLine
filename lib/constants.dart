import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const accentColor = Color.fromARGB(255, 94, 78, 228);
const bgColor = Color.fromARGB(255, 242, 241, 251);

const circularLoader = Center(
  child: SizedBox(
    width: 50,
    height: 50,
    child: CircularProgressIndicator(),
  ),
);

String getTime(DateTime now) {
  String formattedTime = DateFormat('HH:mm:ss').format(now);
  return formattedTime;
}

const List<String> subwayLines = [
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "A",
  "C",
  "E",
  "SIR",
  "G",
  "7",
  "B",
  "D",
  "F",
  "M",
  "J",
  "Z",
  "N",
  "Q",
  "R",
  "W",
  "L",
  "S",
  "SF",
  "SR",
];

const List<MaterialColor> subwayIconColor = [
  Colors.deepOrange,
  Colors.deepOrange,
  Colors.deepOrange,
  Colors.deepOrange,
  Colors.deepOrange,
  Colors.deepOrange,
  Colors.lightBlue,
  Colors.lightBlue,
  Colors.lightBlue,
  Colors.lightBlue,
  Colors.lightGreen,
  Colors.purple,
  Colors.orange,
  Colors.orange,
  Colors.orange,
  Colors.orange,
  Colors.brown,
  Colors.pink,
  Colors.yellow,
  Colors.yellow,
  Colors.yellow,
  Colors.yellow,
  Colors.grey,
  Colors.grey,
  Colors.grey,
  Colors.grey,
];

const List<Color> subwayTextColor = [
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.white,
  Colors.black,
  Colors.black,
  Colors.black,
  Colors.black,
  Colors.black,
  Colors.black,
  Colors.black,
  Colors.black,
];

// deafult appBar for all scaffolds
AppBar deviceAppBar(BuildContext context) {
  return AppBar(
    toolbarHeight: 50,
    leadingWidth: 100,
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Image.asset('asset/icons/pop.png'),
        iconSize: 50,
      ),
    ),
  );
}

double deviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double deviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double mainButtonSize(BuildContext context) {
  return deviceWidth(context) * 0.15;
}

double spacerHeight(BuildContext context) {
  return deviceHeight(context) * 0.15;
}
