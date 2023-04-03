import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_line/models/train.dart';
import 'package:safe_line/models/report.dart';

class TrainController {
  final _db = FirebaseDatabase.instance.ref();
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  Map<String, Train> allTrains = <String, Train>{};

  Future<void> _updateTrainReports(Train currTrain) async {
    final snapshot = await _fs
        .collection('reports')
        .where('trainId', isEqualTo: currTrain.id)
        .get();
    for (var doc in snapshot.docs) {
      currTrain.incidentReports.add(Report.fromFS(doc));
    }
  }

  Stream<List<Train>> getTrainMarkers() {
    final trainStream = _db.child('mta_stream').onValue;
    final streamRes = trainStream.map(
      (event) {
        final dataMap = Map<String, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);
        final trainList = dataMap.entries.map(
          (element) {
            Train currTrain;
            if (allTrains.containsKey(element.key)) {
              currTrain = allTrains[element.key]!;
              currTrain.currSt = element.value['curr_st'];
              currTrain.nextSt = element.value['next_st'];
              currTrain.status = element.value['status'];
              currTrain.delayed = element.value['isDelay'];
            } else {
              currTrain =
                  Train(element.key, Map<String, dynamic>.from(element.value));
              allTrains[element.key] = currTrain;
            }
            _updateTrainReports(currTrain);
            return currTrain;
          },
        ).toList();
        return trainList;
      },
    );
    return streamRes;
  }
}
