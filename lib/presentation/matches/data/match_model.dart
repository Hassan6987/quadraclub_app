import 'package:parsing_util/parsing_util.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';

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

  static MatchFormat fromString(String value) {
    switch (value.trim().toLowerCase()) {
      case 'single':
        return MatchFormat.singles;
      case 'double':
        return MatchFormat.doubles;
      default:
        return MatchFormat.singles;
    }
  }

}

extension CourtStatusExtension on CourtStatus{

  static CourtStatus fromString(String value) {
    switch (value.trim().toLowerCase()) {
      case 'pending':
        return CourtStatus.pending;
      case 'confirmed':
        return CourtStatus.confirmed;
      default:
        return CourtStatus.confirmed;
    }
  }
}

class Booking {
  Booking({
    required this.id,
    required this.club,
    required this.bookingType,
    required this.matchType,
    required this.format,
    required this.paymentType,
    required this.sport,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.serviceFee,
    required this.status,
    required this.playersDetail,
    required this.createdAt,
    required this.updatedAt,
    required this.bookingId,
    required this.chat,
    required this.maxCapacity,
    required this.filledSlots,
    required this.needsPlayers,
    required this.isFull,
  });

  final String? id;
  final BookedClub? club;
  final String? bookingType;
  final String? matchType;
  final MatchFormat format;
  final String? paymentType;
  final SportType sport;
  final DateTime? bookingDate;
  final String? startTime;
  final String? endTime;
  final int? totalPrice;
  final int? serviceFee;
  final CourtStatus status;
  final List<PlayersDetail> playersDetail;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? bookingId;
  final String? chat;
  final int? maxCapacity;
  final int? filledSlots;
  final int? needsPlayers;
  final bool? isFull;

  factory Booking.fromJson(Map<String, dynamic> json){
    return Booking(
      id: json["_id"],
      club: json["club"] == null ? null : BookedClub.fromJson(json["club"]),
      bookingType: json["bookingType"],
      matchType: json["matchType"],
      format: MatchFormatExtension.fromString(json["format"] ?? ''),
      paymentType: json["paymentType"],
      sport: SportTypeExtension.fromString(json["sport"] ?? ''),
      bookingDate: ParsingUtil.toSafeDateTime(json["bookingDate"] ?? ""),
      startTime: json["startTime"],
      endTime: json["endTime"],
      totalPrice: json["totalPrice"],
      serviceFee: json["serviceFee"],
      status: CourtStatusExtension.fromString(json["status"] ?? ''),
      playersDetail: json["playersDetail"] == null ? [] : List<
          PlayersDetail>.from(
          json["playersDetail"]!.map((x) => PlayersDetail.fromJson(x))),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      bookingId: json["bookingId"],
      chat: json["chat"],
      maxCapacity: json["maxCapacity"],
      filledSlots: json["filledSlots"],
      needsPlayers: json["needsPlayers"],
      isFull: json["isFull"],
    );
  }

}

class BookedBy {
  BookedBy({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profilePhoto,
  });

  final String? id;
  final String? fullName;
  final String? email;
  final String? profilePhoto;

  factory BookedBy.fromJson(Map<String, dynamic> json){
    return BookedBy(
      id: json["_id"],
      fullName: json["fullName"],
      email: json["email"],
      profilePhoto: json["profilePhoto"],
    );
  }

}

class BookedClub {
  BookedClub({
    required this.id,
    required this.name,
    required this.street,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.photo,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? name;
  final String? street;
  final String? city;
  final String? state;
  final double? latitude;
  final double? longitude;
  final dynamic photo;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory BookedClub.fromJson(Map<String, dynamic> json){
    return BookedClub(
      id: json["_id"],
      name: json["name"],
      street: json["street"],
      city: json["city"],
      state: json["state"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      photo: json["photo"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}

class PlayersDetail {
  PlayersDetail({
    required this.user,
    required this.role,
    required this.slotName,
    required this.status,
    required this.payment,
    required this.id,
  });

  final BookedBy? user;
  final String? role;
  final String? slotName;
  final String? status;
  final String? payment;
  final String? id;

  factory PlayersDetail.fromJson(Map<String, dynamic> json){
    return PlayersDetail(
      user: json["user"] == null ? null : BookedBy.fromJson(json["user"]),
      role: json["role"],
      slotName: json["slotName"],
      status: json["status"],
      payment: json["payment"],
      id: json["_id"],
    );
  }

}

