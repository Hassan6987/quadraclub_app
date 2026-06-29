enum SportType { pedal, tennis, beachTennis, pickleball }

enum ClassFormat { group, individual }

enum ClassStatus { available, full, slotsLeft }

extension SportTypeExtension on SportType {
  String get label {
    switch (this) {
      case SportType.pedal:
        return 'Pedal';
      case SportType.tennis:
        return 'Tennis';
      case SportType.beachTennis:
        return 'Beach Tennis';
      case SportType.pickleball:
        return 'Pickleball';
    }
  }
}

class CoachModel {
  final String name;
  final String avatarAsset; // e.g. 'assets/images/coach_thiago.png'
  final int category;

  const CoachModel({
    required this.name,
    required this.avatarAsset,
    required this.category,
  });
}

class ParticipantModel {
  final String avatarAsset;

  const ParticipantModel({required this.avatarAsset});
}

class ClassModel {
  final String id;
  final String title;
  final SportType sport;
  final String categoryRange; // e.g. 'B - D'
  final ClassFormat format;
  final DateTime date;
  final String timeStart; // e.g. '08:00'
  final String timeEnd; // e.g. '09:30'
  final String location;
  final double distanceKm;
  final CoachModel coach;
  final double price;
  final int totalSlots;
  final int filledSlots;
  final DateTime registrationDeadline;
  final String description;
  final List<ParticipantModel> participants;

  const ClassModel({
    required this.id,
    required this.title,
    required this.sport,
    required this.categoryRange,
    required this.format,
    required this.date,
    required this.timeStart,
    required this.timeEnd,
    required this.location,
    required this.distanceKm,
    required this.coach,
    required this.price,
    required this.totalSlots,
    required this.filledSlots,
    required this.registrationDeadline,
    required this.description,
    required this.participants,
  });

  ClassStatus get status {
    if (filledSlots >= totalSlots) return ClassStatus.full;
    if (filledSlots >= totalSlots - 2) return ClassStatus.slotsLeft;
    return ClassStatus.available;
  }

  int get slotsLeft => totalSlots - filledSlots;
}