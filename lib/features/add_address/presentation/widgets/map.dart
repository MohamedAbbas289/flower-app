import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key, this.onLocationSelected});

  final ValueChanged<LatLng>? onLocationSelected;

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  LatLng _selectedPosition = const LatLng(
    30.08525452318584,
    31.282610287469513,
  );

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setMarker(_selectedPosition);
  }

  void _setMarker(LatLng position) {
    setState(() {
      _selectedPosition = position;

      _markers = {
        Marker(
          markerId: const MarkerId('selected'),
          position: position,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        ),
      };
    });

    log("Lat: ${position.latitude}");
    log("Lng: ${position.longitude}");
    widget.onLocationSelected?.call(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _selectedPosition,
          zoom: 14.5,
        ),

        markers: _markers,

        onTap: (LatLng position) {
          _setMarker(position);
        },

        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
