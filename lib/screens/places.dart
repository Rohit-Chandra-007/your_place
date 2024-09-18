import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_place/provider/user_places.dart';
import 'package:your_place/screens/add_place.dart';
import 'package:your_place/widgets/places_list.dart';

class PlacesListScreen extends ConsumerStatefulWidget {
  const PlacesListScreen({super.key});

  @override
  ConsumerState<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends ConsumerState<PlacesListScreen> {
  late Future<void> _placesResult;

  @override
  void initState() {
    _placesResult = ref.read(userPlacesProvider.notifier).loadDataBase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Place'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddPlaceScreen(),
                ));
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: _placesResult,
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting ? const Center(child: CircularProgressIndicator()):PlacesList(places: userPlaces,)
         
      )
    );
  }
}
