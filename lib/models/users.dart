import 'package:firebase_auth/firebase_auth.dart';

// TODO:
// 1. keep track of all posts AppUser posts
// 2. merge leaderboard

class AppUser {
  final String id;
  final String? email;
  final String? displayName;
  final bool isVerified;
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
