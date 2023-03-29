import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:safe_line/models/users.dart';

class Database {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  List<String> users = [];
  List<int> userScores = [];


}
