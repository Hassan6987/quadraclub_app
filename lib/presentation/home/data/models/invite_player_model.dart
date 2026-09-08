class InvitePlayerModel {
  InvitePlayerModel({
    required this.id,
    required this.name,
    required this.profilePhoto,
  });

  final String id;
  final String name;
  final String profilePhoto;

  InvitePlayerModel copyWith({String? id, String? name, String? profilePhoto}) {
    return InvitePlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }

  factory InvitePlayerModel.fromJson(Map<String, dynamic> json) {
    return InvitePlayerModel(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      profilePhoto: json["profilePhoto"] ?? '',
    );
  }
}
