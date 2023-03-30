import 'package:flutter/material.dart' show Colors;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_line/constants.dart';

class Station {
  final String id;
  final String name;
  final LatLng pos;
  final List<String> lines;
  // connected lines

  Station(
      {required this.id,
      required this.name,
      required this.pos,
      required this.lines});

  Circle getCircle() {
    return Circle(
      circleId: CircleId(pos.toString()),
      center: pos,
      radius: 25,
      fillColor: accentColor,
    );
  }
}
