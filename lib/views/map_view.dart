import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_line/constants.dart';
import 'package:safe_line/customWidgets/report_widget.dart';
import 'package:safe_line/auth/auth_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:safe_line/routes.dart';
import 'package:csv/csv.dart';
import 'package:safe_line/models/station.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'dart:developer' as tools;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final currUser = AuthService.firebase().currentUser;
  final db = FirebaseDatabase.instance.ref();

  // gmaps
  late String _gmapStyle;
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _manhattan = CameraPosition(
    target: LatLng(40.785091, -73.968285),
    zoom: 13,
  );

  // maps animation
  List<Station> stationArr = [];
  Map<String, dynamic> lineMap = {};
  Set<Circle> _stationCircles = Set<Circle>();
  Set<Polyline> _trainLines = Set<Polyline>();

  // Real-time Firebase
  late StreamSubscription _testStream;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('asset/processed/map_design.json').then(
      (string) {
        _gmapStyle = string;
      },
    );
    rootBundle.loadString('asset/processed/stations_processed.csv').then(
      (string) {
        var dataList = const CsvToListConverter().convert(string, eol: "\n");
        for (var data in dataList) {
          if (data[0] != "id") {
            // add station data
            String connectedLines = data[4].toString();
            Station newStation = Station(
                id: data[0],
                name: data[1],
                pos: LatLng(data[2], data[3]),
                lines: connectedLines.split(' '));
            stationArr.add(newStation);

            // add station marker
            _stationCircles.add(newStation.getCircle());
          }
        }
      },
    );

    // Firebase Stream listeners
    _testListener();
  }

  @override
  void deactivate() {
    _testStream.cancel();
    super.deactivate();
  }

  void _testListener() {
    _testStream = db.child('mta_stream/1').onValue.listen((element) {
      var data = Map<String, dynamic>.from(
          element.snapshot.value as Map<dynamic, dynamic>);
      // tools.log(data.runtimeType.toString());
      // tools.log(data['011955SFT_242'].toString());
    });
  }

  Future<void> loadData() async {
    tools.log("CALLED");
    // load subway lines
    // String lineData = await rootBundle.loadString('asset/processed/lines_processed.json');
    // lineMap = jsonDecode(lineData);

    // load subway stations
    await rootBundle.loadString('asset/processed/stations_processed.csv').then(
      (string) {
        var dataList = const CsvToListConverter().convert(string, eol: "\n");
        for (var data in dataList) {
          if (data[0] != "id") {
            String connectedLines = data[4].toString();
            Station newStation = Station(
                id: data[0],
                name: data[1],
                pos: LatLng(data[2], data[3]),
                lines: connectedLines.split(' '));
            stationArr.add(newStation);
          }
        }
        _stationCircles = stationArr.map((st) => st.getCircle()).toSet();
        tools.log(_stationCircles.length.toString());
        lineMap.forEach(
          (lineId, stations) {
            List<LatLng> currLineArr = [];
            int idx = subwayLines.indexOf(lineId);
            MaterialColor lineColor = subwayIconColor[idx];
            for (var id_ in stations) {
              Station newSt = stationArr.where((st) => st.id == id_).first;
              currLineArr.add(newSt.pos);
            }
            /*
            _trainLines.add(
              Polyline(
                polylineId: PolylineId(lineId),
                points: currLineArr,
                color: lineColor,
                width: 3,
              ),
            );
            */
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadData(),
      builder: (context, _) {
        return Scaffold(
          body: GoogleMap(
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition: _manhattan,

            // polylines: _trainLines,
            circles: _stationCircles,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;
              mapController.setMapStyle(_gmapStyle);
            },
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 15, 0),
            child: SizedBox(
              width: 70,
              height: 300,
              child: Column(
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      reportModelView(context);
                    },
                    heroTag: "report-btn",
                    backgroundColor: accentColor,
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                      onPressed: () {
                        Navigator.pushNamed(context, leadersRoute);
                      },
                      heroTag: "leader-btn",
                      backgroundColor: accentColor,
                      child: const Icon(Icons.leaderboard)),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, profileRoute);
                    },
                    heroTag: "profile-btn",
                    backgroundColor: accentColor,
                    child: const Icon(Icons.person),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        );
      },
    );
  }
}
