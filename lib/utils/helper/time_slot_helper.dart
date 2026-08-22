class TimeSlotHelper {
  /// Generates hourly labels between [openTime] and [closeTime] ("HH:mm" 24h).
  /// e.g. open "07:00", close "22:00" -> ["07:00", "08:00", ..., "21:00"]
  /// (closing hour itself excluded — no session can start exactly at close).
  static List<String> generateHourlySlots({
    required String? openTime,
    required String? closeTime,
  }) {
    if (openTime == null || closeTime == null) return [];

    final openHour = _parseHour(openTime);
    final closeHour = _parseHour(closeTime);

    if (openHour == null || closeHour == null || closeHour <= openHour) {
      return [];
    }

    return [
      for (int hour = openHour; hour < closeHour; hour++)
        '${hour.toString().padLeft(2, '0')}:00',
    ];
  }

  static int? _parseHour(String time) {
    final parts = time.split(':');
    if (parts.isEmpty) return null;
    return int.tryParse(parts[0]);
  }
}
