import 'package:flutter/material.dart';
import 'package:safe_line/models/users.dart';

abstract class AuthProvider {
  Future<void> initialize();
  AppUser? get currentUser;

  Future<AppUser> login({
    required String email,
    required String password,
  });

  Future<AppUser> registerUser({
    required String email,
    required String password,
    required String name,
  });

  Future<void> logout(BuildContext context);
  Future<void> sendVerification();
}
