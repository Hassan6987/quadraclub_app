class NotificationModel {
  final int? id;
  final String title;
  final String content;
  final DateTime? createdAt;

  NotificationModel({
    this.id,
    required this.title,
    required this.content,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "content": content};
  }
}
