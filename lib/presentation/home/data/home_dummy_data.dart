import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/court_model.dart';

const List<CourtModel> dummyCourts = [
  CourtModel(
    id: 'crt_001',
    name: 'Riverside Sports Hub',
    location: 'Santa Monica',
    city: 'Los Angeles',
    distanceMiles: 2.5,
    sports: [SportType.pedal, SportType.tennis, SportType.beachTennis, SportType.pickleball],
    timeSlots: {
      SportType.pedal: ['10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00'],
      SportType.tennis: ['10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00'],
      SportType.beachTennis: ['11:00', '13:00', '15:00'],
      SportType.pickleball: ['09:00', '10:00', '14:00', '16:00'],
    },
    imageUrl: 'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=800&auto=format&fit=crop&q=80',
    latitude: 34.0194,
    longitude: -118.4912,
  ),
  CourtModel(
    id: 'crt_002',
    name: 'Greenwich Tennis Centre',
    location: 'Greenwich',
    city: 'London',
    distanceMiles: 1.2,
    sports: [SportType.tennis, SportType.pedal],
    timeSlots: {
      SportType.tennis: ['08:00', '09:00', '10:00', '14:00', '15:00', '18:00'],
      SportType.pedal: ['09:00', '12:00', '16:00', '17:00'],
    },
    imageUrl: 'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?w=800&auto=format&fit=crop&q=80',
    latitude: 51.4872,
    longitude: 0.0037,
  ),
  CourtModel(
    id: 'crt_003',
    name: 'West Side Tennis Club',
    location: 'Forest Hills',
    city: 'New York',
    distanceMiles: 5.4,
    sports: [SportType.tennis, SportType.pickleball, SportType.beachTennis],
    timeSlots: {
      SportType.tennis: ['07:00', '09:00', '11:00', '13:00', '15:00', '17:00'],
      SportType.pickleball: ['08:00', '10:00', '12:00', '14:00'],
      SportType.beachTennis: ['16:00', '17:00', '18:00'],
    },
    imageUrl: 'https://images.unsplash.com/photo-1538386393874-45d645365e23?w=800&auto=format&fit=crop&q=80',
    latitude: 40.7198,
    longitude: -73.8447,
  ),
  CourtModel(
    id: 'crt_004',
    name: 'Lincoln Park Fields',
    location: 'Lincoln Park',
    city: 'Chicago',
    distanceMiles: 3.1,
    sports: [SportType.pedal, SportType.tennis],
    timeSlots: {
      SportType.pedal: ['10:00', '11:00', '15:00', '16:00'],
      SportType.tennis: ['09:00', '12:00', '14:00', '17:00'],
    },
    imageUrl: 'https://images.unsplash.com/photo-1610969524113-bae461751d8b?w=800&auto=format&fit=crop&q=80',
    latitude: 41.9214,
    longitude: -87.6323,
  ),
  CourtModel(
    id: 'crt_005',
    name: 'Hyde Park Courts',
    location: 'Hyde Park',
    city: 'London',
    distanceMiles: 0.8,
    sports: [SportType.pedal, SportType.tennis, SportType.pickleball],
    timeSlots: {
      SportType.pedal: ['08:00', '10:00', '12:00', '14:00', '16:00'],
      SportType.tennis: ['09:00', '11:00', '13:00', '15:00', '17:00'],
      SportType.pickleball: ['08:00', '09:00', '14:00', '15:00'],
    },
    imageUrl: 'https://images.unsplash.com/photo-1542144552-c677270f9011?w=800&auto=format&fit=crop&q=80',
    latitude: 51.5074,
    longitude: -0.1657,
  ),
  CourtModel(
    id: 'crt_006',
    name: 'Santa Monica Beach Courts',
    location: 'Santa Monica Beach',
    city: 'Los Angeles',
    distanceMiles: 4.2,
    sports: [SportType.beachTennis, SportType.pickleball],
    timeSlots: {
      SportType.beachTennis: ['09:00', '10:00', '11:00', '14:00', '15:00', '16:00'],
      SportType.pickleball: ['08:00', '12:00', '13:00', '17:00'],
    },
    imageUrl: 'https://images.unsplash.com/photo-1505666287802-931dc83948e9?w=800&auto=format&fit=crop&q=80',
    latitude: 34.0112,
    longitude: -118.4984,
  ),
  CourtModel(
    id: 'crt_007',
    name: 'Brooklyn Bridge Park Sports',
    location: 'Brooklyn',
    city: 'New York',
    distanceMiles: 8.5,
    sports: [SportType.pedal, SportType.tennis, SportType.pickleball, SportType.beachTennis],
    timeSlots: {
      SportType.pedal: ['07:00', '08:00', '12:00', '15:00'],
      SportType.tennis: ['10:00', '11:00', '14:00', '16:00'],
      SportType.pickleball: ['09:00', '13:00', '17:00'],
      SportType.beachTennis: ['11:00', '15:00'],
    },
    imageUrl: 'https://images.unsplash.com/photo-1599447421416-3414500d18a5?w=800&auto=format&fit=crop&q=80',
    latitude: 40.7003,
    longitude: -73.9961,
  ),
];

class CityFilterModel {
  final String cityName;
  final double distanceKm;

  const CityFilterModel({required this.cityName, required this.distanceKm});
}

const List<CityFilterModel> dummyCities = [
  CityFilterModel(cityName: 'New York', distanceKm: 0.0),
  CityFilterModel(cityName: 'Los Angeles', distanceKm: 10.0),
  CityFilterModel(cityName: 'Chicago', distanceKm: 15.0),
  CityFilterModel(cityName: 'London', distanceKm: 25.0),
];
