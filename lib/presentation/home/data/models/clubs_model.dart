import 'package:parsing_util/parsing_util.dart';

class Club {
  Club({
    required this.id,
    required this.name,
    required this.description,
    required this.photo,
    required this.city,
    required this.state,
    required this.coordinates,
    required this.sports,
    required this.courts,
  });

  final String? id;
  final String? name;
  final String? description;
  final String? photo;
  final String? city;
  final String? state;
  final Coordinates? coordinates;
  final List<String> sports;
  final List<Court> courts;

  Club copyWith({
    String? id,
    String? name,
    String? description,
    String? photo,
    String? city,
    String? state,
    Coordinates? coordinates,
    List<String>? sports,
    List<Court>? courts,
  }) {
    return Club(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      photo: photo ?? this.photo,
      city: city ?? this.city,
      state: state ?? this.state,
      coordinates: coordinates ?? this.coordinates,
      sports: sports ?? this.sports,
      courts: courts ?? this.courts,
    );
  }

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      photo: json["photo"],
      city: json["city"],
      state: json["state"],
      coordinates: json["coordinates"] == null
          ? null
          : Coordinates.fromJson(json["coordinates"]),
      sports: json["sports"] == null
          ? []
          : List<String>.from(json["sports"]!.map((x) => x)),
      courts: json["courts"] == null
          ? []
          : List<Court>.from(json["courts"]!.map((x) => Court.fromJson(x))),
    );
  }
}

class Coordinates {
  Coordinates({required this.latitude, required this.longitude});

  final double? latitude;
  final double? longitude;

  Coordinates copyWith({double? latitude, double? longitude}) {
    return Coordinates(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      latitude: ParsingUtil.toSafeDouble(json["latitude"]),
      longitude: ParsingUtil.toSafeDouble(json["longitude"]),
    );
  }
}

class Court {
  Court({
    required this.id,
    required this.courtName,
    required this.location,
    required this.coordinates,
    required this.courtPhoto,
    required this.amenities,
    required this.sports,
    required this.weeklySlots,
  });

  final String? id;
  final String? courtName;
  final String? location;
  final Coordinates? coordinates;
  final String? courtPhoto;
  final List<dynamic> amenities;
  final List<Sport> sports;
  final Map<String, WeeklySlot> weeklySlots;

  Court copyWith({
    String? id,
    String? courtName,
    String? location,
    Coordinates? coordinates,
    String? courtPhoto,
    List<dynamic>? amenities,
    List<Sport>? sports,
    Map<String, WeeklySlot>? weeklySlots,
  }) {
    return Court(
      id: id ?? this.id,
      courtName: courtName ?? this.courtName,
      location: location ?? this.location,
      coordinates: coordinates ?? this.coordinates,
      courtPhoto: courtPhoto ?? this.courtPhoto,
      amenities: amenities ?? this.amenities,
      sports: sports ?? this.sports,
      weeklySlots: weeklySlots ?? this.weeklySlots,
    );
  }

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      id: json["id"],
      courtName: json["courtName"],
      location: json["location"],
      coordinates: json["coordinates"] == null
          ? null
          : Coordinates.fromJson(json["coordinates"]),
      courtPhoto: json["courtPhoto"],
      amenities: json["amenities"] == null
          ? []
          : List<dynamic>.from(json["amenities"]!.map((x) => x)),
      sports: json["sports"] == null
          ? []
          : List<Sport>.from(json["sports"]!.map((x) => Sport.fromJson(x))),
      weeklySlots: Map.from(
        json["weeklySlots"],
      ).map((k, v) => MapEntry<String, WeeklySlot>(k, WeeklySlot.fromJson(v))),
    );
  }
}

class Sport {
  Sport({
    required this.sportName,
    required this.hourlyRate,
    required this.openTime,
    required this.closeTime,
    required this.minDuration,
  });

  final String? sportName;
  final int? hourlyRate;
  final String? openTime;
  final String? closeTime;
  final int? minDuration;

  Sport copyWith({
    String? sportName,
    int? hourlyRate,
    String? openTime,
    String? closeTime,
    int? minDuration,
  }) {
    return Sport(
      sportName: sportName ?? this.sportName,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      minDuration: minDuration ?? this.minDuration,
    );
  }

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      sportName: json["sportName"],
      hourlyRate: json["hourlyRate"],
      openTime: json["openTime"],
      closeTime: json["closeTime"],
      minDuration: json["minDuration"],
    );
  }
}

class WeeklySlot {
  final List<Padel> tennis;
  final List<Padel> padel;
  final List<Padel> pickleball;
  final List<Padel> beachTennis;

  WeeklySlot(
      {required this.tennis, required this.padel, required this.pickleball, required this.beachTennis});


  WeeklySlot copyWith(
      {List<Padel>? tennis, List<Padel>? padel, List<Padel>? pickleball, List<
          Padel>? beachTennis}) {
    return WeeklySlot(
      tennis: tennis ?? this.tennis,
      padel: padel ?? this.padel,
        pickleball: pickleball ?? this.pickleball,
        beachTennis: beachTennis ?? this.beachTennis
    );
  }

  factory WeeklySlot.fromJson(Map<String, dynamic> json) {
    return WeeklySlot(
      tennis: json["Tennis"] == null
          ? []
          : List<Padel>.from(json["Tennis"]!.map((x) => Padel.fromJson(x))),
      padel: json["Padel"] == null
          ? []
          : List<Padel>.from(json["Padel"]!.map((x) => Padel.fromJson(x))),
      pickleball: json["Pickleball"] == null
          ? []
          : List<Padel>.from(json["Pickleball"]!.map((x) => Padel.fromJson(x))),
      beachTennis: json["beach_tennis"] == null
          ? []
          : List<Padel>.from(
          json["beach_tennis"]!.map((x) => Padel.fromJson(x))),
    );
  }
}

class Padel {
  Padel({
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.type,
  });

  final String? startTime;
  final String? endTime;
  final String? status;
  final String? type;

  Padel copyWith({
    String? startTime,
    String? endTime,
    String? status,
    String? type,
  }) {
    return Padel(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }

  factory Padel.fromJson(Map<String, dynamic> json) {
    return Padel(
      startTime: json["startTime"],
      endTime: json["endTime"],
      status: json["status"],
      type: json["type"],
    );
  }
}
