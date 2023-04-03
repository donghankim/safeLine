import 'package:safe_line/models/report.dart';


class Train {
  final String id;
  final String line;
  final String direction;
  final String headsign;
  String currSt = "";
  String nextSt = "";
  String status = "PRE";
  bool delayed = false;
  List<Report> incidentReports = [];

  Train._internal(this.id, this.line, this.direction, this.headsign, this.currSt, this.nextSt,
      this.status, this.delayed);

  factory Train(String id, Map<String, dynamic> data) {
    return Train._internal(id, data['line'], data['direction'], data['headsign'], data['curr_st'],
        data['next_st'], data['status'], data['isDelay']);
  }

}
