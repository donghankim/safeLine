// sign-up widgets
import 'package:flutter/material.dart';
import 'package:safe_line/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  static const invalidEmail = SnackBar(
    content: Text("Email not valid."),
    backgroundColor: Colors.blue,
    duration: Duration(seconds: 1),
  );
  static const emailInUse = SnackBar(
    content: Text("Email already regsitered."),
    backgroundColor: Colors.blue,
    duration: Duration(seconds: 1),
  );
  static const weakPassword = SnackBar(
    content: Text("Password too weak..."),
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
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 75),
              Image.asset('media/columbia_crest.png', height: 200),
              const SizedBox(height: 50),
              SizedBox(
                  width: 300,
                  child: TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
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
                          final newCreds = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          final User? newUser = newCreds.user;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  VerifyEmailPage(currentUser: newUser)));
                        } on FirebaseAuthException catch (except) {
                          if (except.code == "weak-password") {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(weakPassword);
                          } else if (except.code == "email-already-in-use") {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(emailInUse);
                          } else if (except.code == "invalid-email") {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(invalidEmail);
                          }
                        }
                      },
                      child: const Text("Create Account"))),
              const SizedBox(height: 15),
              SizedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already registered?"),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              loginRoute, (route) => false);
                        },
                        child: const Text("Log In"))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// verify email page
class VerifyEmailPage extends StatefulWidget {
  final User? currentUser;

  const VerifyEmailPage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Email Verification")),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('media/email_verification.png', height: 200),
            const SizedBox(height:50),
            const Text("Email verification is required to register your account."),
            TextButton(
                onPressed: () async {
                  await widget.currentUser?.sendEmailVerification();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false,
                  );
                },
                child: const Text("Verify My Email "))
          ],
        ),
      ),
    );
  }
}
