class MissingFeedbackResponse {
  MissingFeedbackResponse({
    required this.hasMissingFeedback,
    required this.missingCount,
    required this.message,
    required this.matches,
  });

  final bool hasMissingFeedback;
  final int missingCount;
  final String message;
  final List<MissingFeedbackMatch> matches;

  factory MissingFeedbackResponse.fromJson(Map<String, dynamic> json) {
    final list = json['matches'] as List<dynamic>? ?? [];
    return MissingFeedbackResponse(
      hasMissingFeedback: json['hasMissingFeedback'] == true,
      missingCount: json['missingCount'] as int? ?? list.length,
      message: json['message'] as String? ?? '',
      matches: list
          .map((e) => MissingFeedbackMatch.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MissingFeedbackMatch {
  MissingFeedbackMatch({
    required this.id,
    required this.bookingId,
    required this.sport,
    required this.matchType,
    required this.format,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.scores,
    required this.scoreStatus,
    required this.feedbackCompleted,
    required this.feedbackOpensAt,
    required this.club,
    required this.court,
    required this.team1,
    required this.team2,
  });

  final String id;
  final String bookingId;
  final String sport;
  final String matchType;
  final String format;
  final DateTime? bookingDate;
  final String startTime;
  final String endTime;
  final String status;
  final List<MatchSetScore> scores;
  final String scoreStatus;
  final bool feedbackCompleted;
  final DateTime? feedbackOpensAt;
  final MissingFeedbackClub? club;
  final MissingFeedbackCourt? court;
  final List<MissingFeedbackPlayer> team1;
  final List<MissingFeedbackPlayer> team2;

  List<MissingFeedbackPlayer> get allPlayers => [...team1, ...team2];

  factory MissingFeedbackMatch.fromJson(Map<String, dynamic> json) {
    final teams = json['teams'] as Map<String, dynamic>? ?? {};
    return MissingFeedbackMatch(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      bookingId: json['bookingId'] as String? ?? '',
      sport: json['sport'] as String? ?? '',
      matchType: json['matchType'] as String? ?? '',
      format: json['format'] as String? ?? '',
      bookingDate: DateTime.tryParse(json['bookingDate'] as String? ?? ''),
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      status: json['status'] as String? ?? '',
      scores: (json['scores'] as List<dynamic>? ?? [])
          .map((e) => MatchSetScore.fromJson(e as Map<String, dynamic>))
          .toList(),
      scoreStatus: json['scoreStatus'] as String? ?? '',
      feedbackCompleted: json['feedbackCompleted'] == true,
      feedbackOpensAt: DateTime.tryParse(
        json['feedbackOpensAt'] as String? ?? '',
      ),
      club: json['club'] == null
          ? null
          : MissingFeedbackClub.fromJson(json['club'] as Map<String, dynamic>),
      court: json['court'] == null
          ? null
          : MissingFeedbackCourt.fromJson(
              json['court'] as Map<String, dynamic>,
            ),
      team1: (teams['team1'] as List<dynamic>? ?? [])
          .map((e) => MissingFeedbackPlayer.fromJson(e as Map<String, dynamic>))
          .toList(),
      team2: (teams['team2'] as List<dynamic>? ?? [])
          .map((e) => MissingFeedbackPlayer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MatchSetScore {
  MatchSetScore({
    required this.set,
    required this.team1Score,
    required this.team2Score,
  });

  final int set;
  final int team1Score;
  final int team2Score;

  Map<String, dynamic> toJson() => {
    'set': set,
    'team1Score': team1Score,
    'team2Score': team2Score,
  };

  factory MatchSetScore.fromJson(Map<String, dynamic> json) {
    return MatchSetScore(
      set: json['set'] as int? ?? 0,
      team1Score: json['team1Score'] as int? ?? 0,
      team2Score: json['team2Score'] as int? ?? 0,
    );
  }
}

class MissingFeedbackClub {
  MissingFeedbackClub({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.street,
    required this.neighbourhood,
    required this.photo,
    required this.location,
  });

  final String id;
  final String name;
  final String city;
  final String state;
  final String street;
  final String neighbourhood;
  final String photo;
  final String location;

  factory MissingFeedbackClub.fromJson(Map<String, dynamic> json) {
    return MissingFeedbackClub(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      street: json['street'] as String? ?? '',
      neighbourhood: json['neighbourhood'] as String? ?? '',
      photo: json['photo'] as String? ?? '',
      location: json['location'] as String? ?? '',
    );
  }
}

class MissingFeedbackCourt {
  MissingFeedbackCourt({
    required this.id,
    required this.courtName,
    required this.location,
  });

  final String id;
  final String courtName;
  final String location;

  factory MissingFeedbackCourt.fromJson(Map<String, dynamic> json) {
    return MissingFeedbackCourt(
      id: json['id'] as String? ?? '',
      courtName: json['courtName'] as String? ?? '',
      location: json['location'] as String? ?? '',
    );
  }
}

class MissingFeedbackPlayer {
  MissingFeedbackPlayer({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profilePhoto,
    required this.role,
    required this.slotName,
    required this.status,
  });

  final String id;
  final String fullName;
  final String email;
  final String profilePhoto;
  final String role;
  final String slotName;
  final String status;

  factory MissingFeedbackPlayer.fromJson(Map<String, dynamic> json) {
    return MissingFeedbackPlayer(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profilePhoto: json['profilePhoto'] as String? ?? '',
      role: json['role'] as String? ?? '',
      slotName: json['slotName'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}

class PlayerFeedbackInput {
  PlayerFeedbackInput({
    required this.userId,
    required this.didNotShowUp,
    required this.tags,
  });

  final String userId;
  final bool didNotShowUp;
  final List<String> tags;

  Map<String, dynamic> toJson() => {
    'user': userId,
    'didNotShowUp': didNotShowUp,
    'tags': tags,
  };
}

class SubmitMatchFeedbackRequest {
  SubmitMatchFeedbackRequest({
    required this.scores,
    required this.playersFeedback,
    required this.clubRating,
    required this.clubFeedback,
  });

  final List<MatchSetScore> scores;
  final List<PlayerFeedbackInput> playersFeedback;
  final int clubRating;
  final String clubFeedback;

  Map<String, dynamic> toJson() => {
    'scores': scores.map((s) => s.toJson()).toList(),
    'playersFeedback': playersFeedback.map((p) => p.toJson()).toList(),
    'clubRating': clubRating,
    'clubFeedback': clubFeedback,
  };
}

/// Tags the host can assign when rating other players.
class MatchFeedbackTagOption {
  const MatchFeedbackTagOption({required this.label, required this.icon});

  final String label;
  final String? icon;

  static const List<MatchFeedbackTagOption> defaults = [
    MatchFeedbackTagOption(label: 'Good Defense', icon: null),
    MatchFeedbackTagOption(label: 'Good Attack', icon: null),
    MatchFeedbackTagOption(label: 'One-off', icon: null),
    MatchFeedbackTagOption(label: 'Strategic', icon: null),
    MatchFeedbackTagOption(label: 'Arrive Early', icon: null),
    MatchFeedbackTagOption(label: 'Good Energy', icon: null),
  ];
}
