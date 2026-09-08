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

  MatchRequest({
    required this.name,
    required this.imageUrl,
    this.message,
  });
}

class InvitedPlayer {
  final String name;
  final String imageUrl;

  InvitedPlayer({
    required this.name,
    required this.imageUrl,
  });
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