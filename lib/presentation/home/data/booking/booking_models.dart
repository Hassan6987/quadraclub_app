// lib/presentation/booking/data/booking_models.dart
import 'package:quadraclub_app/presentation/home/data/court_model.dart';

enum MatchType { open, private }

enum BookingFormat { single, double_ }

enum BookingType { individual, match }

enum PaymentSplitOption { payAllReceiveLater, payAllNoSplit, payOnlyMyPart }

extension MatchTypeExtension on MatchType {
  String get label => this == MatchType.open ? 'Open' : 'Private';
  String get description => this == MatchType.open
      ? 'Any player can join'
      : 'Only invited player can join';
}

extension BookingFormatExtension on BookingFormat {
  String get label => this == BookingFormat.double_ ? 'Double' : 'Single';
}

extension PaymentSplitOptionExtension on PaymentSplitOption {
  String get title {
    switch (this) {
      case PaymentSplitOption.payAllReceiveLater:
        return 'Pay everything now and receive later';
      case PaymentSplitOption.payAllNoSplit:
        return 'Pay everything now without splitting later';
      case PaymentSplitOption.payOnlyMyPart:
        return 'Pay only my part now';
    }
  }

  String get description {
    switch (this) {
      case PaymentSplitOption.payAllReceiveLater:
        return 'Court is already booked now, and you receive other players parts automatically after the match.';
      case PaymentSplitOption.payAllNoSplit:
        return 'Invite players can join without paying anything.';
      case PaymentSplitOption.payOnlyMyPart:
        return 'Court is not booked yet. It will only be booked when everyone joins. Risk loosing booking';
    }
  }
}

class InvitablePlayerModel {
  final String id;
  final String name;
  final String avatarUrl;

  const InvitablePlayerModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });
}

const List<InvitablePlayerModel> dummyPlayers = [
  InvitablePlayerModel(id: 'p1', name: 'Alex Rivers', avatarUrl: 'htt://i.p'),
  InvitablePlayerModel(id: 'p2',
      name: 'Pedro Costa',
      avatarUrl: 'https://i.pravatar.cc/150?img=13'),
  InvitablePlayerModel(
      id: 'p3', name: 'John', avatarUrl: 'https://i.pravatar.cc/150?img=14'),
  InvitablePlayerModel(id: 'p4',
      name: 'Maria Silva',
      avatarUrl: 'https://i.pravatar.cc/150?img=15'),
  InvitablePlayerModel(id: 'p5',
      name: 'Diego Fernandez',
      avatarUrl: 'https://i.pravatar.cc/150?img=16'),
  InvitablePlayerModel(id: 'p6',
      name: 'Laura Bennett',
      avatarUrl: 'https://i.pravatar.cc/150?img=17'),
];

/// TODO: replace with a real `price` field on CourtModel.
extension CourtPriceExtension on CourtModel {
  double get demoPricePerBooking => 120.0;
}

/// TODO: replace with a real `amenities` field on CourtModel.
extension CourtAmenitiesExtension on CourtModel {
  List<String> get demoAmenities =>
      const ['Shower', 'Parking', 'Indoor Court', 'Outdoor Court'];
}

String formatPrice(double amount) => '\$${amount.toStringAsFixed(2)}';

/// Adds a duration to a "HH:mm" start time string, returning "HH:mm".
String addDurationToTime(String start, Duration duration) {
  final parts = start.split(':');
  final startMinutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
  final endMinutes = startMinutes + duration.inMinutes;
  final hour = (endMinutes ~/ 60) % 24;
  final minute = endMinutes % 60;
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}