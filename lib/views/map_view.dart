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

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final currUser = AuthService.firebase().currentUser;

  // gmaps
  late String _gmapStyle;
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
    rootBundle.loadString('asset/map_design.json').then(
      (string) {
        _gmapStyle = string;
      },
    );
    // set markers, polyline, circles
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        myLocationButtonEnabled: false,
        initialCameraPosition: _manhattan,
        // markers: _markers,
        // polylines: _polylines,
        // circles: _circles,
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
  }
}

