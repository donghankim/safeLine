import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String id;
  final String? email;
  final bool isVerified;
  String? displayName;
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
}
