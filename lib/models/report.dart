// add enum for uptown/downtown

class Report {
  final String userId;
  final String trainId;
  late DateTime postTime;
  String? description;
  int validityScore = 0;

  Report(this.userId, this.trainId, this.description) {
    postTime = DateTime.now();
  }
}
