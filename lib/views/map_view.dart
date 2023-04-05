import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'dart:typed_data';
import 'dart:async';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:safe_line/routes.dart';
import 'package:safe_line/models/station.dart';
import 'package:safe_line/models/train.dart';
import 'package:safe_line/models/report.dart';
import 'package:safe_line/controllers/train_controller.dart';
import 'package:safe_line/constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:ui' as ui;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // google maps
  late String _gmapStyle;
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const CameraPosition _manhattan = CameraPosition(
    target: LatLng(40.759296, -73.985573),
    zoom: 13,
  );

  TrainController tc = TrainController();
  Map<String, Marker> trainMarkers = <String, Marker>{};

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('asset/processed/map_design.json').then(
      (string) {
        _gmapStyle = string;
      },
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  // load assets
  Future<void> loadStations() async {
    tc.upIcon = await getBytesFromAsset('asset/icons/train_up.png', 75);
    tc.downIcon = await getBytesFromAsset('asset/icons/train_down.png', 75);
    tc.movingUpIcon = await getBytesFromAsset('asset/icons/moving_up.png', 75);
    tc.movingDownIcon =
        await getBytesFromAsset('asset/icons/moving_down.png', 75);
    tc.delayIcon = await getBytesFromAsset('asset/icons/train_delay.png', 75);
    tc.incidentIcon =
        await getBytesFromAsset('asset/icons/train_alert.png', 85);

    var string =
        await rootBundle.loadString('asset/processed/stations_processed.csv');
    var dataList = const CsvToListConverter().convert(string, eol: "\n");
    for (var data in dataList) {
      if (data[0] != "id") {
        // add station data
        String stationId = data[0].toString();
        String stationName = data[1];
        if (tc.allStations.containsKey(stationName)) {
          continue;
        } else {
          Station newStation = Station(
              id: stationId, name: data[1], pos: LatLng(data[2], data[3]));

          // allStations.add(newStation);
          tc.allStations[stationId] = newStation;

          // add station marker
          int tempIdx = stationId.length - 1;
          if (stationId[tempIdx] != "N" || stationId[tempIdx] != "S") {
            tc.stationMarkers.add(newStation.getCircle());
          }
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
            stream: tc.trainDataStream(context),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return circularLoader;
              } else {
                final currTrains = snapshot.data as Set<Train>;
                for (Train train in currTrains) {
                  addMarker(train);
                }
                return Animarker(
                  shouldAnimateCamera: false,
                  curve: Curves.ease,
                  rippleRadius: 0.0,
                  zoom: 0.0,
                  useRotation: false,
                  duration: const Duration(seconds: 25),
                  mapId: _controller.future.then<int>((value) => value.mapId),
                  markers: trainMarkers.values.toSet(),
                  child: GoogleMap(
                    onMapCreated: (gController) {
                      _controller.complete(gController);
                      mapController = gController;
                      mapController.setMapStyle(_gmapStyle);
                    },
                    initialCameraPosition: _manhattan,
                    myLocationButtonEnabled: false,
                    circles: tc.stationMarkers,
                  ),
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

  void addMarker(Train currTrain) {
    Uint8List icon = tc.upIcon;
    if (currTrain.direction == "S") {
      icon = tc.downIcon;
    } else if (currTrain.incidentReports.isNotEmpty) {
      icon = tc.incidentIcon;
    } else if (currTrain.delayed) {
      icon = tc.delayIcon;
    }
    if (currTrain.incidentReports.isNotEmpty) {
      icon = tc.incidentIcon;
    } else if (currTrain.delayed) {
      icon = tc.delayIcon;
    }

    var newMarker = Marker(
      markerId: MarkerId(currTrain.id),
      position: currTrain.currSt,
      onTap: () {
        reportModelView(context, currTrain);
      },
      icon: BitmapDescriptor.fromBytes(icon),
    );
    trainMarkers[currTrain.id] = newMarker;
  }

  void updateMarker(Train currTrain) {
    if (trainMarkers.containsKey(currTrain.id)) {
      trainMarkers.remove(currTrain.id);
    }

    Uint8List icon = tc.upIcon;
    if (currTrain.direction == "S") {
      icon = tc.downIcon;
    } else if (currTrain.incidentReports.isNotEmpty) {
      icon = tc.incidentIcon;
    } else if (currTrain.delayed) {
      icon = tc.delayIcon;
    }
    var updatedMarker = Marker(
      markerId: MarkerId(currTrain.id),
      position: currTrain.currSt,
      onTap: () {
        reportModelView(context, currTrain);
      },
      icon: BitmapDescriptor.fromBytes(icon),
    );
    trainMarkers[currTrain.id] = updatedMarker;

    setState(() {
      trainMarkers;
    });
  }

  // train information view (modal screen)
  void reportModelView(context, Train currTrain) {
    int idx = subwayLines.indexOf(currTrain.line);
    MaterialColor subbgColor = subwayIconColor[idx];
    String dir = "Uptown";
    if (currTrain.direction == "S") {
      dir = "Downtown";
    }
    final TextEditingController descriptionController = TextEditingController();

    showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: deviceHeight(context) * 0.65,
          width: deviceWidth(context),
          decoration: const BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              // heading
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "St: ${currTrain.stName}",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          currTrain.headsign,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "ID: ${currTrain.id}",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        subwayLineIcon(currTrain.line, subbgColor),
                        Text(
                          dir,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              // current reports
              const SizedBox(height: 30),
              incidentSummary(currTrain),

              // textbox
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: SizedBox(
                  height: 60,
                  child: TextField(
                    controller: descriptionController,
                    maxLines: null,
                    expands: true,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Please describe the incident",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // submit button
              ElevatedButton(
                onPressed: () async {
                  Report newReport =
                      Report(currTrain.id, descriptionController.text);
                  await newReport.addReport();
                  currTrain.incidentReports.add(newReport);
                  updateMarker(currTrain);

                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Report Saved!"),
                        backgroundColor: accentColor,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 94, 78, 228),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                ),
                child: const Text("Submit Report"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget incidentSummary(Train selTrain) {
    int reportCnt = selTrain.incidentReports.length;
    if (reportCnt == 0) {
      return Container(
        width: deviceWidth(context) * 0.95,
        height: deviceHeight(context) * 0.25,
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            "No reports recorded.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25.0,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: deviceWidth(context) * 0.95,
        height: deviceHeight(context) * 0.25,
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: PageView.builder(
          itemCount: reportCnt,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.transparent,
              elevation: 0,
              child: incidentCard(selTrain.incidentReports[index]),
            );
          },
        ),
      );
    }
  }

  Widget incidentCard(Report currReport) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Time Posted: ${getTime(currReport.postTime)}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            Row(
              children: [
                Wrap(
                  children: [
                    Text(
                      "Incident Description:\n${currReport.description}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget subwayLineIcon(String line, MaterialColor bgColor) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: 50,
        height: 50,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
          child: Text(
            line,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30.0,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
