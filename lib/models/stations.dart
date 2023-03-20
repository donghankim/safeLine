import 'package:safe_line/models/reports.dart';

class Station {
  final String name;
  final double long;
  final double lat;
  List<Report> stationReports = [];
  int incidentsCount = 0;

  Station(this.name, this.long, this.lat);

  // add getters/setters
}
