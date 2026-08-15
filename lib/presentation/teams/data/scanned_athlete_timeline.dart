class TimelineDataPoint {
  final String eventName;
  final String eventDate;
  final double value;
  final String? notes;

  TimelineDataPoint({
    required this.eventName,
    required this.eventDate,
    required this.value,
    this.notes,
  });

  factory TimelineDataPoint.fromJson(Map<String, dynamic> json) {
    return TimelineDataPoint(
      eventName: json['event_name'] as String,
      eventDate: json['event_date'] as String,
      value: (json['value'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }
}

class AthleteTimeline {
  final int metricId;
  final String name;
  final String unit;
  final String displayName;
  final String description;
  final List<TimelineDataPoint> timelineData;

  AthleteTimeline({
    required this.metricId,
    required this.name,
    required this.unit,
    required this.displayName,
    required this.description,
    required this.timelineData,
  });

  factory AthleteTimeline.fromJson(Map<String, dynamic> json) {
    final metricType = json['metric_type'] as Map<String, dynamic>;
    final List rawTimeline = json['timeline_data'] as List? ?? [];

    return AthleteTimeline(
      metricId: metricType['id'] as int,
      name: metricType['name'] as String,
      unit: metricType['unit'] as String,
      displayName: metricType['display_name'] as String,
      description: metricType['description'] as String,
      timelineData: rawTimeline
          .map((e) => TimelineDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
