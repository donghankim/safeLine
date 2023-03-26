import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_line/auth/all_auth.dart';
import 'package:safe_line/models/users.dart';

class FirebaseProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  AppUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AppUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null && user.isVerified) {
        return user;
      } else {
        throw GenericAuthException();
      }
    } on FirebaseAuthException catch (except) {
      if (except.code == 'wrong-password') {
        throw IncorrectPasswordException();
      } else if (except.code == 'invalid-email') {
        throw InvalidEmailException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<AppUser> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        user.displayName = name;
        addUser(user);
        return user;
      } else {
        throw GenericAuthException();
      }
    } on FirebaseAuthException catch (except) {
      if (except.code == 'weak-password') {
        throw WeakPassWordException();
      } else if (except.code == 'email-already-in-use') {
        throw EmailTakenException();
      } else if (except.code == 'invalid-email') {
        throw InvalidEmailException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  Future addUser(AppUser user) async {
    await FirebaseFirestore.instance.collection('users').add({
      'DisplayName': user.displayName,
      'UID': user.id,
      'Email': user.email,
      'Score': user.score,
    });
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw GenericAuthException();
    }
  }
}
