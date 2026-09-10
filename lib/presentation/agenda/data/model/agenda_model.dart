import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';

enum AgendaStatus { confirmed, pending, past }

enum MatchDetailsTab { details, requests, invited }

class AgendaMatch {
  final SportType sport;
  final String venue;
  final String location;
  final String time;
  final AgendaStatus status;

  const AgendaMatch({
    required this.sport,
    required this.venue,
    required this.location,
    required this.time,
    required this.status,
  });
}

class AgendaClass {
  final SportType sport;
  final String title;
  final String location;
  final String time;
  final int price;
  final AgendaStatus status;

  const AgendaClass({
    required this.sport,
    required this.title,
    required this.location,
    required this.time,
    required this.price,
    required this.status,
  });
}

class MatchRequest {
  final String name;
  final String imageUrl;
  final String? message;

  MatchRequest({required this.name, required this.imageUrl, this.message});
}

class InvitedPlayer {
  final String name;
  final String imageUrl;

  InvitedPlayer({required this.name, required this.imageUrl});
}

class PlayerInvite {
  final String name;
  final String imageUrl;
  final bool isInvited;

  PlayerInvite({
    required this.name,
    required this.imageUrl,
    required this.isInvited,
  });
}

enum AgendaType { court, game, class_, unknown }

class AgendaItem {
  final String id;
  final AgendaType agendaType;
  final String title;
  final String courtName;
  final String location;
  final String sport;
  final DateTime bookingDate;
  final String dateString;
  final String startTime;
  final String endTime;
  final String category;
  final num price;
  final String status;
  final String? chatId;
  final bool isOwner;

  // court/game-only
  final String? courtStatusLabel;
  final String? seatsTag;
  final int? slotsLeft;
  final int? maxCapacity;
  final List<Player>? players;

  // class-only
  final String? classType;
  final String? coachName;
  final String? coachPhoto;

  AgendaItem({
    required this.id,
    required this.agendaType,
    required this.title,
    required this.courtName,
    required this.location,
    required this.sport,
    required this.bookingDate,
    required this.dateString,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.price,
    required this.status,
    this.chatId,
    required this.isOwner,
    this.courtStatusLabel,
    this.seatsTag,
    this.slotsLeft,
    this.maxCapacity,
    this.players,
    this.classType,
    this.coachName,
    this.coachPhoto,
  });

  factory AgendaItem.fromJson(Map<String, dynamic> json) {
    AgendaType type;
    switch (json['agendaType']) {
      case 'court':
        type = AgendaType.court;
        break;
      case 'game':
        type = AgendaType.game;
        break;
      case 'class':
        type = AgendaType.class_;
        break;
      default:
        type = AgendaType.unknown;
    }

    return AgendaItem(
      id: json['id'] ?? '',
      agendaType: type,
      title: json['title'] ?? '',
      courtName: json['courtName'] ?? '',
      location: json['location'] ?? '',
      sport: json['sport'] ?? '',
      bookingDate: DateTime.parse(json['bookingDate']),
      dateString: json['dateString'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      category: json['category'] ?? '',
      price: json['price'] ?? 0,
      status: json['status'] ?? '',
      chatId: json['chatId'],
      isOwner: json['isOwner'] ?? false,
      courtStatusLabel: json['courtStatusLabel'],
      seatsTag: json['seatsTag'],
      slotsLeft: json['slotsLeft'],
      maxCapacity: json['maxCapacity'],
      players: (json['players'] as List<dynamic>?)
          ?.map((p) => Player.fromJson(p))
          .toList(),
      classType: json['classType'],
      coachName: json['coachName'],
      coachPhoto: json['coachPhoto'],
    );
  }
}

class Player {
  final String? id;
  final String name;
  final String role;
  final String status;
  final String level;
  final String profilePhoto;

  Player({
    this.id,
    required this.name,
    required this.role,
    required this.status,
    required this.level,
    required this.profilePhoto,
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    id: json['id'],
    name: json['name'] ?? '',
    role: json['role'] ?? '',
    status: json['status'] ?? '',
    level: json['level'] ?? '',
    profilePhoto: json['profilePhoto'] ?? '',
  );
}
