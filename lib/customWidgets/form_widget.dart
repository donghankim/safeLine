import 'package:flutter/material.dart';
import 'package:safe_line/routes.dart';
import 'package:safe_line/views/map_view.dart';
import 'package:safe_line/auth/auth_service.dart';
import 'package:safe_line/auth/auth_exceptions.dart';

class FormWidget extends StatefulWidget {
  final String type_;

  const FormWidget({Key? key, required this.type_}) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  late final String formType;
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type_ == "login") {
      return loginForm(context);
    } else {
      return signupForm(context);
    }
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
      ScaffoldMessenger.of(context).showSnackBar(generalErrorBar);
    }
    return false;
  }

  Future<bool> registerUser(String email, String password,
      String passwordConfirm, String name) async {
    if (password == passwordConfirm) {
      try {
        await AuthService.firebase()
            .registerUser(email: email, password: password, name: name);
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(passwordDiffBar);
    }
    return false;
  }

  Column signupForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sign Up",
          overflow: TextOverflow.visible,
          textAlign: TextAlign.left,
          style: TextStyle(
            height: 1.210227279663086,
            fontSize: 25.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 94, 78, 228),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Name",
          overflow: TextOverflow.visible,
          textAlign: TextAlign.left,
          style: TextStyle(
            height: 1.2102272033691406,
            fontSize: 15.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 105, 105, 109),
          ),
        ),
        SizedBox(
          width: 350,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              controller: _name,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: "Your Name",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    width: 0.5,
                    color: Color.fromARGB(255, 196, 194, 212),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            "Email Address",
            overflow: TextOverflow.visible,
            textAlign: TextAlign.left,
            style: TextStyle(
              height: 1.2102272033691406,
              fontSize: 15.0,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 105, 105, 109),
            ),
          ),
        ),
        SizedBox(
          width: 350,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    width: 0.5,
                    color: Color.fromARGB(255, 196, 194, 212),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            "New Password",
            overflow: TextOverflow.visible,
            textAlign: TextAlign.left,
            style: TextStyle(
              height: 1.2102272033691406,
              fontSize: 15.0,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 105, 105, 109),
            ),
          ),
        ),
        SizedBox(
          width: 350,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "min. 8 characters",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    width: 0.5,
                    color: Color.fromARGB(255, 196, 194, 212),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 350,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              controller: _confirmPassword,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    width: 0.5,
                    color: Color.fromARGB(255, 196, 194, 212),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: 350,
          height: 40,
          child: ElevatedButton(
            onPressed: () async {
              if (await registerUser(_email.text, _password.text,
                  _confirmPassword.text, _name.text)) {
                if (context.mounted) {
                  Navigator.pushNamed(context, emailVerifyRoute);
                }
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 94, 78, 228),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                )),
            child: const Text("Verify"),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account?",
                overflow: TextOverflow.visible,
                textAlign: TextAlign.left,
                style: TextStyle(
                  height: 1.2102272033691406,
                  fontSize: 15.0,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 143, 143, 147),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, loginRoute);
                  },
                  child: const Text("Login here."))
            ],
          ),
        ),
      ],
    );
  }

  Column loginForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Login",
          overflow: TextOverflow.visible,
          textAlign: TextAlign.left,
          style: TextStyle(
            height: 1.210227279663086,
            fontSize: 25.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            color: Color.fromARGB(255, 94, 78, 228),
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            "Email Address",
            overflow: TextOverflow.visible,
            textAlign: TextAlign.left,
            style: TextStyle(
              height: 1.2102272033691406,
              fontSize: 15.0,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 105, 105, 109),
            ),
          ),
        ),
        SizedBox(
          width: 350,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    width: 0.5,
                    color: Color.fromARGB(255, 196, 194, 212),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            "Password",
            overflow: TextOverflow.visible,
            textAlign: TextAlign.left,
            style: TextStyle(
              height: 1.2102272033691406,
              fontSize: 15.0,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 105, 105, 109),
            ),
          ),
        ),
        SizedBox(
          width: 350,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Password",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    width: 0.5,
                    color: Color.fromARGB(255, 196, 194, 212),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: 350,
          height: 40,
          child: ElevatedButton(
            onPressed: () async {
              if (await loginUser(_email.text, _password.text)) {
                final user = AuthService.firebase().currentUser;
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPage(),
                    ),
                    (route) => false);
                }
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 94, 78, 228),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                )),
            child: const Text("Login"),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "New to SafeLine?",
                overflow: TextOverflow.visible,
                textAlign: TextAlign.left,
                style: TextStyle(
                  height: 1.2102272033691406,
                  fontSize: 15.0,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 143, 143, 147),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, signupRoute);
                  },
                  child: const Text("Sign up!"))
            ],
          ),
        ),
      ],
    );
  }
}
