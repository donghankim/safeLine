// login widgets
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_line/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_line/views/all_views.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  static const invalidBar = SnackBar(
    content: Text("Email not found..."),
    backgroundColor: Colors.blue,
    duration: Duration(seconds: 1),
  );
  static const incorrectBar = SnackBar(
    content: Text("Incorrect Password!"),
    backgroundColor: Colors.blue,
    duration: Duration(seconds: 1),
  );

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("media/subway.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Safe Line",
                  style: GoogleFonts.acme(
                      textStyle: const TextStyle(fontSize: 100))),
              const SizedBox(
                height: 130,
              ),
              SizedBox(
                  width: 300,
                  child: TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: "Email"))),
              const SizedBox(height: 15),
              SizedBox(
                  width: 300,
                  child: TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: "Password"))),
              const SizedBox(height: 30),
              SizedBox(
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          final loggedUser = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          if (loggedUser.user!.emailVerified) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              homeRoute,
                              (route) => false,
                            );
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    VerifyEmailPage(currentUser: loggedUser.user!)));
                          }
                        } on FirebaseAuthException catch (except) {
                          if (except.code == "user-not-found") {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(invalidBar);
                          } else if (except.code == "wrong-password") {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(incorrectBar);
                          }
                        }
                      },
                      child: const Text("Login"))),
              const SizedBox(height: 45),
              SizedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Dont't Have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              registerRoute, (route) => false);
                        },
                        child: const Text("Sign Up"))
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
