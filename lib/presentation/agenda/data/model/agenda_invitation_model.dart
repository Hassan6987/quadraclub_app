import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';

class AgendaInvitation {
  AgendaInvitation({
    required this.id,
    required this.bookingId,
    required this.agendaType,
    required this.title,
    required this.courtName,
    required this.location,
    required this.clubImage,
    required this.sport,
    required this.bookingDate,
    required this.dateString,
    required this.startTime,
    required this.endTime,
    required this.matchType,
    required this.format,
    required this.category,
    required this.courtStatusLabel,
    required this.price,
    required this.totalPrice,
    required this.paymentType,
    required this.requiresPayment,
    required this.seatsTag,
    required this.slotsLeft,
    required this.maxCapacity,
    required this.isFull,
    required this.status,
    required this.tab,
    required this.players,
    required this.hostId,
    required this.hostName,
    required this.hostPhoto,
    required this.chatId,
    required this.isOwner,
    required this.invitationStatus,
  });

  final String id;
  final String bookingId;
  final String agendaType;
  final String title;
  final String courtName;
  final String location;
  final String clubImage;
  final String sport;
  final DateTime? bookingDate;
  final String dateString;
  final String startTime;
  final String endTime;
  final String matchType;
  final MatchFormat format;
  final String category;
  final String courtStatusLabel;
  final int price;
  final int totalPrice;
  final String paymentType;
  final bool requiresPayment;
  final String seatsTag;
  final int slotsLeft;
  final int maxCapacity;
  final bool isFull;
  final String status;
  final String tab;
  final List<Player> players;
  final String hostId;
  final String hostName;
  final String hostPhoto;
  final String chatId;
  final bool isOwner;
  final String invitationStatus;

  factory AgendaInvitation.fromJson(Map<String, dynamic> json) {
    return AgendaInvitation(
      id: json["id"] ?? "",
      bookingId: json["bookingId"] ?? "",
      agendaType: json["agendaType"] ?? "",
      title: json["title"] ?? "",
      courtName: json["courtName"] ?? "",
      location: json["location"] ?? "",
      clubImage: json["clubImage"] ?? "",
      sport: json["sport"] ?? "",
      bookingDate: DateTime.tryParse(json["bookingDate"] ?? ""),
      dateString: json["dateString"] ?? "",
      startTime: json["startTime"] ?? "",
      endTime: json["endTime"] ?? "",
      matchType: json["matchType"] ?? "",
      format: MatchFormatExtension.fromString(json['format'] ?? ''),
      category: json["category"] ?? "",
      courtStatusLabel: json["courtStatusLabel"] ?? "",
      price: json["price"] ?? 0,
      totalPrice: json["totalPrice"] ?? 0,
      paymentType: json["paymentType"] ?? "",
      requiresPayment: json["requiresPayment"] ?? false,
      seatsTag: json["seatsTag"] ?? "",
      slotsLeft: json["slotsLeft"] ?? 0,
      maxCapacity: json["maxCapacity"] ?? 0,
      isFull: json["isFull"] ?? false,
      status: json["status"] ?? "",
      tab: json["tab"] ?? "",
      players: json["players"] == null
          ? []
          : List<Player>.from(json["players"]!.map((x) => Player.fromJson(x))),
      hostId: json["hostId"] ?? "",
      hostName: json["hostName"] ?? "",
      hostPhoto: json["hostPhoto"] ?? "",
      chatId: json["chatId"] ?? "",
      isOwner: json["isOwner"] ?? false,
      invitationStatus: json["invitationStatus"] ?? "",
    );
  }
}
