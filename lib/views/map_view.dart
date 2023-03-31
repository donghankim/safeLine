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
import 'package:firebase_database/firebase_database.dart';
import 'package:safe_line/models/train.dart';
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
  late BitmapDescriptor trainIcon;
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _manhattan = CameraPosition(
    target: LatLng(40.785091, -73.968285),
    zoom: 13,
  );

  // data
  Map<String, Train> allTrains = <String, Train>{};
  final Map<String, Station> allStations = <String, Station>{};
  final Set<Polyline> subwayLines = <Polyline>{};
  final Set<Circle> stationMarkers = <Circle>{};

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
    _testListener();
  }

  @override
  void deactivate() {
    _testStream.cancel();
    super.deactivate();
  }

  void _testListener() {
    _testStream = db.child('mta_stream').onValue.listen(
      (element) {
        var data = Map<String, dynamic>.from(
            element.snapshot.value as Map<dynamic, dynamic>);
        tools.log(data.toString());
      },
    );
  }

  Future<void> loadStations() async {
    trainIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(15, 15)), 'asset/images/train_up.png');

    var string =
        await rootBundle.loadString('asset/processed/stations_processed.csv');
    var dataList = const CsvToListConverter().convert(string, eol: "\n");
    for (var data in dataList) {
      if (data[0] != "id") {
        // add station data
        String stationId = data[0].toString();
        Station newStation = Station(
            id: stationId,
            name: data[1],
            pos: LatLng(data[2], data[3]),
            lines: data[4].toString().split(' '));
        // allStations.add(newStation);
        allStations[stationId] = newStation;

        // add station marker
        stationMarkers.add(newStation.getCircle());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadStations(),
      builder: (context, _) {
        allTrains["12asdasd3"] =
            Train("12asdasd3", "1", "down", "something", "somethwere", "good");
        var currMarkers = allTrains.values
            .map(
              (train) {
                return train.getMarker(
                    const LatLng(40.807722, -73.96411), trainIcon);
              },
            )
            .toList()
            .toSet();
        return Scaffold(
          body: GoogleMap(
            initialCameraPosition: _manhattan,
            myLocationButtonEnabled: false,
            markers: currMarkers,
            circles: stationMarkers,
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
