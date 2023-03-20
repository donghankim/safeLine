// login widgets
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_line/auth/auth_service.dart';
import 'package:safe_line/auth/auth_exceptions.dart';
import 'package:safe_line/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  Future<bool> loginUser(String email, String password) async {
    try {
      await AuthService.firebase().login(email: email, password: password);
      return true;
    } on InvalidEmailException {
      ScaffoldMessenger.of(context).showSnackBar(email404Bar);
    } on IncorrectPasswordException {
      ScaffoldMessenger.of(context).showSnackBar(incorrectPasswordBar);
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
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("asset/images/subway.png"),
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
                        if (await loginUser(_email.text, _password.text)) {
                          if (context.mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              homeRoute,
                              (route) => false,
                            );
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
                          Navigator.pushNamed(context, registerRoute);
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
