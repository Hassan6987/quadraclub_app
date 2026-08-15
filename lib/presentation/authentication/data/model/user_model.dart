class UserModel {
  final int? id;
  final String? email;
  final String? role;
  final Profile? profile;

  UserModel({this.id, this.email, this.role, this.profile});

  UserModel copyWith({int? id, String? email, String? role, Profile? profile}) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      profile: profile ?? this.profile,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      email: json["email"],
      role: json["role"],
      profile: json["profile"] == null
          ? null
          : Profile.fromJson(json["profile"]),
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      email: json["email"],
      role: json["role"],
      profile: json["profile"] == null ? null : Profile.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "role": role,
    "profile": profile?.toJson(),
  };
}

class Profile {
  final int? id;
  final String? fullName;
  final String? collegeName;
  final String? status;
  final String? image;
  final List<UserLink>? links;

  Profile({
    this.id,
    this.fullName,
    this.collegeName,
    this.status,
    this.image,
    this.links,
  });

  Profile copyWith({
    int? id,
    String? fullName,
    String? collegeName,
    String? status,
    String? image,
    List<UserLink>? links,
  }) {
    return Profile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      collegeName: collegeName ?? this.collegeName,
      status: status ?? this.status,
      image: image ?? this.image,
      links: links ?? this.links,
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json["id"],
      fullName: json["full_name"],
      collegeName: json["college_name"],
      status: json["status"],
      image: json["image"],
      links: json["links"] == null
          ? []
          : List<UserLink>.from(
              json["links"]!.map((x) => UserLink.fromJson(x)),
            ),
    );
  }

  factory Profile.fromMap(Map<String, dynamic> json) {
    return Profile(
      id: json["id"],
      fullName: json["full_name"],
      status: json['status'],
      collegeName: json["college_name"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "college_name": collegeName,
    "image": image,
  };
}

class UserLink {
  final int? id;
  final dynamic title;
  final String? url;
  final DateTime? createdAt;

  UserLink({
    required this.id,
    required this.title,
    required this.url,
    required this.createdAt,
  });

  factory UserLink.fromJson(Map<String, dynamic> json) {
    return UserLink(
      id: json["id"],
      title: json["title"],
      url: json["url"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }
}
