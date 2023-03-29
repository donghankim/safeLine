import 'package:safe_line/models/report.dart';

class Train {
  final String line;
  String direction;
  final int fleetNumber;
  late double currLong;
  late double currLat;
  List<Report> incidentReports = [];

  Train(this.line, this.direction, this.fleetNumber) {
    // set initial currLong/currLat
  }
}
