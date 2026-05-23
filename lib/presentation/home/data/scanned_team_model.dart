class ScannedTeamAthlete {
  final int id;
  final String fullName;
  final String email;
  final String? image;
  final int? graduationYear;
  final String? position;
  bool inRoster;

  ScannedTeamAthlete({
    required this.id,
    required this.fullName,
    required this.email,
    this.image,
    this.graduationYear,
    this.position,
    this.inRoster = false,
  });

  factory ScannedTeamAthlete.fromJson(Map<String, dynamic> json) {
    // Handles both direct athlete objects and roster-wrapped objects
    final athleteJson = json['athlete'] ?? json;
    final profileJson = athleteJson['profile'] ?? json['athlete_profile'] ?? {};

    return ScannedTeamAthlete(
      id: athleteJson['id'] ?? 0,
      fullName: profileJson['full_name'] ?? '',
      email: athleteJson['email'] ?? '',
      image: profileJson['image'],
      graduationYear: profileJson['graduation_year'],
      position: profileJson['position'],
    );
  }

  ScannedTeamAthlete copyWith({bool? inRoster}) {
    return ScannedTeamAthlete(
      id: id,
      fullName: fullName,
      email: email,
      image: image,
      graduationYear: graduationYear,
      position: position,
      inRoster: inRoster ?? this.inRoster,
    );
  }
}

class ScannedTeam {
  final String teamId;
  final String name;
  final String? ageGroup;
  final int? seasonYear;
  final String? city;
  final List<ScannedTeamAthlete> athletes;

  ScannedTeam({
    required this.teamId,
    required this.name,
    this.ageGroup,
    this.seasonYear,
    this.city,
    this.athletes = const [],
  });

  factory ScannedTeam.fromJson(Map<String, dynamic> json) {
    final teamJson = json['team'] ?? json;

    return ScannedTeam(
      teamId: teamJson['team_id'] ?? '',
      name: teamJson['name'] ?? '',
      ageGroup: teamJson['age_group'],
      seasonYear: teamJson['season_year'],
      city: teamJson['city'],
      athletes: [],
    );
  }

  ScannedTeam copyWith({List<ScannedTeamAthlete>? athletes}) {
    return ScannedTeam(
      teamId: teamId,
      name: name,
      ageGroup: ageGroup,
      seasonYear: seasonYear,
      city: city,
      athletes: athletes ?? this.athletes,
    );
  }
}
