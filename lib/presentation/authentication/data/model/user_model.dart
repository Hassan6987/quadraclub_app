import 'package:parsing_util/parsing_util.dart';

class UserModel {
  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profilePhoto,
    required this.role,
    required this.isVerified,
    required this.dateOfBirth,
    required this.location,
    required this.gender,
    required this.dominantHand,
    required this.sportsInfo,
    required this.registrationStep,
    required this.portfolioBalance,
    required this.matchesCompleted,
    required this.victories,
    required this.defeats,
    required this.feedbackStats,
  });

  final String? id;
  final String? fullName;
  final String? email;
  final String? profilePhoto;
  final String? role;
  final bool? isVerified;
  final DateTime? dateOfBirth;
  final String? location;
  final String? gender;
  final String? dominantHand;
  final List<SportsInfo> sportsInfo;
  final int? registrationStep;
  final double? portfolioBalance;
  final int matchesCompleted;
  final int victories;
  final int defeats;
  final List<FeedbackStats> feedbackStats;

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? profilePhoto,
    String? role,
    bool? isVerified,
    DateTime? dateOfBirth,
    String? location,
    String? gender,
    String? dominantHand,
    List<SportsInfo>? sportsInfo,
    int? registrationStep,
    double? portfolioBalance,
    int? matchesCompleted,
    int? victories,
    int? defeats,
    List<FeedbackStats>? feedbackStats,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      location: location ?? this.location,
      gender: gender ?? this.gender,
      dominantHand: dominantHand ?? this.dominantHand,
      sportsInfo: sportsInfo ?? this.sportsInfo,
      registrationStep: registrationStep ?? this.registrationStep,
      portfolioBalance: portfolioBalance ?? this.portfolioBalance,
      matchesCompleted: matchesCompleted ?? this.matchesCompleted,
      victories: victories ?? this.victories,
      defeats: defeats ?? this.defeats,
      feedbackStats: feedbackStats ?? this.feedbackStats,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"],
      fullName: json["fullName"],
      email: json["email"],
      profilePhoto: json["profilePhoto"],
      role: json["role"],
      isVerified: json["isVerified"],
      dateOfBirth: DateTime.tryParse(json["dateOfBirth"] ?? ""),
      location: json["location"],
      gender: json["gender"],
      dominantHand: json["dominantHand"],
      sportsInfo: json["sportsInfo"] == null
          ? []
          : List<SportsInfo>.from(
              json["sportsInfo"]!.map((x) => SportsInfo.fromJson(x)),
            ),
      registrationStep: json["registrationStep"],
      portfolioBalance: ParsingUtil.toSafeDouble(json["portfolioBalance"]),
      matchesCompleted: json["matches"] ?? 0,
      victories: json["victories"] ?? 0,
      defeats: json["defeats"] ?? 0,
      feedbackStats: json["feedbacks"] == null
          ? []
          : List<FeedbackStats>.from(
              json["feedbacks"].map((x) => FeedbackStats.fromJson(x)),
            ),
    );
  }
}

class SportsInfo {
  SportsInfo({required this.sport, required this.category, this.preferredSide});

  final String? sport;
  final String? category;
  final String? preferredSide;

  SportsInfo copyWith({
    String? sport,
    String? category,
    String? preferredSide,
  }) {
    return SportsInfo(
      sport: sport ?? this.sport,
      category: category ?? this.category,
      preferredSide: preferredSide ?? this.preferredSide,
    );
  }

  factory SportsInfo.fromJson(Map<String, dynamic> json) {
    return SportsInfo(
      sport: json["sport"],
      category: json["category"],
      preferredSide: json["preferredSide"],
    );
  }

  Map<String, dynamic> toJson() => {
    "sport": sport,
    "category": category,
    if (preferredSide != null) "preferredSide": preferredSide,
  };
}

class FeedbackStats {
  final String tag;
  final int count;

  FeedbackStats({required this.tag, required this.count});

  factory FeedbackStats.fromJson(Map<String, dynamic> json) {
    return FeedbackStats(tag: json["tag"], count: json["count"]);
  }
}
