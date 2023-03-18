// sign-up widgets
import 'package:flutter/material.dart';
import 'package:safe_line/auth/auth_service.dart';
import 'package:safe_line/auth/auth_exceptions.dart';
import 'package:safe_line/routes.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

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

  Future<bool> registerUser(String email, String password) async {
    try {
      await AuthService.firebase()
          .registerUser(email: email, password: password);
      return true;
    } on EmailTakenException {
      ScaffoldMessenger.of(context).showSnackBar(emailInUseBar);
    } on InvalidEmailException {
      ScaffoldMessenger.of(context).showSnackBar(invalidEmailBar);
    } on WeakPassWordException {
      ScaffoldMessenger.of(context).showSnackBar(weakPasswordBar);
    } catch (_) {
      await showErrorDialog(context);
    }
    return false;
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
                        if (await registerUser(_email.text, _password.text)) {
                          if (context.mounted) {
                            Navigator.pushNamed(context, emailVerifyRoute);
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
  const VerifyEmailPage({Key? key}) : super(key: key);

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
            const SizedBox(height: 50),
            const Text(
                "Email verification is required to register your account."),
            TextButton(
                onPressed: () async {
                  AuthService.firebase().sendVerification();
                  Navigator.pop(context);
                },
                child: const Text("Verify My Email "))
          ],
        ),
      ),
    );
  }
}
