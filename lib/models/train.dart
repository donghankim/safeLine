import 'package:safe_line/models/report.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Train {
  final String id;
  final String line;
  final String direction;
  final String headsign;
  final String nextSt;
  String status = "PRE";
  List<Report> incidentReports = [];

  Train(this.id, this.line, this.direction, this.headsign, this.nextSt,
      this.status);

  Marker getMarker(LatLng pos, BitmapDescriptor icon) {
    double currRot;
    if (direction == "N") {
      currRot = 0;
    } else {
      currRot = 180;
    }
    return Marker(
        markerId: MarkerId(id),
        position: pos,
        onTap: () {
          // modal view
        },
        icon: icon,
        rotation: currRot);
  }
}
