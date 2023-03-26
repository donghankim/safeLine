// import 'dart:developer' as tools; -> for logging instead of print();
import 'package:flutter/material.dart';
import 'package:safe_line/auth/all_auth.dart';
import 'package:safe_line/views/all_views.dart';
import 'package:safe_line/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Safe Line",
      home: const StartPage(),
      routes: {
        loginRoute: (context) => const RegisterPage(formType: "login"),
        signupRoute: (context) => const RegisterPage(formType: "register"),
        homeRoute: (context) => const HomePage(),
        emailVerifyRoute: (context) => const VerifyEmailPage(),
        settingsRoute: (context) => const SettingsPage(),
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
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null && user.isVerified) {
                return const HomePage();
              } else {
                return const LandingPage();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
