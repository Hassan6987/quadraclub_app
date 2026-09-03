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
  final int? portfolioBalance;

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
    int? portfolioBalance,
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
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json){
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
      sportsInfo: json["sportsInfo"] == null ? [] : List<SportsInfo>.from(
          json["sportsInfo"]!.map((x) => SportsInfo.fromJson(x))),
      registrationStep: json["registrationStep"],
      portfolioBalance: json["portfolioBalance"],
    );
  }

}

class SportsInfo {
  SportsInfo({
    required this.sport,
    required this.category,
  });

  final String? sport;
  final String? category;

  SportsInfo copyWith({
    String? sport,
    String? category,
  }) {
    return SportsInfo(
      sport: sport ?? this.sport,
      category: category ?? this.category,
    );
  }

  factory SportsInfo.fromJson(Map<String, dynamic> json){
    return SportsInfo(
      sport: json["sport"],
      category: json["category"],
    );
  }

}