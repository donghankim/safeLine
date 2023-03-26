import 'package:flutter/material.dart';

class GenericAuthException implements Exception {}

class WeakPassWordException implements Exception {}

class InvalidEmailException implements Exception {}

class EmailTakenException implements Exception {}

class IncorrectPasswordException implements Exception {}

Future<void> showErrorDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Application error.'),
              Text('Please try again later.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

const invalidEmailBar = SnackBar(
  content: Text("Email not valid."),
  backgroundColor: Color.fromARGB(255, 94, 78, 228),
  duration: Duration(seconds: 1),
);

const emailInUseBar = SnackBar(
  content: Text("Email already regsitered."),
  backgroundColor: Color.fromARGB(255, 94, 78, 228),
  duration: Duration(seconds: 1),
);

const weakPasswordBar = SnackBar(
  content: Text("Password too weak..."),
  backgroundColor: Color.fromARGB(255, 94, 78, 228),
  duration: Duration(seconds: 1),
);

const email404Bar = SnackBar(
  content: Text("Email not registered..."),
  backgroundColor: Color.fromARGB(255, 94, 78, 228),
  duration: Duration(seconds: 1),
);

const incorrectPasswordBar = SnackBar(
  content: Text("Incorrect Password!"),
  backgroundColor: Color.fromARGB(255, 94, 78, 228),
  duration: Duration(seconds: 1),
);

const passwordDiffBar = SnackBar(
  content: Text("Oops, your password did not match"),
  backgroundColor: Color.fromARGB(255, 94, 78, 228),
  duration: Duration(seconds: 1),
);

const generalErrorBar = SnackBar(
  content: Text("Hmm...? Could not find your account."),
  backgroundColor: Color.fromARGB(255, 94, 78, 228),
  duration: Duration(seconds: 1),
);
