import 'package:intl/intl.dart';

String formatCredits(int? credits) {
  final int value = credits ?? 0;

  // Format with commas, e.g. 7,300 or 123,456
  final formatted = NumberFormat('#,###').format(value);

  // Add the bullet (•) at the end
  return '$formatted•';
}
