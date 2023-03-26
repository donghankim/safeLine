// add enum for uptown/downtown

class Report {
  final String userUID;
  late DateTime postTime;
  String? description;
  int votes = 0;

  Report(this.userUID, this.description) {
    postTime = DateTime.now();
  }
}
