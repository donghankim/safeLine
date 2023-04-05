import 'package:flutter/material.dart';
import 'package:safe_line/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Report with ChangeNotifier {
  final String userId;
  final String trainId;
  String _description;
  int _validityScore = 0;
  late final DateTime postTime;

  factory Report(String trainId, String description) {
    final currUser = AuthService.firebase().currentUser!;
    DateTime postedTime = DateTime.now();
    return Report._interal(currUser.id, trainId, description, postedTime);
  }
  Report._interal(this.userId, this.trainId, this._description, this.postTime);

  factory Report.fromFS(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Report._external(data['userId'], data['trainId'], data['description'],
        data['validity'], data['postTime'].toDate());
  }
  Report._external(this.userId, this.trainId, this._description,
      this._validityScore, this.postTime);

  int get validity => _validityScore;
  String get description => _description;

  void incrementValidity() {
    _validityScore++;
  }

  Future<void> addReport() async {
    DateTime postedTime = DateTime.now();
    await FirebaseFirestore.instance.collection('reports').add({
      'userId': userId,
      'trainId': trainId,
      'postTime': postedTime,
      'description': description,
      'validity': validity,
    });
  }
}
