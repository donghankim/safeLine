import 'package:safe_line/models/report.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Train {
  final String id;
  final String line;
  final String direction;
  final String headsign;
  String nextSt;
  String nextStName = "";
  String status = "PRE";
  bool delayed = false;
  List<Report> incidentReports = [];

  Train(this.id, this.line, this.direction, this.headsign, this.nextSt,
      this.status, this.delayed);

  Marker getMarker(LatLng pos, BitmapDescriptor icon, double iconRot) {
    return Marker(
        markerId: MarkerId(id),
        position: pos,
        onTap: () {},
        icon: icon,
        rotation: iconRot);
  }
}
