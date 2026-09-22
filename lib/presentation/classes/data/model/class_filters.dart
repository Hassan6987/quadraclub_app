import 'package:quadraclub_app/presentation/classes/ui/widgets/filter_bottom_sheet.dart';
import 'package:quadraclub_app/utils/const/filter_options.dart';

class ClassFilterResult {
  final Set<TimeOfDayFilter> selectedTimes;
  final GenderFilter gender;
  final Set<SportLevel> levels;
  final FormatFilter format;
  final double distance;
  final String city;

  const ClassFilterResult({
    required this.selectedTimes,
    required this.gender,
    required this.levels,
    required this.format,
    required this.distance,
    required this.city,
  });
}
