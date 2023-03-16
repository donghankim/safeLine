// import 'dart:developer' as tools;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:safe_line/firebase_options.dart';
import 'package:safe_line/views/all_views.dart';
import 'package:safe_line/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Safe Line",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StartPage(),
      routes: {
        loginRoute: (context) => const LoginPage(),
        registerRoute: (context) => const RegistrationPage(),
        homeRoute: (context) => const HomePage()
      },
    ),
  );
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final User? user = FirebaseAuth.instance.currentUser;
              if (user != null && user.emailVerified) {
                return const HomePage();
              }
              else {
                return const LoginPage();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
