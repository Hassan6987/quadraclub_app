import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:quadraclub_app/l10n/app_localizations.dart';

String getFormattedDate(DateTime viewedDate, [AppLocalizations? l10n]) {
  final now = DateTime.now();
  final difference = now.difference(viewedDate);

  if (difference.inDays == 0) {
    return l10n?.todayLabel ?? 'Today';
  } else if (difference.inDays == 1) {
    return l10n?.yesterdayLabel ?? 'Yesterday';
  } else if (difference.inDays < 7) {
    return l10n?.daysAgo(difference.inDays) ?? '${difference.inDays} days ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return l10n?.weeksAgo(weeks) ??
        (weeks == 1 ? '1 week ago' : '$weeks weeks ago');
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return l10n?.monthsAgo(months) ??
        (months == 1 ? '1 month ago' : '$months months ago');
  } else {
    final years = (difference.inDays / 365).floor();
    return l10n?.yearsAgo(years) ??
        (years == 1 ? '1 year ago' : '$years years ago');
  }
}

String getFormatDateMonth(DateTime? date, {String? locale}) {
  if (date == null) return '—';
  return DateFormat('d MMM', locale).format(date);
}

String getFormatDateMonthYear(DateTime? date, {String? locale}) {
  if (date == null) return '—';
  return DateFormat('d MMM, yyyy', locale).format(date);
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

/// Formats a km distance for display, e.g. "2.4 km" or "—" when unknown.
String formatDistanceKm(double distanceKm, [AppLocalizations? l10n]) {
  if (distanceKm.isInfinite || distanceKm.isNaN) return '—';
  final value = distanceKm.toStringAsFixed(1);
  return l10n?.formattedDistanceKm(value) ?? '$value km';
}
