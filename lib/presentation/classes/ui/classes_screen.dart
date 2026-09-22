import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/classes/bloc/classes_bloc.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';
import 'package:quadraclub_app/presentation/classes/ui/class_details_screen.dart';
import 'package:quadraclub_app/presentation/classes/ui/widgets/filter_bottom_sheet.dart';
import 'package:quadraclub_app/presentation/home/bloc/courts_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/models/location_result.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_map_view.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

import '/app_exports.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final Set<String> _selectedSports = {};

  bool _isMapView = false;
  String _currentLocation = 'London, UK';

  late final DateTime _anchorDate;
  DateTime? _selectedDate;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  LatLng _currentLatLng = const LatLng(51.5072, -0.1276);

  final Set<TimeOfDayFilter> _selectedTimes = {};
  GenderFilter _gender = GenderFilter.misto;
  Set<SportLevel> _levels = {};
  FormatFilter _format = FormatFilter.all;

  /// Level sections follow the header's sport selection; with nothing
  /// selected every sport is on the table.
  List<String> get _levelSports =>
      _selectedSports.isEmpty ? kAllSportSlugs : _selectedSports.toList();

  static const double _defaultDistance = 25;
  double _distance = _defaultDistance;
  String _city = '';

  List<DateTime> get _dates =>
      List.generate(14, (i) => _anchorDate.add(Duration(days: i)));

  bool get _hasActiveFilters =>
      _selectedTimes.isNotEmpty ||
      _gender != GenderFilter.misto ||
      _levels.isNotEmpty ||
      _format != FormatFilter.all ||
      _distance != _defaultDistance ||
      _city.isNotEmpty;

  List<Class> _filtered(List<Class> classes) {
    return classes.where((c) {
      // -------------------------
      // Sport
      // -------------------------
      final matchesSport =
          _selectedSports.isEmpty ||
          _selectedSports.contains(sportSlug(c.sportName));

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
      final matchesLevel = matchesSelectedLevels(
        _levels,
        sport: c.sportName,
        level: c.level,
      );

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
    final now = DateTime.now();
    _anchorDate = DateTime(now.year, now.month, now.day);
    _initUserLocation();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSport(String sport) {
    setState(() {
      if (_selectedSports.contains(sport)) {
        _selectedSports.remove(sport);
      } else {
        _selectedSports.add(sport);
      }
    });
  }

  List<Widget> _activeFilterBadges(AppLocalizations l10n) {
    return [
      for (final time in _selectedTimes)
        HeaderFilterBadge(
          label: time.label(context),
          icon: Icons.access_time,
          onClear: () => setState(() => _selectedTimes.remove(time)),
        ),
      if (_gender != GenderFilter.misto)
        HeaderFilterBadge(
          label: _gender.label(context),
          icon: Icons.people_outline,
          onClear: () => setState(() => _gender = GenderFilter.misto),
        ),
      for (final level in _levels)
        HeaderFilterBadge(
          label: localizedLevelName(context, level.level),
          icon: Icons.bar_chart,
          onClear: () => setState(() => _levels = {..._levels}..remove(level)),
        ),
      if (_format != FormatFilter.all)
        HeaderFilterBadge(
          label: _format == FormatFilter.group ? l10n.group : l10n.individual,
          icon: Icons.groups_outlined,
          onClear: () => setState(() => _format = FormatFilter.all),
        ),
      if (_city.isNotEmpty)
        HeaderFilterBadge(
          label: _city,
          icon: Icons.location_city,
          onClear: () => setState(() => _city = ''),
        ),
      if (_distance != _defaultDistance)
        HeaderFilterBadge(
          label: l10n.distanceKm(_distance.round().toString()),
          icon: Icons.near_me_outlined,
          onClear: () => setState(() => _distance = _defaultDistance),
        ),
      HeaderClearAllButton(
        onTap: () => setState(() {
          _selectedTimes.clear();
          _gender = GenderFilter.misto;
          _levels = {};
          _format = FormatFilter.all;
          _distance = _defaultDistance;
          _city = '';
        }),
      ),
    ];
  }

  Future<void> _openFilters() async {
    final result = await FilterBottomSheet.show(
      context,
      selectedTimes: _selectedTimes,
      gender: _gender,
      levels: _levels,
      sports: _levelSports,
      format: _format,
      distance: _distance,
      city: _city,
    );

    if (result == null) return;

    setState(() {
      _selectedTimes
        ..clear()
        ..addAll(result.selectedTimes);

      _gender = result.gender;
      _levels = result.levels;
      _format = result.format;
      _distance = result.distance;
      _city = result.city;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isMapView) {
      return CourtMapView(
        courts: context.read<CourtsBloc>().state.courts,
        currentLocation: _currentLocation,
        initialCenter: _currentLatLng,
        onLocationChanged: (LocationResult location) {
          setState(() {
            _currentLocation = location.address;
            _currentLatLng = LatLng(location.latitude, location.longitude);
          });
        },
        onBackToList: () => setState(() => _isMapView = false),
        filterTimes: _selectedTimes,
        filterCity: _city.isEmpty ? null : _city,
        filterDistance: _distance,
        onApplyFilters: (times, city, dist) {
          setState(() {
            _selectedTimes
              ..clear()
              ..addAll(times);
            _city = city ?? '';
            _distance = dist ?? _defaultDistance;
          });
        },
        selectedSports: _selectedSports,
        onSportSelected: _toggleSport,
      );
    }

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
              DiscoveryHeader(
                selectedSports: _selectedSports,
                onSportToggled: _toggleSport,
                searchController: _searchController,
                searchHint: l10n.searchByName,
                onSearchChanged: (value) =>
                    setState(() => _searchQuery = value.trim()),
                hasActiveFilters: _hasActiveFilters,
                activeFilterBadges: _hasActiveFilters
                    ? _activeFilterBadges(l10n)
                    : const [],
                onFilterTap: _openFilters,
                onMapTap: () => setState(() => _isMapView = true),
                dates: _dates,
                selectedDate: _selectedDate,
                onDateSelected: (d) => setState(() => _selectedDate = d),
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

  /// Prefers the explicit `timeOfDay` the API sends, falling back to the
  /// bucket the class's start time lands in.
  TimeOfDayFilter? _timeOfDayFromClass(Class c) {
    final explicit = timeOfDayFilterFrom(c.timeOfDay);
    if (explicit != null) return explicit;

    final hour = parseHour(c.startTime);
    if (hour == null) return null;

    return TimeOfDayFilter.values.firstWhere((t) => t.containsHour(hour));
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
