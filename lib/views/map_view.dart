import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:safe_line/routes.dart';
import 'package:safe_line/models/station.dart';
import 'package:safe_line/models/train.dart';
import 'package:safe_line/train_controller.dart';
import 'package:safe_line/constants.dart';
import 'package:safe_line/customWidgets/report_widget.dart';
import 'dart:developer' as tools;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // mta station data
  Map<String, Marker> currMarkers = <String, Marker>{};
  final Map<String, Station> allStations = <String, Station>{};
  final Set<Circle> stationMarkers = <Circle>{};

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

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('asset/processed/map_design.json').then(
      (string) {
        _gmapStyle = string;
      },
    );
  }

  Future<void> loadStations() async {
    trainIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(5, 5)), 'asset/icons/train_up.png');
    delayIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(15, 15)),
        'asset/icons/train_delay.png');
    incidentIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(5, 5)),
        'asset/icons/train_alert.png');

    var string =
        await rootBundle.loadString('asset/processed/stations_processed.csv');
    var dataList = const CsvToListConverter().convert(string, eol: "\n");
    for (var data in dataList) {
      if (data[0] != "id") {
        // add station data
        String stationId = data[0].toString();
        String stationName = data[1];
        if (allStations.containsKey(stationName)) {
          continue;
        } else {
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadStations(),
      builder: (context, _) {
        return Scaffold(
          body: StreamBuilder(
            stream: TrainController().getTrainMarkers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularLoader;
              } else {
                final currTrains = snapshot.data as List<Train>;
                for (var train in currTrains) {
                  if (allStations.containsKey(train.nextSt)) {
                    LatLng currPos = allStations[train.nextSt]!.pos;
                    String currName = allStations[train.nextSt]!.name;
                    BitmapDescriptor icon = trainIcon;
                    if (train.incidentReports.isNotEmpty) {
                      icon = incidentIcon;
                    } else if (train.delayed) {
                      icon = delayIcon;
                    }

                    double rotVal = 0;
                    if (train.direction == "S") {
                      rotVal = 180;
                    }

                    Marker newMarker = Marker(
                        markerId: MarkerId(train.id),
                        position: currPos,
                        onTap: () {
                          reportModelView(context, train, currName);
                        },
                        icon: icon,
                        rotation: rotVal);
                    currMarkers[train.id] = newMarker;
                  }
                }
                return GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    mapController = controller;
                    mapController.setMapStyle(_gmapStyle);
                  },
                  initialCameraPosition: _manhattan,
                  myLocationButtonEnabled: false,
                  circles: stationMarkers,
                  markers: currMarkers.values.toSet(),
                );
              }
            },
          ),

          // menu control
          floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 15, 0),
            child: SizedBox(
              width: 70,
              height: 300,
              child: Column(
                children: [
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
