import 'package:quadraclub_app/presentation/classes/ui/widgets/filter_bottom_sheet.dart';

class ClassFilterResult {
  final Set<TimeOfDay> selectedTimes;
  final LevelFilter level;
  final FormatFilter format;
  final double distance;
  final String city;

  const ClassFilterResult({
    required this.selectedTimes,
    required this.level,
    required this.format,
    required this.distance,
    required this.city,
  });
}
