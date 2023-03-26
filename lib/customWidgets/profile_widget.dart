import 'package:flutter/material.dart';
import 'package:safe_line/routes.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:safe_line/figmaHelpers/transform/transform.dart';
import 'package:safe_line/figmaHelpers/svg/svg.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, settingsRoute),
      child: Container(
        width: 70.0,
        height: 70.0,
        child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0.0,
                top: 0.0,
                right: 0.0,
                bottom: 0.0,
                width: null,
                height: null,
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  final double width = constraints.maxWidth * 0.5;
                  final double height = constraints.maxHeight * 0.5;

                  return Stack(children: [
                    TransformHelper.translate(
                        x: constraints.maxWidth * 0.24285714285714285,
                        y: constraints.maxHeight * 0.2571428571428571,
                        z: 0,
                        child: SizedBox(
                          width: width,
                          height: height,
                          child: _GeneratediconprofilecircleWidget(),
                        ))
                  ]);
                }),
              )
            ]),
      ),
    );
  }
}

class _GeneratediconprofilecircleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45.0,
      height: 45.0,
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0.0,
              top: 0.0,
              right: 0.0,
              bottom: 0.0,
              width: null,
              height: null,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                final double width = constraints.maxWidth;
                final double height = constraints.maxHeight;

                return Stack(children: [
                  TransformHelper.translate(
                      x: 0,
                      y: 0,
                      z: 0,
                      child: SizedBox(
                        width: width,
                        height: height,
                        child: _GeneratedGroupWidget(),
                      ))
                ]);
              }),
            )
          ]),
    );
  }
}

class _GeneratedGroupWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45.0,
      height: 45.0,
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0.0,
              top: 0.0,
              right: 0.0,
              bottom: 0.0,
              width: null,
              height: null,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                double percentWidth = 1.0;
                double scaleX = (constraints.maxWidth * percentWidth) / 35.0;

                double percentHeight = 1.0;
                double scaleY = (constraints.maxHeight * percentHeight) / 35.0;

                return Stack(children: [
                  TransformHelper.translateAndScale(
                      translateX: 0,
                      translateY: 0,
                      translateZ: 0,
                      scaleX: scaleX,
                      scaleY: scaleY,
                      scaleZ: 1,
                      child: _GeneratedVectorWidget3())
                ]);
              }),
            ),
            Positioned(
              left: 0.0,
              top: 0.0,
              right: 0.0,
              bottom: 0.0,
              width: null,
              height: null,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                double percentWidth = 0.375;
                double scaleX = (constraints.maxWidth * percentWidth) / 13.125;
                double percentHeight = 0.3745004653930664;
                double scaleY = (constraints.maxHeight * percentHeight) /
                    13.107516288757324;
                return Stack(children: [
                  TransformHelper.translateAndScale(
                      translateX: constraints.maxWidth * 0.3125,
                      translateY: constraints.maxHeight * 0.246484375,
                      translateZ: 0,
                      scaleX: scaleX,
                      scaleY: scaleY,
                      scaleZ: 1,
                      child: _GeneratedVectorWidget4())
                ]);
              }),
            )
          ]),
    );
  }
}

class _GeneratedVectorWidget3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35.0,
      height: 35.0,
      child: SvgWidget(painters: [
        SvgPathPainter.fill()
          ..addPath(
              'M35 17.5C35 7.8575 27.1425 0 17.5 0C7.8575 0 0 7.8575 0 17.5C0 22.575 2.1875 27.1425 5.6525 30.345C5.6525 30.3625 5.6525 30.3625 5.635 30.38C5.81 30.555 6.02 30.695 6.195 30.8525C6.3 30.94 6.3875 31.0275 6.4925 31.0975C6.8075 31.36 7.1575 31.605 7.49 31.85C7.6125 31.9375 7.7175 32.0075 7.84 32.095C8.1725 32.3225 8.5225 32.5325 8.89 32.725C9.0125 32.795 9.1525 32.8825 9.275 32.9525C9.625 33.145 9.9925 33.32 10.3775 33.4775C10.5175 33.5475 10.6575 33.6175 10.7975 33.67C11.1825 33.8275 11.5675 33.9675 11.9525 34.09C12.0925 34.1425 12.2325 34.195 12.3725 34.23C12.7925 34.3525 13.2125 34.4575 13.6325 34.5625C13.755 34.5975 13.8775 34.6325 14.0175 34.65C14.5075 34.755 14.9975 34.825 15.505 34.8775C15.575 34.8775 15.645 34.895 15.715 34.9125C16.31 34.965 16.905 35 17.5 35C18.095 35 18.69 34.965 19.2675 34.9125C19.3375 34.9125 19.4075 34.895 19.4775 34.8775C19.985 34.825 20.475 34.755 20.965 34.65C21.0875 34.6325 21.21 34.58 21.35 34.5625C21.77 34.4575 22.2075 34.37 22.61 34.23C22.75 34.1775 22.89 34.125 23.03 34.09C23.415 33.95 23.8175 33.8275 24.185 33.67C24.325 33.6175 24.465 33.5475 24.605 33.4775C24.9725 33.32 25.34 33.145 25.7075 32.9525C25.8475 32.8825 25.97 32.795 26.0925 32.725C26.4425 32.515 26.7925 32.3225 27.1425 32.095C27.265 32.025 27.37 31.9375 27.4925 31.85C27.8425 31.605 28.175 31.36 28.49 31.0975C28.595 31.01 28.6825 30.9225 28.7875 30.8525C28.98 30.695 29.1725 30.5375 29.3475 30.38C29.3475 30.3625 29.3475 30.3625 29.33 30.345C32.8125 27.1425 35 22.575 35 17.5ZM26.145 26.1975C21.4025 23.0125 13.6325 23.0125 8.855 26.1975C8.085 26.705 7.455 27.3 6.93 27.9475C4.27 25.2525 2.625 21.56 2.625 17.5C2.625 9.2925 9.2925 2.625 17.5 2.625C25.7075 2.625 32.375 9.2925 32.375 17.5C32.375 21.56 30.73 25.2525 28.07 27.9475C27.5625 27.3 26.915 26.705 26.145 26.1975Z')
          ..color = const Color.fromARGB(255, 94, 78, 228),
      ]),
    );
  }
}

class _GeneratedVectorWidget4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 13.125,
      height: 13.107516288757324,
      child: SvgWidget(painters: [
        SvgPathPainter.fill()
          ..addPath(
              'M6.5625 0C2.94 0 0 2.94 0 6.56252C0 10.115 2.7825 13.0025 6.475 13.1075L6.6325 13.1075L6.755 13.1075L6.79 13.1075C10.325 12.985 13.1075 10.115 13.125 6.56252C13.125 2.94 10.185 0 6.5625 0Z')
          ..color = const Color.fromARGB(255, 94, 78, 228),
      ]),
    );
  }
}
