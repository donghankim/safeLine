import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:safe_line/auth/all_auth.dart';
import 'package:safe_line/views/all_views.dart';
import 'package:safe_line/routes.dart';
import 'package:safe_line/constants.dart';

/*
1. Add API key for android and apple (google maps)
2. setup google maps design
3. setup google transit API
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Safe Line",
      home: const StartPage(),
      routes: {
        landingRoute: (context) => const LandingPage(),
        loginRoute: (context) => const RegisterPage(formType: "login"),
        signupRoute: (context) => const RegisterPage(formType: "register"),
        emailVerifyRoute: (context) => const VerifyEmailPage(),
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
                return HomePage(currUser: user);
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
