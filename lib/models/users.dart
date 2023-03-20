import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_line/models/reports.dart';

class AppUser {
  final String id;
  final String? email;
  final bool isVerified;
  String? displayName;
  List<Report> userPosts = [];
  int score = 0;

  AppUser(
    this.id,
    this.email,
    this.displayName,
    this.isVerified,
  );

  factory AppUser.fromFirebase(User user) => AppUser(
        user.uid,
        user.email,
        user.displayName,
        user.emailVerified,
      );

  void incrementScore() {
    score++;
  }

  int getScore() {
    return score;
  }
}
