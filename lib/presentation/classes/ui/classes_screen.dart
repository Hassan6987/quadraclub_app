import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/classes/bloc/classes_bloc.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';
import 'package:quadraclub_app/presentation/classes/ui/class_details_screen.dart';
import 'package:quadraclub_app/presentation/classes/ui/widgets/filter_bottom_sheet.dart';
import 'package:quadraclub_app/presentation/common/widgets/common_chip.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

import '/app_exports.dart' hide TimeOfDay;

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final List<SportType> _selectedSports = [];

  DateTime? _selectedDate;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<TimeOfDay> _selectedTimes = {};
  LevelFilter _level = LevelFilter.all;
  FormatFilter _format = FormatFilter.all;
  double _distance = 25;
  String _city = '';

  List<DateTime> get _dates =>
      List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  List<Class> _filtered(List<Class> classes) {
    return classes.where((c) {
      // -------------------------
      // Sport
      // -------------------------
      final matchesSport =
          _selectedSports.isEmpty ||
          (c.sportName != null &&
              _selectedSports.contains(
                SportTypeExtension.fromString(c.sportName!),
              ));

      // -------------------------
      // Search
      // -------------------------
      final query = _searchQuery.toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          c.className.toLowerCase().contains(query) ||
          c.coachName.toLowerCase().contains(query) ||
          (c.locationName?.toLowerCase().contains(query) ?? false);

      // -------------------------
      // Date
      // -------------------------
      final matchesDate = c.date != null && _isSameDate(c.date!, _selectedDate);

      // -------------------------
      // Time of day
      // -------------------------
      final matchesTime =
          _selectedTimes.isEmpty ||
          _selectedTimes.contains(_timeOfDayFromClass(c));

      // -------------------------
      // Level
      // -------------------------
      final matchesLevel = _level == LevelFilter.all || _matchesLevel(c.level);

      // -------------------------
      // Format
      // -------------------------
      final matchesFormat = _matchesFormat(c.format);

      // -------------------------
      // Distance
      // -------------------------
      final matchesDistance =
          c.distanceKm == null ||
          _distance >= (double.tryParse(c.distanceKm.toString()) ?? 0);

      // -------------------------
      // City
      // -------------------------
      final matchesCity =
          _city.isEmpty ||
          (c.locationName?.toLowerCase().contains(_city.toLowerCase()) ??
              false) ||
          (c.court?.location?.toLowerCase().contains(_city.toLowerCase()) ??
              false);

      return matchesSport &&
          matchesSearch &&
          matchesDate &&
          matchesTime &&
          matchesLevel &&
          matchesFormat &&
          matchesDistance &&
          matchesCity;
    }).toList();
  }

  Map<String, List<Class>> _groupedClasses(List<Class> allClasses) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final tomorrow = today.add(const Duration(days: 1));

    final result = <String, List<Class>>{};

    for (final c in _filtered(allClasses)) {
      final classDate = c.date;

      if (classDate == null) {
        continue;
      }

      final dateOnly = DateTime(classDate.year, classDate.month, classDate.day);

      final String label;

      if (_isSameDate(dateOnly, today)) {
        label = 'Today, ${dateOnly.day} ${monthNames[dateOnly.month - 1]}';
      } else if (_isSameDate(dateOnly, tomorrow)) {
        label = 'Tomorrow, ${dateOnly.day} ${monthNames[dateOnly.month - 1]}';
      } else {
        label = '${dateOnly.day} ${monthNames[dateOnly.month - 1]}';
      }

      result.putIfAbsent(label, () => []).add(c);
    }

    return result;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCardColor,
      appBar: CustomAppBar(
        title: "Available Classes",
        centerTile: false,
        backgroundColor: kWhiteColor,
      ),
      body: BlocBuilder<ClassesBloc, ClassesState>(
        builder: (context, state) {
          if (state.status == ClassStats.loading) {
            return Center(child: CustomLoadingView());
          } else if (state.status != ClassStats.loading &&
              state.classes.isEmpty) {
            return Center(
              child: Text(
                'No classes found.',
                style: AppStyles.w600f18inter.copyWith(color: kDarkTextColor),
              ),
            );
          }

          final grouped = _groupedClasses(state.classes);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  border: Border(bottom: BorderSide(color: kBorderColor)),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 33,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (final sport in SportType.values) ...[
                            CommonChip(
                              label: sport.label,
                              isSelected: _selectedSports.contains(sport),
                              onTap: () => setState(() {
                                if (_selectedSports.contains(sport)) {
                                  _selectedSports.remove(sport);
                                } else {
                                  _selectedSports.add(sport);
                                }
                              }),
                            ).paddingOnly(
                              right: sport.index == SportType.values.length - 1
                                  ? 0
                                  : 6,
                            ),
                          ],
                        ],
                      ),
                    ).withPaddingSymmetric(16, 0),
                    12.heightBox,
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _searchController,
                            hintText: "Search by name...",
                            borderRadius: 100,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value.trim();
                              });
                            },
                          ),
                        ),
                        8.widthBox,
                        GestureDetector(
                          onTap: () async {
                            final result = await FilterBottomSheet.show(
                              context,
                              selectedTimes: _selectedTimes,
                              level: _level,
                              format: _format,
                              distance: _distance,
                              city: _city,
                            );

                            if (result == null) return;

                            setState(() {
                              _selectedTimes
                                ..clear()
                                ..addAll(result.selectedTimes);

                              _level = result.level;
                              _format = result.format;
                              _distance = result.distance;
                              _city = result.city;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: kBorderColor),
                            ),
                            child: SvgPicture.asset(
                              Assets.svg.filterLines.path,
                            ).withPaddingAll(8),
                          ),
                        ),
                      ],
                    ).withPaddingSymmetric(16, 0),
                    12.heightBox,

                    CommonDateSelectionRow(
                      dates: _dates,
                      selectedDate: _selectedDate,
                      onDateSelected: (d) => setState(() => _selectedDate = d),
                    ),
                    16.heightBox,
                  ],
                ),
              ),

              Expanded(
                child: grouped.isEmpty
                    ? Center(
                        child: Text(
                          'No classes found.',
                          style: AppStyles.w600f18inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                      )
                    : ListView(
                        children: [
                          for (final entry in grouped.entries) ...[
                            _dateGroupHeader(label: entry.key),
                            for (final classModel in entry.value)
                              ClassCard(
                                classModel: classModel,
                                onTap: () => _openDetails(classModel),
                              ),
                          ],
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openDetails(Class classModel) {
    // Gate: show login dialog for unauthenticated users
    final authState = context.read<AuthBloc>().state;
    if (authState.user == null) {
      LoginToBookDialog.show(
        context,
        title: 'Sign in to book this class',
        subtitle: 'Please log in or create an account to reserve your spot.',
      );
      return;
    }

    context.read<ClassesBloc>().add(FetchPortfolioBalance());
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClassDetailsScreen(classModel: classModel),
      ),
    );
  }

  Widget _dateGroupHeader({required String label}) {
    return Row(
      children: [
        SvgPicture.asset(Assets.svg.calendarBlank.path),
        4.widthBox,
        Text(
          label,
          style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
        ),
        6.widthBox,

        Expanded(child: Divider(color: kTextColor.withValues(alpha: 0.50))),
      ],
    ).withPaddingSymmetric(16, 12);
  }

  bool _isSameDate(DateTime a, DateTime? b) {
    if (b == null) {
      return true;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  TimeOfDay _timeOfDayFromClass(Class c) {
    switch (c.timeOfDay?.trim().toLowerCase()) {
      case 'morning':
        return TimeOfDay.morning;

      case 'afternoon':
        return TimeOfDay.afternoon;

      case 'night':
      case 'evening':
        return TimeOfDay.night;

      default:
        return TimeOfDay.morning;
    }
  }

  bool _matchesLevel(String? level) {
    if (_level == LevelFilter.all) {
      return true;
    }

    // TODO: Replace with actual selected levels
    // once you add the level-selection UI.
    return true;
  }

  bool _matchesFormat(String? format) {
    if (_format == FormatFilter.all) {
      return true;
    }

    if (format == null) {
      return false;
    }

    return format.trim().toLowerCase() == _format.name.toLowerCase();
  }
}
