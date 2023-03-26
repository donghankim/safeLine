import 'package:flutter/material.dart';
import 'package:safe_line/constants.dart';

class LeaderTabBar extends StatefulWidget {
  const LeaderTabBar({super.key});

  @override
  State<LeaderTabBar> createState() => _LeaderTabBarState();
}

class _LeaderTabBarState extends State<LeaderTabBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 100),
        podiumWidget(context),
        scoreViewWidget(context),
      ],
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
            ),
          ),
        ),
      ),
    );
  }

  Widget podiumWidget(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _podiumBars(context, 2),
          _podiumBars(context, 1),
          _podiumBars(context, 3),
        ],
      ),
    );
  }

  Widget podiumProfile(BuildContext context) {
    return Container();
  }

  Stack _podiumBars(BuildContext context, int place) {
    double baseHeight = 200;
    double baseWidth = 80;
    double scaleFactor = 0.2 * (place - 1);

    return Stack(
      children: <Widget>[
        Container(
          width: baseWidth,
          height: baseHeight - scaleFactor * baseHeight,
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
              textAlign: TextAlign.left,
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
