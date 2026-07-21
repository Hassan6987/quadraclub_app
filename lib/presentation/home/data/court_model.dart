import 'package:quadraclub_app/app_exports.dart';

class CourtModel {
  final String id;
  final String name;
  final String location; // e.g. "Santa Monica"
  final String city;     // e.g. "New York", "Los Angeles", "Chicago", "London"
  final double distanceMiles;
  final List<SportType> sports;
  final Map<SportType, List<String>> timeSlots; // Sport -> List of times (e.g. "10:00")
  final String imageUrl;
  final double latitude;
  final double longitude;

  const CourtModel({
    required this.id,
    required this.name,
    required this.location,
    required this.city,
    required this.distanceMiles,
    required this.sports,
    required this.timeSlots,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });
}
