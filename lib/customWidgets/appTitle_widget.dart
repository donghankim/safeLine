import 'package:flutter/material.dart';
import 'package:safe_line/customWidgets/figmaHelpers/transform/transform.dart';
import 'package:safe_line/customWidgets/figmaHelpers/svg/svg.dart';

class SafeLineWidget extends StatelessWidget {
  const SafeLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[LogoWidget(), TitleWidget()],
        ),
        const Text("tagline here -----",
            overflow: TextOverflow.visible,
            textAlign: TextAlign.left,
            style: TextStyle(
              height: 1.2102272033691406,
              fontSize: 15.0,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 94, 78, 228),
            )),
      ],
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return const Text(
      'SafeLine',
      overflow: TextOverflow.visible,
      textAlign: TextAlign.left,
      style: TextStyle(
        height: 1.2102272033691406,
        fontSize: 40.0,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        color: Color.fromARGB(255, 94, 78, 228),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 33.0,
      height: 33.0,
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: const [
            Positioned(
              left: 0.0,
              top: 0.0,
              right: null,
              bottom: null,
              width: 33.0,
              height: 33.0,
              child: GeneratedGroup1Widget1(),
            ),
            Positioned(
              left: 16.54967498779297,
              top: 8.114648818969727,
              right: null,
              bottom: null,
              width: 12.049910545349121,
              height: 12.049910545349121,
              child: GeneratedEllipse6Widget1(),
            )
          ]),
    );
  }
}

class GeneratedGroup1Widget1 extends StatelessWidget {
  const GeneratedGroup1Widget1({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 33.0,
      height: 33.0,
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: const [
            Positioned(
              left: 16.335241317749023,
              top: 0.0,
              right: null,
              bottom: null,
              width: 23.3356876373291,
              height: 23.3356876373291,
              child: GeneratedEllipse5Widget1(),
            )
          ]),
    );
  }
}

class GeneratedEllipse6Widget1 extends StatelessWidget {
  const GeneratedEllipse6Widget1({super.key});

  @override
  Widget build(BuildContext context) {
    return TransformHelper.rotate(
        a: 0.71,
        b: -0.70,
        c: 0.70,
        d: 0.71,
        child: SizedBox(
          width: 12.049910545349121,
          height: 12.049910545349121,
          child: SvgWidget(painters: [
            SvgPathPainter.fill()
              ..addPath(
                  'M12.0499 6.02496C12.0499 9.35245 9.35245 12.0499 6.02496 12.0499C2.69746 12.0499 0 9.35245 0 6.02496C0 2.69746 2.69746 0 6.02496 0C9.35245 0 12.0499 2.69746 12.0499 6.02496Z')
              ..color = const Color.fromARGB(255, 94, 78, 228),
          ]),
        ));
  }
}

class GeneratedEllipse5Widget1 extends StatelessWidget {
  const GeneratedEllipse5Widget1({super.key});

  @override
  Widget build(BuildContext context) {
    return TransformHelper.rotate(
        a: 0.71,
        b: -0.70,
        c: 0.70,
        d: 0.71,
        child: SizedBox(
          width: 23.3356876373291,
          height: 23.3356876373291,
          child: SvgWidget(painters: [
            SvgPathPainter.fill()
              ..addPath(
                  'M23.3357 11.6678C23.3357 18.1118 18.1118 23.3357 11.6678 23.3357C5.22387 23.3357 0 18.1118 0 11.6678C0 5.22387 5.22387 0 11.6678 0C18.1118 0 23.3357 5.22387 23.3357 11.6678Z')
              ..color = const Color.fromARGB(255, 242, 241, 251),
            SvgPathPainter.stroke(
              0.4124999940395355,
              strokeJoin: StrokeJoin.miter,
            )
              ..addPath(
                  'M22.9232 11.6678C22.9232 17.884 17.884 22.9232 11.6678 22.9232L11.6678 23.7482C18.3396 23.7482 23.7482 18.3396 23.7482 11.6678L22.9232 11.6678ZM11.6678 22.9232C5.45169 22.9232 0.4125 17.884 0.4125 11.6678L-0.4125 11.6678C-0.4125 18.3396 4.99605 23.7482 11.6678 23.7482L11.6678 22.9232ZM0.4125 11.6678C0.4125 5.45169 5.45169 0.4125 11.6678 0.4125L11.6678 -0.4125C4.99605 -0.4125 -0.4125 4.99605 -0.4125 11.6678L0.4125 11.6678ZM11.6678 0.4125C17.884 0.4125 22.9232 5.45169 22.9232 11.6678L23.7482 11.6678C23.7482 4.99605 18.3396 -0.4125 11.6678 -0.4125L11.6678 0.4125Z')
              ..color = const Color.fromARGB(255, 94, 78, 228)
              ..addClipPath(
                  'M23.3357 11.6678C23.3357 18.1118 18.1118 23.3357 11.6678 23.3357C5.22387 23.3357 0 18.1118 0 11.6678C0 5.22387 5.22387 0 11.6678 0C18.1118 0 23.3357 5.22387 23.3357 11.6678Z'),
          ]),
        ));
  }
}
