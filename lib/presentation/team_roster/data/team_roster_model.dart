class TeamRoster {
  TeamRoster({
    required this.id,
    required this.athleteProfile,
    required this.savedAt,
  });

  final int? id;
  final Profile? athleteProfile;
  final DateTime? savedAt;

  factory TeamRoster.fromJson(Map<String, dynamic> json) {
    final athleteJson = json["athlete"];
    return TeamRoster(
      id: athleteJson["id"],
      athleteProfile: json["athlete_profile"] == null
          ? null
          : Profile.fromJson(json["athlete_profile"]),
      savedAt: DateTime.tryParse(json["saved_at"] ?? ""),
    );
  }
}

class Profile {
  Profile({
    required this.id,
    required this.fullName,
    required this.graduationYear,
    required this.teamName,
    required this.collegeName,
    required this.position,
    required this.hit,
    required this.status,
    required this.nfcTagId,
    required this.image,
    required this.highlightVideos,
    required this.transcript,
  });

  final int? id;
  final String? fullName;
  final int? graduationYear;
  final String? teamName;
  final dynamic collegeName;
  final String? position;
  final String? hit;
  final String? status;
  final String? nfcTagId;
  final String? image;
  final List<HighlightVideo> highlightVideos;
  final dynamic transcript;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json["id"],
      fullName: json["full_name"],
      graduationYear: json["graduation_year"],
      teamName: json["team_name"],
      collegeName: json["college_name"],
      position: json["position"],
      hit: json["hit"],
      status: json["status"],
      nfcTagId: json["nfc_tag_id"],
      image: json["image"],
      highlightVideos: json["highlight_videos"] == null
          ? []
          : List<HighlightVideo>.from(
              json["highlight_videos"]!.map((x) => HighlightVideo.fromJson(x)),
            ),
      transcript: json["transcript"],
    );
  }
}

class HighlightVideo {
  HighlightVideo({
    required this.id,
    required this.video,
    required this.uploadedAt,
  });

  final int? id;
  final String? video;
  final DateTime? uploadedAt;

  factory HighlightVideo.fromJson(Map<String, dynamic> json) {
    return HighlightVideo(
      id: json["id"],
      video: json["video"],
      uploadedAt: DateTime.tryParse(json["uploaded_at"] ?? ""),
    );
  }
}
