class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? imageUrl;
  final String? role;
  final bool isVerified;

  UserModel(
      {this.id, this.email, this.name, this.imageUrl, this.role, this.isVerified = true});

  UserModel copyWith(
      {String? id, String? email, String? name, String? imageUrl, String? role, bool? isVerified}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json["_id"],
        name: json["fullName"],
      email: json["email"],
        imageUrl: json['profilePhoto'],
      role: json["role"],
        isVerified: json['isVerified']
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": name,
    "email": email,
    "profilePhoto": imageUrl,
    "role": role,
    "isVerified": isVerified
  };
}