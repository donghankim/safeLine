import 'package:flutter/material.dart';
import 'package:safe_line/customWidgets/appTitle_widget.dart';
import 'package:safe_line/customWidgets/form_widget.dart';

class RegisterPage extends StatefulWidget {
  final String formType;

  const RegisterPage({Key? key, required this.formType}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 241, 251),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 150),
          // safeLine title
          const SafeLineWidget(),
          const SizedBox(height: 75),
          // form
          SizedBox(
            width: 300,
            child: FormWidget(type_: widget.formType),
          ),
        ],
      ),
    );
  }
}
