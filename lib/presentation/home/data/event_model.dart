class EventModel {
  EventModel({
    required this.id,
    required this.name,
    required this.eventType,
    required this.description,
    required this.location,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.metricTypeIds,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String eventType; // SHOWCASE, CAMP, TOURNAMENT, etc.
  final String? description;
  final String location;
  final DateTime eventDate;
  final String startTime;
  final String endTime;
  final List<int> metricTypeIds;
  final DateTime createdAt;

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json["id"],
      name: json["name"],
      eventType: json["event_type"],
      description: json["description"],
      location: json["location"],
      eventDate: DateTime.parse(json["event_date"]),
      startTime: json["start_time"],
      endTime: json["end_time"],
      metricTypeIds: List<int>.from(json["metric_type_ids"] ?? []),
      createdAt: DateTime.parse(json["created_at"]),
    );
  }
}

class EventAttendee {
  EventAttendee({
    required this.id,
    required this.athleteId,
    required this.athleteName,
    required this.athleteImage,
    required this.checkedInAt,
    required this.status,
  });

  final int id;
  final int athleteId;
  final String athleteName;
  final String? athleteImage;
  final DateTime checkedInAt;
  final String status; // CHECKED_IN, NOT_CHECKED_IN

  factory EventAttendee.fromJson(Map<String, dynamic> json) {
    return EventAttendee(
      id: json["id"],
      athleteId: json["athlete_id"],
      athleteName: json["athlete_name"],
      athleteImage: json["athlete_image"],
      checkedInAt: DateTime.parse(json["checked_in_at"]),
      status: json["status"],
    );
  }
}

class EventWithAttendees {
  EventWithAttendees({required this.event, required this.attendees});

  final EventModel event;
  final List<EventAttendee> attendees;

  factory EventWithAttendees.fromJson(Map<String, dynamic> json) {
    return EventWithAttendees(
      event: EventModel.fromJson(json["event"]),
      attendees: List<EventAttendee>.from(
        json["attendees"].map((x) => EventAttendee.fromJson(x)),
      ),
    );
  }
}

class EventParticipation {
  EventParticipation({
    required this.eventName,
    required this.date,
    required this.location,
    required this.score,
  });

  final String eventName;
  final String date;
  final String location;
  final String score;
}
