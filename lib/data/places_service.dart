// lib/core/services/places_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quadraclub_app/presentation/home/data/models/location_result.dart';

class PlacePrediction {
  final String description;
  final String placeId;

  PlacePrediction({required this.description, required this.placeId});
}

class PlacesService {
  // TODO: move this to a secure config / --dart-define instead of hardcoding.
  static const String _apiKey = 'AIzaSyCGmdcjkqkZLhd3uUvk5Fg89FNogySuNw8';

  // static const String _apiKey = 'AIzaSyCS7mGc0sTYoL_E5YBnUFAR2FwuZon7FzQ';

  static Future<List<PlacePrediction>> autocomplete(String input) async {
    if (input.trim().isEmpty) return [];

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {'input': input, 'types': '(cities)', 'key': _apiKey},
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body);
    if (data['status'] != 'OK') return [];

    final predictions = data['predictions'] as List;
    return predictions
        .map(
          (p) => PlacePrediction(
            description: p['description'] as String,
            placeId: p['place_id'] as String,
          ),
        )
        .toList();
  }

  static Future<LocationResult?> getPlaceDetails(String placeId) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/details/json',
      {
        'place_id': placeId,
        'fields': 'formatted_address,geometry',
        'key': _apiKey,
      },
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);
    if (data['status'] != 'OK') return null;

    final result = data['result'];
    final location = result['geometry']['location'];

    return LocationResult(
      address: result['formatted_address'] as String,
      latitude: (location['lat'] as num).toDouble(),
      longitude: (location['lng'] as num).toDouble(),
    );
  }

  static Future<String?> reverseGeocode(double lat, double lng) async {
    final uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json', {
      'latlng': '$lat,$lng',
      'result_type': 'locality|administrative_area_level_2',
      'key': _apiKey,
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);
    if (data['status'] != 'OK') return null;

    final results = data['results'] as List;
    if (results.isEmpty) return null;

    // Prefer the "locality" (city) component; fall back to formatted_address.
    final addressComponents = results.first['address_components'] as List;
    final cityComponent = addressComponents.firstWhere(
      (c) => (c['types'] as List).contains('locality'),
      orElse: () => null,
    );

    if (cityComponent != null) {
      final countryComponent = addressComponents.firstWhere(
        (c) => (c['types'] as List).contains('country'),
        orElse: () => null,
      );
      final city = cityComponent['long_name'];
      final country = countryComponent?['long_name'];
      return country != null ? '$city, $country' : city;
    }

    return results.first['formatted_address'] as String?;
  }
}
