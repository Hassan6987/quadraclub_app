class NoteModel {
  final int? id;
  final String? note;
  final String? type;
  final String? provider;
  final String? receiver;
  final DateTime? createdAt;

  NoteModel({
    this.id,
    this.note,
    this.type,
    this.provider,
    this.receiver,
    this.createdAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json["id"],
      note: json["note"],
      type: json["type"],
      provider: json["provider"],
      receiver: json["receiver"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }
}
