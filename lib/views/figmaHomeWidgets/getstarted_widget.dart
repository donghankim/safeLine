import 'package:flutter/material.dart';
import 'package:safe_line/routes.dart';

/*
class GeneratedRectangle4Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, loginRoute),
      child: Container(
        width: 136.0,
        height: 32.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            color: Color.fromARGB(255, 201, 195, 250),
          ),
        ),
      ),
    );
  }
}
*/

class GetStartedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, loginRoute),
      child: Container(
        width: 136.0,
        height: 32.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            color: Color.fromARGB(255, 201, 195, 250),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                  '''Get Started''',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 94, 78, 228),
                  ),
                ),
            )
          ),
        ),
      ),
    );
  }
}
