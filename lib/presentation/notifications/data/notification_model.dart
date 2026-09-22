class NotificationModel {
  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.recipient,
    required this.createdBy,
    required this.isRead,
    required this.sendOn,
    required this.link,
    required this.priority,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String id;
  final String title;
  final String message;
  final String type;
  final String recipient;
  final String createdBy;
  final bool isRead;
  final DateTime? sendOn;
  final String link;
  final String priority;
  final Metadata? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    String? recipient,
    String? createdBy,
    bool? isRead,
    DateTime? sendOn,
    String? link,
    String? priority,
    Metadata? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      recipient: recipient ?? this.recipient,
      createdBy: createdBy ?? this.createdBy,
      isRead: isRead ?? this.isRead,
      sendOn: sendOn ?? this.sendOn,
      link: link ?? this.link,
      priority: priority ?? this.priority,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json){
    return NotificationModel(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      message: json["message"] ?? "",
      type: json["type"] ?? "",
      recipient: json["recipient"] ?? "",
      createdBy: json["createdBy"] ?? "",
      isRead: json["isRead"] ?? false,
      sendOn: DateTime.tryParse(json["sendOn"] ?? ""),
      link: json["link"] ?? "",
      priority: json["priority"] ?? "",
      metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"] ?? 0,
    );
  }

}

class Metadata {
  Metadata({
    required this.bookingId,
    required this.action,
  });

  final String bookingId;
  final String action;

  Metadata copyWith({
    String? bookingId,
    String? action,
  }) {
    return Metadata(
      bookingId: bookingId ?? this.bookingId,
      action: action ?? this.action,
    );
  }

  factory Metadata.fromJson(Map<String, dynamic> json){
    return Metadata(
      bookingId: json["bookingId"] ?? "",
      action: json["action"] ?? "",
    );
  }

}
