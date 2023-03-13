import 'dart:developer' as tools;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'views/all.dart';
import 'base.dart';

void main() {
  // runApp(const MyApp());

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Safe Line",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StartPage(),
      routes: {
        '/login/': (context) => const LoginPage(),
        '/register/': (context) => const RegistrationPage(),
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
              final user = FirebaseAuth.instance.currentUser;
              tools.log(user.toString());
              if (user != null && user.emailVerified) {
                return const HomePage();
              } else {
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
