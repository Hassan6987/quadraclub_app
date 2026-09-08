import 'package:parsing_util/parsing_util.dart';

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

  static SportType fromString(String value) {
    switch (value.trim().toLowerCase()) {
      case 'padel':
        return SportType.pedal;
      case 'tennis':
        return SportType.tennis;
      case 'beach_tennis':
      case 'beach tennis':
        return SportType.beachTennis;
      case 'pickleball':
        return SportType.pickleball;
      default:
        throw ArgumentError('Invalid SportType: $value');
    }
  }
}

extension ClassFormatExtension on ClassFormat {
  String get label {
    switch (this) {
      case ClassFormat.group:
        return 'Group';
      case ClassFormat.individual:
        return 'Individual';
    }
  }

  static ClassFormat fromString(String value) {
    switch (value.trim().toLowerCase()) {
      case 'group':
        return ClassFormat.group;
      case 'individual':
        return ClassFormat.individual;
      default:
        throw ArgumentError('Invalid ClassFormat: $value');
    }
  }
}

extension ClassStatusExtension on ClassStatus {
  String get label {
    switch (this) {
      case ClassStatus.available:
        return 'Available';
      case ClassStatus.full:
        return 'Full';
      case ClassStatus.slotsLeft:
        return 'Slots Left';
    }
  }

  static ClassStatus fromString(String value) {
    final normalizedValue = value.trim().toLowerCase();

    if (normalizedValue == 'available') {
      return ClassStatus.available;
    }

    if (normalizedValue == 'full') {
      return ClassStatus.full;
    }

    if (normalizedValue.endsWith('slots left')) {
      return ClassStatus.slotsLeft;
    }

    throw ArgumentError('Invalid ClassStatus: $value');
  }
}

class Class {
  Class({
    required this.id,
    required this.className,
    required this.sportName,
    required this.level,
    required this.format,
    required this.price,
    required this.convenienceFee,
    required this.totalPrice,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.registrationDeadline,
    required this.coachName,
    required this.coachPhoto,
    required this.coachRating,
    required this.maxStudents,
    required this.currentParticipants,
    required this.participants,
    required this.slotsLeft,
    required this.isFull,
    required this.statusLabel,
    required this.court,
    required this.locationName,
    required this.distanceKm,
    required this.timeOfDay,
  });

  final String? id;
  final String className;
  final String? sportName;
  final String? level;
  final String? format;
  final int? price;
  final int? convenienceFee;
  final int? totalPrice;
  final DateTime? date;
  final String? startTime;
  final String? endTime;
  final DateTime? registrationDeadline;
  final String coachName;
  final String? coachPhoto;
  final String? coachRating;
  final int? maxStudents;
  final int? currentParticipants;
  final List<Participant> participants;
  final int? slotsLeft;
  final bool? isFull;
  final String? statusLabel;
  final CourtDetails? court;
  final String? locationName;
  final dynamic distanceKm;
  final String? timeOfDay;

  Class copyWith({
    String? id,
    String? className,
    String? sportName,
    String? level,
    String? format,
    int? price,
    int? convenienceFee,
    int? totalPrice,
    DateTime? date,
    String? startTime,
    String? endTime,
    DateTime? registrationDeadline,
    String? coachName,
    String? coachPhoto,
    String? coachRating,
    int? maxStudents,
    int? currentParticipants,
    List<Participant>? participants,
    int? slotsLeft,
    bool? isFull,
    String? statusLabel,
    CourtDetails? court,
    String? locationName,
    dynamic distanceKm,
    String? timeOfDay,
  }) {
    return Class(
      id: id ?? this.id,
      className: className ?? this.className,
      sportName: sportName ?? this.sportName,
      level: level ?? this.level,
      format: format ?? this.format,
      price: price ?? this.price,
      convenienceFee: convenienceFee ?? this.convenienceFee,
      totalPrice: totalPrice ?? this.totalPrice,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      registrationDeadline: registrationDeadline ?? this.registrationDeadline,
      coachName: coachName ?? this.coachName,
      coachPhoto: coachPhoto ?? this.coachPhoto,
      coachRating: coachRating ?? this.coachRating,
      maxStudents: maxStudents ?? this.maxStudents,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      participants: participants ?? this.participants,
      slotsLeft: slotsLeft ?? this.slotsLeft,
      isFull: isFull ?? this.isFull,
      statusLabel: statusLabel ?? this.statusLabel,
      court: court ?? this.court,
      locationName: locationName ?? this.locationName,
      distanceKm: distanceKm ?? this.distanceKm,
      timeOfDay: timeOfDay ?? this.timeOfDay,
    );
  }

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json["_id"],
      className: json["className"] ?? '',
      sportName: json["sportName"],
      level: json["level"],
      format: json["format"],
      price: json["price"],
      convenienceFee: json["convenienceFee"],
      totalPrice: json["totalPrice"],
      date: ParsingUtil.toSafeDateTime(json["date"] ?? ""),
      startTime: json["startTime"],
      endTime: json["endTime"],
      registrationDeadline: ParsingUtil.toSafeDateTime(
        json["registrationDeadline"] ?? "",
      ),
      coachName: json["coachName"] ?? '',
      coachPhoto: json["coachPhoto"],
      coachRating: json["coachRating"],
      maxStudents: json["maxStudents"],
      currentParticipants: json["currentParticipants"],
      participants: json["participants"] == null
          ? []
          : List<Participant>.from(
              json["participants"]!.map((x) => Participant.fromJson(x)),
            ),
      slotsLeft: json["slotsLeft"],
      isFull: json["isFull"],
      statusLabel: json["statusLabel"],
      court: json["court"] == null
          ? null
          : CourtDetails.fromJson(json["court"]),
      locationName: json["locationName"],
      distanceKm: json["distanceKm"],
      timeOfDay: json["timeOfDay"],
    );
  }
}

class CourtDetails {
  CourtDetails({
    required this.id,
    required this.courtName,
    required this.location,
    required this.coordinates,
  });

  final String? id;
  final String? courtName;
  final String? location;
  final Coordinates? coordinates;

  factory CourtDetails.fromJson(Map<String, dynamic> json) {
    return CourtDetails(
      id: json["_id"],
      courtName: json["courtName"],
      location: json["location"],
      coordinates: json["coordinates"] == null
          ? null
          : Coordinates.fromJson(json["coordinates"]),
    );
  }
}

class Coordinates {
  Coordinates({required this.latitude, required this.longitude});

  final int? latitude;
  final int? longitude;

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }
}

class Participant {
  Participant({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profilePhoto,
  });

  final String? id;
  final String? fullName;
  final String? email;
  final String? profilePhoto;

  Participant copyWith({
    String? id,
    String? fullName,
    String? email,
    String? profilePhoto,
  }) {
    return Participant(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json["_id"],
      fullName: json["fullName"],
      email: json["email"],
      profilePhoto: json["profilePhoto"],
    );
  }
}
