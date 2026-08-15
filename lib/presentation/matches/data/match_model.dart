import 'package:quadraclub_app/presentation/classes/data/class_model.dart';

enum MatchFormat { singles, doubles }

enum MatchStatus { available, full, pending }

enum CourtStatus { confirmed, pending }

extension MatchFormatExtension on MatchFormat {
  String get label {
    switch (this) {
      case MatchFormat.singles:
        return 'Singles';
      case MatchFormat.doubles:
        return 'Doubles';
    }
  }
}

class PlayerModel {
  final String name;
  final String skillLevel;
  final String? avatarAsset;
  final bool isAvailable;
  final String? position; // 'Left' or 'Right' for doubles

  const PlayerModel({
    required this.name,
    required this.skillLevel,
    this.avatarAsset,
    this.isAvailable = false,
    this.position,
  });
}

class MatchModel {
  final String id;
  final SportType sport;
  final String category;
  final MatchFormat format;
  final DateTime date;
  final String timeStart;
  final String timeEnd;
  final String location;
  final String city;
  final double distanceKm;
  final CourtStatus courtStatus;
  final int totalSlots;
  final int filledSlots;
  final String description;
  final List<PlayerModel> players;
  final String? imageAsset;

  const MatchModel({
    required this.id,
    required this.sport,
    required this.category,
    required this.format,
    required this.date,
    required this.timeStart,
    required this.timeEnd,
    required this.location,
    required this.city,
    required this.distanceKm,
    required this.courtStatus,
    required this.totalSlots,
    required this.filledSlots,
    required this.description,
    required this.players,
    this.imageAsset,
  });

  MatchStatus get status {
    if (filledSlots >= totalSlots) return MatchStatus.full;
    return MatchStatus.available;
  }

  int get slotsLeft => totalSlots - filledSlots;
}
