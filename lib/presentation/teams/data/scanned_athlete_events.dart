class RecordedMetric {
  final int metricId;
  final String metricName;
  final String displayName;
  final String unit;
  final double value;
  final String? notes;

  RecordedMetric({
    required this.metricId,
    required this.metricName,
    required this.displayName,
    required this.unit,
    required this.value,
    this.notes,
  });

  factory RecordedMetric.fromJson(Map<String, dynamic> json) {
    final metricType = json['metric_type'] as Map<String, dynamic>;
    return RecordedMetric(
      metricId: metricType['id'] as int,
      metricName: metricType['name'] as String,
      displayName: metricType['display_name'] as String,
      unit: metricType['unit'] as String,
      value: (json['value'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }
}

class CompletedEvent {
  final String eventId;
  final String name;
  final String eventType;
  final String eventDate;
  final String startTime;
  final String endTime;
  final String location;
  final List<RecordedMetric> metrics;

  CompletedEvent({
    required this.eventId,
    required this.name,
    required this.eventType,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.metrics,
  });

  factory CompletedEvent.fromEventJson(
    Map<String, dynamic> eventJson,
    List<RecordedMetric> metrics,
  ) {
    return CompletedEvent(
      eventId: eventJson['event_id'] as String,
      name: eventJson['name'] as String,
      eventType: eventJson['event_type'] as String,
      eventDate: eventJson['event_date'] as String,
      startTime: eventJson['start_time'] as String,
      endTime: eventJson['end_time'] as String,
      location: eventJson['location'] as String,
      metrics: metrics,
    );
  }
}
