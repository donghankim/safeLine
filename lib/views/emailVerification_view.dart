import 'package:flutter/material.dart';
import 'package:safe_line/auth/auth_service.dart';
import 'package:safe_line/routes.dart';

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
            Image.asset('asset/images/email_verification.png', height: 200),
            const SizedBox(height: 50),
            const Text(
                "Email verification is required to register your account."),
            TextButton(
                onPressed: () async {
                  AuthService.firebase().sendVerification();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text("Verify My Email "))
          ],
        ),
      ),
    );
  }
}
