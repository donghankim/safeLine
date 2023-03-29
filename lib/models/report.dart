// add enum for uptown/downtown

import 'package:flutter/material.dart';
import 'package:safe_line/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Report with ChangeNotifier {
  final String userId;
  final String trainId;
  String _description;
  String _line = "";
  int _validityScore = 0;
  late final DateTime _postTime;

  Report._interal(this.userId, this.trainId, this._description);

  factory Report() {
    final currUser = AuthService.firebase().currentUser!;
    return Report._interal(currUser.id, "temp", "");
  }

  DateTime get postTime => _postTime;
  int get validity => _validityScore;
  String get description => _description;
  String get trainLine => _line;

  void setTrainLine(String newLine) {
    _line = newLine;
    notifyListeners();
  }

  void updateDescription(String newDesc) {
    _description = newDesc;
    notifyListeners();
  }

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
