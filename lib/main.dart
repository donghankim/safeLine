import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:safe_line/auth/all_auth.dart';
import 'package:safe_line/views/all_views.dart';
import 'package:safe_line/routes.dart';
import 'package:safe_line/constants.dart';

/*
- I know how to draw subway lines and stations

What I need to do:
- stream train info using python to firebase (python code needs to be hosted on GCP dataflow?)
- provider to read the updated train info
- animate trains as they move.

- refactor code
- fix screen size crap
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterConfig.loadEnvVariables();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SafeLine",
      home: const SafeLineApp(),
      routes: {
        landingRoute: (context) => const LandingPage(),
        loginRoute: (context) => const RegisterPage(formType: "login"),
        signupRoute: (context) => const RegisterPage(formType: "register"),
        emailVerifyRoute: (context) => const VerifyEmailPage(),
        leadersRoute: (context) => const LeaderPage(),
        profileRoute: (context) => const ProfilePage(),
      },
    ),
  );
}

class SafeLineApp extends StatelessWidget {
  const SafeLineApp({super.key});

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
                return const MapPage();
              } else {
                return const LandingPage();
              }
            default:
              return circularLoader;
          }
        },
      ),
    );
  }
}
