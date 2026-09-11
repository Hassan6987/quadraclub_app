import 'package:quadraclub_app/utils/helper/time_slot_helper.dart';

class Court {
  final String? id;
  final String? courtName;
  final String? location;
  final String? courtOwner;
  final String? courtPhoto;
  final List<Sport>? sports;
  final String? status;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final int? averageRating;
  final int? totalReviews;

  // Not in the current API response — parsed if/when backend adds them.
  final double? latitude;
  final double? longitude;

  Court({
    this.id,
    this.courtName,
    this.location,
    this.courtOwner,
    this.courtPhoto,
    this.sports,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.averageRating,
    this.totalReviews,
    this.latitude,
    this.longitude,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      id: json['_id'] as String?,
      courtName: json['courtName'] as String?,
      location: json['location'] as String?,
      courtOwner: json['courtOwner'] as String?,
      courtPhoto: json['courtPhoto'] as String?,
      sports: (json['sports'] as List<dynamic>?)
          ?.map((e) => Sport.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String?,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      v: json['__v'] as int?,
      averageRating: json['averageRating'] as int?,
      totalReviews: json['totalReviews'] as int?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}

class Sport {
  final String? sportName;
  final int? hourlyRate;
  final String? openTime;
  final String? closeTime;
  final int? minDuration;

  Sport({
    this.sportName,
    this.hourlyRate,
    this.openTime,
    this.closeTime,
    this.minDuration,
  });

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      sportName: json['sportName'] as String?,
      hourlyRate: json['hourlyRate'] as int?,
      openTime: json['openTime'] as String?,
      closeTime: json['closeTime'] as String?,
      minDuration: json['minDuration'] as int?,
    );
  }

  bool sameSportAs(Sport? other) =>
      other != null && sportName != null && sportName == other.sportName;
}

extension SportSlots on Sport {
  List<String> get hourlySlots => TimeSlotHelper.generateHourlySlots(
    openTime: openTime,
    closeTime: closeTime,
  );
}

extension CourtDisplay on Court {
  String get city => (location?.split(',').first.trim()) ?? '';

  /// Falls back to a placeholder since courtPhoto is often "" from the API.
  String get imageUrl => (courtPhoto != null && courtPhoto!.isNotEmpty)
      ? courtPhoto!
      : 'https://via.placeholder.com/300x200.png?text=Court';

  bool get hasCoordinates => latitude != null && longitude != null;
}
