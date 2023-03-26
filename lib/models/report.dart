// add enum for uptown/downtown

class Report {
  final String uid;
  late DateTime postTime;
  String? description;
  int votes = 0;

  Report(this.uid, this.description) {
    postTime = DateTime.now();
  }
}
