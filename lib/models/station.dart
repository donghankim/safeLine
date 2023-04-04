import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_line/constants.dart';


class Station {
  final String id;
  final String name;
  final LatLng pos;
  // connected lines

  Station(
      {required this.id,
      required this.name,
      required this.pos,
      });

  Circle getCircle() {
    return Circle(
      circleId: CircleId(pos.toString()),
      center: pos,
      radius: 30,
      fillColor: accentColor,
      strokeWidth: 0,
    );
  }
}
