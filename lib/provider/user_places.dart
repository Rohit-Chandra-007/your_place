import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;
import 'package:your_place/models/place.dart';

Future<Database> _getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      db.execute(
          "CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAl, address TEXT)");
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadDataBase() async {
    final db = await _getDataBase();
    final response = await db.query('user_places');

    final places=response.map(
      (row) => Place(
        id: row['id'] as String,
        title: row['title'] as String,
        image: File(row['image'] as String),
        placeLocation: PlaceLocation(
          latitude: row['lat'] as double,
          longitude: row['lng'] as double,
          address: row['address'] as String,
        ),
      ),
    ).toList();
    state=places;
  }

  void addPlace(Place newPlace) async {
    final db = await _getDataBase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.placeLocation.latitude,
      'lng': newPlace.placeLocation.longitude,
      'address': newPlace.placeLocation.address
    });

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
