import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  Place({
    required this.title,
    required this.image,
    required this.placeLocation,
    id,
  }) : id = id ?? uuid.v4();
  final String id;
  final String title;
  final File image;
  final PlaceLocation placeLocation;
}

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation(
      {required this.latitude, required this.longitude, required this.address});
}
