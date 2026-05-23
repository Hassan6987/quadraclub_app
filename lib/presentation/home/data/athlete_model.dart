// models/athlete_model.dart
import 'package:parsing_util/parsing_util.dart';

class AthleteModel {
  final int? id;
  final ScannedUserProfile? scannedUserProfile;
  final String? email;
  final DateTime? scannedAt;

  AthleteModel({this.id, this.scannedUserProfile, this.email, this.scannedAt});

  factory AthleteModel.fromJson(Map<String, dynamic> json) {
    return AthleteModel(
      id: ParsingUtil.toSafeInt(json['id']),
      email: ParsingUtil.toSafeString(json["email"]),
      scannedUserProfile: json["scanned_user_profile"] == null
          ? (json["profile"] == null
                ? null
                : ScannedUserProfile.fromJson(json["profile"]))
          : ScannedUserProfile.fromJson(json["scanned_user_profile"]),
      scannedAt: DateTime.tryParse(json["scanned_at"] ?? ""),
    );
  }
}

class ScannedUserProfile {
  final int? id;
  final String? fullName;
  final int? graduationYear;
  final String? teamName;
  final String? position;
  final String? hit;
  final String? image;
  final List<HighlightVideo>? highlightVideos;
  final String? transcript;
  final double? averageRating;

  ScannedUserProfile({
    this.id,
    this.fullName,
    this.graduationYear,
    this.teamName,
    this.position,
    this.hit,
    this.image,
    this.highlightVideos,
    this.transcript,
    this.averageRating,
  });

  factory ScannedUserProfile.fromJson(Map<String, dynamic> json) {
    return ScannedUserProfile(
      id: ParsingUtil.toSafeInt(json['user_id']),
      fullName: ParsingUtil.toSafeString(json["full_name"]),
      graduationYear: ParsingUtil.toSafeInt(json["graduation_year"]),
      teamName: ParsingUtil.toSafeString(json["team_name"]),
      position: ParsingUtil.toSafeString(json["position"]),
      hit: ParsingUtil.toSafeString(json["hit"]),
      image: ParsingUtil.toSafeString(json["image"]),
      highlightVideos: json["highlight_videos"] == null
          ? []
          : List<HighlightVideo>.from(
              json["highlight_videos"]!.map((x) => HighlightVideo.fromJson(x)),
            ),
      transcript: ParsingUtil.toSafeString(json["transcript"]),
      averageRating: ParsingUtil.toSafeDouble(json["average_rating"]),
    );
  }
}

class HighlightVideo {
  final int? id;
  final String? video;
  final DateTime? uploadedAt;

  HighlightVideo({this.id, this.video, this.uploadedAt});

  factory HighlightVideo.fromJson(Map<String, dynamic> json) {
    return HighlightVideo(
      id: ParsingUtil.toSafeInt(json["id"]),
      video: ParsingUtil.toSafeString(json["video"]),
      uploadedAt: ParsingUtil.toSafeDateTime(json["uploaded_at"]),
    );
  }
}
