import 'package:safe_line/auth/auth_provider.dart';
import 'package:safe_line/auth/firebase_provider.dart';
import 'package:safe_line/models/users.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);
  factory AuthService.firebase() => AuthService(FirebaseProvider());

  @override
  AppUser? get currentUser => provider.currentUser;

  @override
  Future<AppUser> registerUser({
    required String email,
    required String password,
    required String name,
  }) =>
      provider.registerUser(
        email: email,
        password: password,
        name: name,
      );

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(
        email: email,
        password: password,
      );

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendVerification() => provider.sendVerification();

  @override
  Future<void> initialize() => provider.initialize();
}
