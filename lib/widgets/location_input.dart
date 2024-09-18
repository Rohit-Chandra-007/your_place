import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:your_place/models/place.dart';
import 'package:your_place/screens/map.dart';

const googleMapApiKey = '';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectedLocation});
  final void Function(PlaceLocation location) onSelectedLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? pickedlocation;
  bool isGettingLocation = false;

  void savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleMapApiKey');

    final respone = await http.get(url);

    final responseData = json.decode(respone.body);
    var address = responseData['results'][0]['formatted_address'];

    setState(() {
      pickedlocation = PlaceLocation(
          address: address, latitude: latitude, longitude: longitude);
      isGettingLocation = false;
    });

    if (pickedlocation == null) {
      return;
    }

    widget.onSelectedLocation(pickedlocation!);
  }

  String get locationImage {
    if (pickedlocation == null) {
      return '';
    }
    final lat = pickedlocation!.latitude;
    final lng = pickedlocation!.longitude;
    debugPrint("$lat!");
    debugPrint("$lng");
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=400x400&markers=color:red%7Clabel:S%7C$lat,$lng&key=$googleMapApiKey';
  }

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isGettingLocation = true;
    });

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final long = locationData.longitude;

    if (lat == null && long == null) {
      return;
    }

    savePlace(lat!, long!);
  }

  void onSelectedMap() async {
    final pickLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
      builder: (context) => const MapScreen(),
    ));
    if (pickLocation == null) {
      return;
    }
    savePlace(pickLocation.latitude, pickLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No Location Chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );

    if (isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    if (pickedlocation != null) {
      previewContent = Image.network(
        locationImage,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withOpacity(0.2),
              ),
            ),
            height: 300,
            width: double.infinity,
            alignment: Alignment.center,
            child: previewContent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: getCurrentLocation,
              label: const Text(
                'Get Current Location',
              ),
              icon: const Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: onSelectedMap,
              label: const Text(
                'Select on Map',
              ),
              icon: const Icon(Icons.location_on),
            ),
          ],
        )
      ],
    );
  }
}
