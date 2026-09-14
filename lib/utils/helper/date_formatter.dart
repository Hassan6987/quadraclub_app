// Helper method to get formatted date string
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

String getFormattedDate(DateTime viewedDate) {
  final now = DateTime.now();
  final difference = now.difference(viewedDate);

  if (difference.inDays == 0) {
    return 'Today';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return months == 1 ? '1 month ago' : '$months months ago';
  } else {
    final years = (difference.inDays / 365).floor();
    return years == 1 ? '1 year ago' : '$years years ago';
  }
}

String getFormatDateMonth(DateTime? date) {
  if (date == null) return '—';
  return DateFormat('d MMM').format(date);
}

String getFormatDateMonthYear(DateTime? date) {
  if (date == null) return '—';
  return DateFormat('d MMM, yyyy').format(date);
}

double getDistanceKm({
  required double? fromLat,
  required double? fromLng,
  required double? toLat,
  required double? toLng,
}) {
  if (fromLat == null || fromLng == null || toLat == null || toLng == null) {
    return double.infinity;
  }
  return Geolocator.distanceBetween(fromLat, fromLng, toLat, toLng) / 1000.0;
}

/// Formats a km distance for display, e.g. "2.4 km away" or "—" when unknown.
String formatDistanceKm(double distanceKm) {
  if (distanceKm.isInfinite || distanceKm.isNaN) return '—';
  return '${distanceKm.toStringAsFixed(1)} miles';
}
