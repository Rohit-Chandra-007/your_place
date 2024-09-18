import 'package:flutter/material.dart';
import 'package:your_place/models/place.dart';
import 'package:your_place/screens/places_details.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});
  final List<Place> places;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'No Places added Yet',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      );
    }
    return ListView.builder(
      itemCount: places.length,
      padding: const EdgeInsets.only(top: 10),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      PlacesDetailsScreen(place: places[index]),
                ),
              );
            },
            child: Card(
              //clipBehavior: Clip.hardEdge,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: FileImage(places[index].image),
                  ),
                  title: Text(
                    places[index].title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  subtitle: Text(
                    places[index].placeLocation.address,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
