class MetricType {
  MetricType({
    required this.id,
    required this.name,
    required this.displayName,
    required this.unit,
  });

  final int id;
  final String name;
  final String displayName;
  final String unit;

  factory MetricType.fromJson(Map<String, dynamic> json) {
    return MetricType(
      id: json["id"],
      name: json["name"],
      displayName: json["display_name"],
      unit: json["unit"],
    );
  }
}

class AthleteMetric {
  AthleteMetric({
    required this.id,
    required this.metricType,
    required this.value,
    required this.eventName,
    required this.eventDate,
    required this.notes,
    required this.recordedAt,
  });

  final int id;
  final MetricType metricType;
  final double value;
  final String eventName;
  final DateTime eventDate;
  final String? notes;
  final DateTime recordedAt;

  factory AthleteMetric.fromJson(Map<String, dynamic> json) {
    return AthleteMetric(
      id: json["id"],
      metricType: MetricType.fromJson(json["metric_type"]),
      value: (json["value"] as num).toDouble(),
      eventName: json["event_name"],
      eventDate: DateTime.parse(json["event_date"]),
      notes: json["notes"],
      recordedAt: DateTime.parse(json["recorded_at"]),
    );
  }
}

class MetricTimeline {
  MetricTimeline({required this.metricType, required this.timelineData});

  final MetricType metricType;
  final List<AthleteMetric> timelineData;

  factory MetricTimeline.fromJson(Map<String, dynamic> json) {
    return MetricTimeline(
      metricType: MetricType.fromJson(json["metric_type"]),
      timelineData: List<AthleteMetric>.from(
        json["timeline_data"].map((x) => AthleteMetric.fromJson(x)),
      ),
    );
  }

  double? get bestValue {
    if (timelineData.isEmpty) return null;
    return timelineData.reduce((a, b) => a.value > b.value ? a : b).value;
  }

  double? get latestValue {
    if (timelineData.isEmpty) return null;
    return timelineData.last.value;
  }
}
