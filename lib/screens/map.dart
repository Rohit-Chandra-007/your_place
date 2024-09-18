import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:your_place/models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key,
      this.location = const PlaceLocation(
        latitude: 28.6204599,
        longitude: 77.2800257,
        address: '',
      ),
      this.isSelecting = true});
  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _latLng;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick Your Location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop<LatLng>(_latLng);
              },
              icon: const Icon(Icons.save),
            )
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting
            ? null
            : (location) {
                setState(() {
                  _latLng = location;
                });
              },
        initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.location.latitude,
              widget.location.longitude,
            ),
            zoom: 16),
        markers: (_latLng == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _latLng ??
                      LatLng(
                        widget.location.latitude,
                        widget.location.longitude,
                      ),
                )
              },
      ),
    );
  }
}
