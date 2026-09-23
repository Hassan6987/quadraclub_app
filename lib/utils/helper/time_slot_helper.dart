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

  /// True when [slotStart] ("HH:mm") on [date] is already in the past.
  ///
  /// Future calendar days are never past. Today's slots whose start is
  /// strictly before [now] (default: wall clock) count as past.
  static bool isSlotInPast(DateTime date, String? slotStart, {DateTime? now}) {
    if (slotStart == null || slotStart.trim().isEmpty) return true;

    final parts = slotStart.trim().split(':');
    if (parts.length < 2) return true;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return true;

    final clock = now ?? DateTime.now();
    final day = DateTime(date.year, date.month, date.day);
    final today = DateTime(clock.year, clock.month, clock.day);

    if (day.isAfter(today)) return false;
    if (day.isBefore(today)) return true;

    final slotAt = DateTime(date.year, date.month, date.day, hour, minute);
    return !slotAt.isAfter(clock);
  }

  static int? _parseHour(String time) {
    final parts = time.split(':');
    if (parts.isEmpty) return null;
    return int.tryParse(parts[0]);
  }
}
