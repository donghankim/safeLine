import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_line/models/station.dart';
import 'package:safe_line/models/train.dart';
import 'package:safe_line/models/report.dart';
// import 'dart:developer' as tools;

class TrainController {
  final _db = FirebaseDatabase.instance.ref();
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  late Uint8List upIcon;
  late Uint8List downIcon;
  late Uint8List movingUpIcon;
  late Uint8List movingDownIcon;
  late Uint8List delayIcon;
  late Uint8List incidentIcon;

  final Map<String, Station> allStations = <String, Station>{};
  final Set<Circle> stationMarkers = <Circle>{};

  Map<String, Train> allTrains = <String, Train>{};

  Future<void> _getTrainReports(Train currTrain) async {
    final snapshot = await _fs
        .collection('reports')
        .where('trainId', isEqualTo: currTrain.id)
        .get();
    for (var doc in snapshot.docs) {
      currTrain.incidentReports.add(Report.fromFS(doc));
    }
  }

  Stream<Set<Train>> trainDataStream() {
    final trainStream = _db.child('mta_stream').onValue;
    final streamRes = trainStream.map(
      (event) {
        final dataMap = Map<String, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);

        final trainSet = dataMap.entries.map(
          (element) {
            var tdata = Map<String, dynamic>.from(element.value);
            var tid = element.key;
            String stName = allStations[tdata['curr_st']]!.name;
            LatLng currSt = allStations[tdata['curr_st']]!.pos;

            Train currTrain;
            if (allTrains.containsKey(tid)) {
              currTrain = allTrains[tid]!;
              currTrain.stName = stName;
              currTrain.currSt = currSt;
              currTrain.status = tdata['status'];
              currTrain.delayed = tdata['isDelay'];
            } else {
              currTrain = Train(tid, tdata, stName, currSt);
              allTrains[tid] = currTrain;
              _getTrainReports(currTrain);
            }
            return currTrain;
          },
        ).toSet();
        return trainSet;
      },
    );
    return streamRes;
  }
}
