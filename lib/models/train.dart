import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_line/models/report.dart';

class Train {
  final String id;
  final String line;
  final String direction;
  final String headsign;
  String stName;
  LatLng currSt;
  LatLng nextSt;
  String status = "STOPPED_AT";
  bool delayed = false;
  List<Report> incidentReports = [];

  Train._internal(this.id, this.line, this.direction, this.headsign,
      this.stName, this.currSt, this.nextSt, this.status, this.delayed);

  factory Train(String id, Map<String, dynamic> data, String stName,
      LatLng currSt, LatLng nextSt) {
    return Train._internal(
        id,
        data['line'],
        data['direction'],
        data['headsign'],
        stName,
        currSt,
        nextSt,
        data['status'],
        data['isDelay']);
  }
}
