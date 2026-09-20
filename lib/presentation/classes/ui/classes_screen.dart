import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
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
  LatLng _currentLatLng = const LatLng(51.5072, -0.1276);

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
    final l10n = AppLocalizations.of(context)!;

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

      final date = DateFormat('d MMM', l10n.localeName).format(dateOnly);

      final String label;

      if (_isSameDate(dateOnly, today)) {
        label = l10n.todayWithDate(date);
      } else if (_isSameDate(dateOnly, tomorrow)) {
        label = l10n.tomorrowWithDate(date);
      } else {
        label = date;
      }

      result.putIfAbsent(label, () => []).add(c);
    }

    return result;
  }

  Future<void> _initUserLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final pos =
            await Geolocator.getLastKnownPosition() ??
            await Geolocator.getCurrentPosition(
              timeLimit: const Duration(seconds: 5),
            );
        if (mounted) {
          setState(() {
            _currentLatLng = LatLng(pos.latitude, pos.longitude);
          });
        }
      }
    } catch (_) {}
  }

  double _clubDistance(Class club) {
    if (club.court?.coordinates?.latitude == null ||
        club.court?.coordinates?.longitude == null) {
      return double.infinity;
    }
    return Geolocator.distanceBetween(
          _currentLatLng.latitude,
          _currentLatLng.longitude,
          club.court!.coordinates!.latitude!,
          club.court!.coordinates!.longitude!,
        ) /
        1000.0;
  }

  @override
  void initState() {
    // TODO: implement initState
    _initUserLocation();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: kCardColor,
      appBar: CustomAppBar(
        title: l10n.availableClasses,
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
                l10n.noClassesFound,
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
                              label: sport.localizedLabel(context),
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
                            hintText: l10n.searchByName,
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
                          l10n.noClassesFound,
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
                                distanceKm: _clubDistance(classModel),
                                onTap: () => _openDetails(
                                  classModel,
                                  _clubDistance(classModel),
                                ),
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

  void _openDetails(Class classModel, double distance) {
    final l10n = AppLocalizations.of(context)!;

    // Gate: show login dialog for unauthenticated users
    final authState = context.read<AuthBloc>().state;

    if (authState.user == null) {
      LoginToBookDialog.show(
        context,
        title: l10n.signInToBookThisClass,
        subtitle: l10n.loginToReserveYourSpot,
      );
      return;
    }

    context.read<ClassesBloc>().add(FetchPortfolioBalance());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            ClassDetailsScreen(classModel: classModel, distanceKm: distance),
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
