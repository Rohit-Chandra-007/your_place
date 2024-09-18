import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as pathprovider;
import 'package:path/path.dart' as path;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_place/models/place.dart';
import 'package:your_place/provider/user_places.dart';
import 'package:your_place/widgets/image_input.dart';
import 'package:your_place/widgets/location_input.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleTextController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() async {
    final enteredTitle = _titleTextController.text;
    if (enteredTitle == '' ||
        enteredTitle.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      return;
    }

    final appDir = await pathprovider.getApplicationDocumentsDirectory();
    final fileName = path.basename(_selectedImage!.path);
    final copiedImage = await _selectedImage!.copy('${appDir.path}/$fileName');

    ref.read(userPlacesProvider.notifier).addPlace(Place(
        title: enteredTitle,
        image: copiedImage,
        placeLocation: _selectedLocation!));

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Title', border: OutlineInputBorder()),
              controller: _titleTextController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(
              height: 16,
            ),
            ImageInput(
              onPickedImage: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            LocationInput(
              onSelectedLocation: (location) {
                _selectedLocation = location;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              label: const Text('Add Place'),
              icon: const Icon(Icons.add),
              onPressed: _savePlace,
            )
          ],
        ),
      ),
    );
  }
}
