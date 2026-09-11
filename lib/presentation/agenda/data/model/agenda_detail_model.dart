import 'package:quadraclub_app/presentation/agenda/data/model/agenda_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/invite_player_model.dart';

class AgendaMatchDetails {
  AgendaMatchDetails({
    required this.id,
    required this.bookingId,
    required this.title,
    required this.location,
    required this.sport,
    required this.bookingDate,
    required this.dateFormatted,
    required this.startTime,
    required this.endTime,
    required this.matchType,
    required this.format,
    required this.categoryTag,
    required this.courtStatus,
    required this.totalPrice,
    required this.status,
    required this.isOwner,
    required this.chat,
    required this.players,
    required this.requests,
    required this.invited,
    required this.scores,
    required this.scoreStatus,
    required this.playersFeedback,
    required this.clubRating,
    required this.clubFeedback,
    required this.feedbackCompleted,
  });

  final String? id;
  final String? bookingId;
  final String? title;
  final String? location;
  final String? sport;
  final DateTime? bookingDate;
  final String? dateFormatted;
  final String? startTime;
  final String? endTime;
  final String? matchType;
  final String? format;
  final String? categoryTag;
  final String? courtStatus;
  final int? totalPrice;
  final String? status;
  final bool? isOwner;
  final AgendaMatchChat? chat;
  final List<Player> players;
  final List<Player> requests;
  final List<InvitePlayerModel> invited;
  final List<dynamic> scores;
  final String? scoreStatus;
  final List<dynamic> playersFeedback;
  final dynamic clubRating;
  final String? clubFeedback;
  final bool? feedbackCompleted;

  factory AgendaMatchDetails.fromJson(Map<String, dynamic> json) {
    return AgendaMatchDetails(
      id: json["_id"],
      bookingId: json["bookingId"],
      title: json["title"],
      location: json["location"],
      sport: json["sport"],
      bookingDate: DateTime.tryParse(json["bookingDate"] ?? ""),
      dateFormatted: json["dateFormatted"],
      startTime: json["startTime"],
      endTime: json["endTime"],
      matchType: json["matchType"],
      format: json["format"],
      categoryTag: json["categoryTag"],
      courtStatus: json["courtStatus"],
      totalPrice: json["totalPrice"],
      status: json["status"],
      isOwner: json["isOwner"],
      chat: json["chat"] == null
          ? null
          : AgendaMatchChat.fromJson(json["chat"]),
      players: json["players"] == null
          ? []
          : List<Player>.from(json["players"]!.map((x) => Player.fromJson(x))),
      requests: json["requests"] == null
          ? []
          : List<Player>.from(json["requests"]!.map((x) => Player.fromJson(x))),
      invited: json["invited"] == null
          ? []
          : List<InvitePlayerModel>.from(
              json["invited"]!.map((x) => InvitePlayerModel.fromJson(x)),
            ),
      scores: json["scores"] == null
          ? []
          : List<dynamic>.from(json["scores"]!.map((x) => x)),
      scoreStatus: json["scoreStatus"],
      playersFeedback: json["playersFeedback"] == null
          ? []
          : List<dynamic>.from(json["playersFeedback"]!.map((x) => x)),
      clubRating: json["clubRating"],
      clubFeedback: json["clubFeedback"],
      feedbackCompleted: json["feedbackCompleted"],
    );
  }

  AgendaMatchDetails copyWith({
    String? id,
    String? bookingId,
    String? title,
    String? location,
    String? sport,
    DateTime? bookingDate,
    String? dateFormatted,
    String? startTime,
    String? endTime,
    String? matchType,
    String? format,
    String? categoryTag,
    String? courtStatus,
    int? totalPrice,
    String? status,
    bool? isOwner,
    AgendaMatchChat? chat,
    List<Player>? players,
    List<Player>? requests,
    List<InvitePlayerModel>? invited,
    List<dynamic>? scores,
    String? scoreStatus,
    List<dynamic>? playersFeedback,
    dynamic clubRating,
    String? clubFeedback,
    bool? feedbackCompleted,
  }) {
    return AgendaMatchDetails(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      title: title ?? this.title,
      location: location ?? this.location,
      sport: sport ?? this.sport,
      bookingDate: bookingDate ?? this.bookingDate,
      dateFormatted: dateFormatted ?? this.dateFormatted,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      matchType: matchType ?? this.matchType,
      format: format ?? this.format,
      categoryTag: categoryTag ?? this.categoryTag,
      courtStatus: courtStatus ?? this.courtStatus,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      isOwner: isOwner ?? this.isOwner,
      chat: chat ?? this.chat,
      players: players ?? this.players,
      requests: requests ?? this.requests,
      invited: invited ?? this.invited,
      scores: scores ?? this.scores,
      scoreStatus: scoreStatus ?? this.scoreStatus,
      playersFeedback: playersFeedback ?? this.playersFeedback,
      clubRating: clubRating ?? this.clubRating,
      clubFeedback: clubFeedback ?? this.clubFeedback,
      feedbackCompleted: feedbackCompleted ?? this.feedbackCompleted,
    );
  }
}

class AgendaMatchChat {
  AgendaMatchChat({
    required this.id,
    required this.chatName,
    required this.users,
  });

  final String? id;
  final String? chatName;
  final List<String> users;

  factory AgendaMatchChat.fromJson(Map<String, dynamic> json) {
    return AgendaMatchChat(
      id: json["_id"],
      chatName: json["chatName"],
      users: json["users"] == null
          ? []
          : List<String>.from(json["users"]!.map((x) => x)),
    );
  }
}
