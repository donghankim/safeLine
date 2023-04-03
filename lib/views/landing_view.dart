import 'package:flutter/material.dart';
import 'package:safe_line/customWidgets/figmaWidgets/all_homeWidgets.dart';
import 'package:safe_line/constants.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              height: deviceHeight(context),
              child: Stack(
                children: [
                  SizedBox(
                    width: constraints.maxWidth,
                    child: Container(
                      width: 428.0,
                      height: 926.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.zero,
                            child: Container(
                              color: const Color.fromARGB(255, 242, 241, 251),
                            ),
                          ),
                          Positioned(
                            left: -33.0,
                            top: 52.5,
                            right: null,
                            bottom: null,
                            width: 243.0,
                            height: 280.0,
                            child: GeneratedVector7Widget(),
                          ),
                          Positioned(
                            left: 242.0,
                            top: 625.0,
                            right: null,
                            bottom: null,
                            width: 240.5,
                            height: 152.5,
                            child: GeneratedVector9Widget(),
                          ),
                          Positioned(
                            left: 3.5,
                            top: -0.5,
                            right: null,
                            bottom: null,
                            width: 258.5,
                            height: 108.0,
                            child: GeneratedVector6Widget(),
                          ),
                          Positioned(
                            left: 53.5,
                            top: 777.5,
                            right: null,
                            bottom: null,
                            width: 376.5,
                            height: 162.0,
                            child: GeneratedVector4Widget(),
                          ),
                          Positioned(
                            left: 81.0,
                            top: 2.0,
                            right: null,
                            bottom: null,
                            width: 277.5,
                            height: 967.5,
                            child: GeneratedVector3Widget(),
                          ),
                          Positioned(
                            left: 80.0,
                            top: -11.0,
                            right: null,
                            bottom: null,
                            width: 332.0,
                            height: 293.0,
                            child: GeneratedVector5Widget(),
                          ),
                          Positioned(
                            left: 109.0,
                            top: 442.0,
                            right: null,
                            bottom: null,
                            width: 261.0,
                            height: 78.0,
                            child: GeneratedSafeLineWidget(),
                          ),
                          Positioned(
                            left: 53.0,
                            top: 453.0,
                            right: null,
                            bottom: null,
                            width: 60.0,
                            height: 60.0,
                            child: GeneratedGroup6Widget(),
                          ),
                          const Positioned(
                            left: 128.0,
                            top: 546.0,
                            right: null,
                            bottom: null,
                            width: 136.0,
                            height: 32.0,
                            child: GetStartedWidget(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
