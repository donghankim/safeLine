// add photo field

class Report {
  final String posterId;
  String? content;
  DateTime? postTime;
  int likes = 0;

  Report(this.posterId,this.content) {
    postTime = DateTime.now();
  }
}


