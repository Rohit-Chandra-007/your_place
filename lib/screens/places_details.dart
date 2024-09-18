import 'package:flutter/material.dart';
import 'package:your_place/models/place.dart';
import 'package:your_place/screens/map.dart';
import 'package:your_place/widgets/location_input.dart';

class PlacesDetailsScreen extends StatelessWidget {
  const PlacesDetailsScreen({super.key, required this.place});
  final Place place;

  String get locationImage {
    final lat = place.placeLocation.latitude;
    final lng = place.placeLocation.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=400x400&markers=color:red%7Clabel:S%7C$lat,$lng&key=$googleMapApiKey';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(children: [
        Image.file(
          place.image,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MapScreen(
                        location: place.placeLocation,
                        isSelecting: false,
                      ),
                    ));
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(locationImage),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black54],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  child: Text(
                    place.placeLocation.address,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                )
              ],
            ))
      ]),
    );
  }
}
