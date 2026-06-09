import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressMapPicker extends StatefulWidget {
  const AddressMapPicker({super.key, this.onLocationSelected, this.initialPosition});

  final ValueChanged<LatLng>? onLocationSelected;
  final LatLng? initialPosition;

  @override
  State<AddressMapPicker> createState() => _AddressMapPickerState();
}

class _AddressMapPickerState extends State<AddressMapPicker> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late LatLng _selectedPosition;

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.initialPosition ??
        const LatLng(30.08525452318584, 31.282610287469513);
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

    if (kDebugMode) {
      debugPrint("Lat: ${position.latitude}, Lng: ${position.longitude}");
    }

    widget.onLocationSelected?.call(position);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _selectedPosition,
        zoom: 14.5,
      ),
      markers: _markers,
      onTap: _setMarker,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}