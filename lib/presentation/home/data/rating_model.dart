class RatingModel {
  final int? id;
  final int? user;
  final RatedBy? ratedBy;
  final int? rating;
  final DateTime? createdAt;

  RatingModel({this.id, this.user, this.ratedBy, this.rating, this.createdAt});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json["id"],
      user: json["user"],
      ratedBy: json["rated_by"] == null
          ? null
          : RatedBy.fromJson(json["rated_by"]),
      rating: json["rating"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }
}

class RatedBy {
  final int? providedBy;

  RatedBy({this.providedBy});

  factory RatedBy.fromJson(Map<String, dynamic> json) {
    return RatedBy(providedBy: json["provided_by"]);
  }
}
