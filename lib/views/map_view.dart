import 'package:flutter/material.dart';
import 'package:safe_line/constants.dart';
import 'package:safe_line/customWidgets/report_widget.dart';
import 'package:safe_line/auth/auth_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:safe_line/routes.dart';
import 'package:csv/csv.dart';
import 'package:safe_line/models/station.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:safe_line/models/train.dart';
import 'package:flutter_config/flutter_config.dart';
import 'dart:developer' as tools;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final currUser = AuthService.firebase().currentUser;
  final db = FirebaseDatabase.instance.ref();
  final String _apiKey = FlutterConfig.get('GMAP_API_KEY');

  // gmaps
  late String _gmapStyle;
  late BitmapDescriptor trainIcon;
  late BitmapDescriptor delayIcon;
  late BitmapDescriptor incidentIcon;
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _manhattan = CameraPosition(
    target: LatLng(40.785091, -73.968285),
    zoom: 13,
  );

  // data
  Map<String, Train> allTrains = <String, Train>{};
  Set<Marker> currMarkers = <Marker>{};
  final Map<String, Station> allStations = <String, Station>{};
  final Set<Polyline> subwayLines = <Polyline>{};
  final Set<Circle> stationMarkers = <Circle>{};

  // Real-time Firebase
  late StreamSubscription _mtaStream;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('asset/processed/map_design.json').then(
      (string) {
        _gmapStyle = string;
      },
    );
    _streamListener();
  }

  @override
  void deactivate() {
    _mtaStream.cancel();
    super.deactivate();
  }

  void _streamListener() {
    _mtaStream = db.child('mta_stream').onValue.listen(
      (element) {
        var data = Map<String, dynamic>.from(
            element.snapshot.value as Map<dynamic, dynamic>);

        for (var item in data.entries) {
          String tId = item.key;
          var tData = item.value;

          if (allTrains.containsKey(tId)) {
            allTrains[tId]!.nextSt = tData['next_st'];
            allTrains[tId]!.status = tData['status'];
            allTrains[tId]!.delayed = tData['isDelay'];
          } else {
            Train newTrain = Train(
              tId,
              tData['direction'],
              tData['line'],
              tData['headsign'],
              tData['next_st'],
              tData['status'],
              tData['isDelay'],
            );

            allTrains[tId] = newTrain;
          }
          currMarkers = <Marker>{};
          for (var currTrain in allTrains.values) {
            var icon = trainIcon;
            double rotVal = 0;
            if (currTrain.incidentReports.isNotEmpty) {
              icon = incidentIcon;
            } else if (currTrain.delayed) {
              icon = delayIcon;
            } else if (currTrain.direction == "S") {
              rotVal = 180;
            }
            if (allStations.containsKey(currTrain.nextSt)) {
              LatLng currPos = allStations[currTrain.nextSt]!.pos;
              currMarkers.add(currTrain.getMarker(currPos, icon, rotVal));
            }
          }
        }
        setState(() {
          currMarkers;
        });
      },
    );
  }

  Future<void> loadStations() async {
    trainIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(15, 15)), 'asset/icons/train_up.png');
    delayIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(15, 15)), 'asset/icons/train_delay.png');
    incidentIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(15, 15)), 'asset/icons/train_alert.png');

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
