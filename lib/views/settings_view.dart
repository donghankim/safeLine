import 'package:flutter/material.dart';
import 'package:safe_line/auth/auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  final user = AuthService.firebase().currentUser;

  @override
  void initState() {
    _name = TextEditingController(text: user?.displayName);
    _email = TextEditingController(text: user?.email);
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

  // TODO
  Future<bool> updateUser(String email, String password, String name) async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("User Settings"),

      ),
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
              // TODO: add some decorative UI

              // name text input
              SizedBox(
                  width: 350,
                  child: TextField(
                      controller: _name,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: "Name"))),
              const SizedBox(height: 15),

              // email text input
              SizedBox(
                  width: 350,
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

              // password text input
              SizedBox(
                  width: 350,
                  child: TextField(
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: "New Password"))),
              const SizedBox(height: 15),

              // confirm password text input
              SizedBox(
                  width: 350,
                  child: TextField(
                      controller: _confirmPassword,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: "Confirm Password"))),
              const SizedBox(height: 30),

              // register button
              SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        // TODO
                      },
                      child: const Text("Update Account"))),
              const SizedBox(height: 15),

              // logout button
              SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        await AuthService.firebase().logout();
                        if (context.mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login/', (route) => false);
                        }
                      },
                      child: const Text("Logout"))),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
