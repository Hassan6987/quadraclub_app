class FeeTier {
  const FeeTier({
    required this.full,
    required this.current,
    required this.discount,
    required this.strikeThrough,
  });

  final double full;
  final double current;
  final double discount;
  final bool strikeThrough;

  static const zero = FeeTier(
    full: 0,
    current: 0,
    discount: 0,
    strikeThrough: false,
  );

  /// Show the full amount struck through when the user pays less than full.
  bool get showStrikeThrough => current < full;

  factory FeeTier.fromJson(Map<String, dynamic>? json) {
    if (json == null) return FeeTier.zero;
    return FeeTier(
      full: (json['full'] as num?)?.toDouble() ?? 0,
      current: (json['current'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      strikeThrough: json['strikeThrough'] == true,
    );
  }
}

class ServiceFees {
  const ServiceFees({
    required this.matches,
    required this.courts,
    required this.classes,
    this.updatedAt,
  });

  final FeeTier matches;
  final FeeTier courts;
  final FeeTier classes;
  final DateTime? updatedAt;

  static const empty = ServiceFees(
    matches: FeeTier.zero,
    courts: FeeTier.zero,
    classes: FeeTier.zero,
  );

  factory ServiceFees.fromJson(Map<String, dynamic> json) {
    final root = json['serviceFees'] is Map<String, dynamic>
        ? json['serviceFees'] as Map<String, dynamic>
        : json;

    return ServiceFees(
      matches: FeeTier.fromJson(root['matches'] as Map<String, dynamic>?),
      courts: FeeTier.fromJson(root['courts'] as Map<String, dynamic>?),
      classes: FeeTier.fromJson(root['classes'] as Map<String, dynamic>?),
      updatedAt: root['updatedAt'] != null
          ? DateTime.tryParse(root['updatedAt'].toString())
          : null,
    );
  }
}
