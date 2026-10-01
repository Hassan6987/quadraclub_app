import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/classes/bloc/classes_bloc.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';
import 'package:quadraclub_app/presentation/classes/ui/class_details_screen.dart';
import 'package:quadraclub_app/presentation/classes/ui/widgets/class_map_view.dart';
import 'package:quadraclub_app/presentation/classes/ui/widgets/filter_bottom_sheet.dart';
import 'package:quadraclub_app/presentation/home/data/models/location_result.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/helper/date_formatter.dart';

import '/app_exports.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  bool _isMapView = false;
  String _currentLocation = 'London, UK';

  late final DateTime _anchorDate;

  /// The highlighted day in the strip. Starts on today and only changes when
  /// the user taps an available day — it navigates the list, it never filters
  /// it.
  late DateTime _selectedDate;

  /// One key per rendered day section, so tapping a day can scroll the list
  /// to it.
  final Map<String, GlobalKey> _sectionKeys = {};
  /// True while a date tap is animating the list, so the scroll listener
  /// doesn't overwrite the date the user just picked.
  bool _isAutoScrolling = false;
  /// Day sections in display order. Refreshed on every build.
  List<({String label, DateTime date})> _sectionDates = [];
  final ScrollController _listController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  LatLng _currentLatLng = const LatLng(51.5072, -0.1276);

  final Set<TimeOfDayFilter> _selectedTimes = {};
  GenderFilter _gender = GenderFilter.misto;
  Set<SportLevel> _levels = {};
  FormatFilter _format = FormatFilter.all;

  /// Level sections follow the header's sport selection.
  List<String> get _levelSports => _selectedSports.toList();

  Set<String> get _selectedSports =>
      context.watch<DiscoverySportFilter>().selected;

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
        final matchesSport = _selectedSports.contains(sportSlug(c.sportName));

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
        // Past days are never listed: the strip starts on today. The selected
        // day does not filter anything — tapping it only scrolls the list.
        final classDate = c.date;
        if (classDate == null) {
          return false;
        }
        if (DateTime(
          classDate.year,
          classDate.month,
          classDate.day,
        ).isBefore(_anchorDate)) {
          return false;
        }

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
            matchesTime &&
            matchesLevel &&
            matchesFormat &&
            matchesDistance &&
            matchesCity;
      }).toList()
      // Chronological, so the day sections run in the same order as the strip.
      ..sort((a, b) {
        final aDate = a.date;
        final bDate = b.date;

        if (aDate != null && bDate != null) {
          final byDay = DateTime(
            aDate.year,
            aDate.month,
            aDate.day,
          ).compareTo(DateTime(bDate.year, bDate.month, bDate.day));

          if (byDay != 0) return byDay;
        }

        return (a.startTime ?? '').compareTo(b.startTime ?? '');
      });
  }

  Map<String, List<Class>> _groupedClasses(List<Class> classes) {
    final l10n = AppLocalizations.of(context)!;
    final result = <String, List<Class>>{};

    for (final classModel in classes) {
      final date = classModel.date;

      if (date == null) {
        continue;
      }

      final label = _daySectionLabel(date, l10n);

      result.putIfAbsent(label, () => []).add(classModel);
    }

    return result;
  }

  /// `yyyy-MM-dd` keys of the days that still have a class once every other
  /// filter has been applied — the strip greys the empty ones out.
  Set<String> _availableDateKeys(List<Class> classes) {
    final keys = <String>{};

    for (final classModel in classes) {
      final date = classModel.date;
      if (date == null) continue;

      keys.add(dateKey(DateTime(date.year, date.month, date.day)));
    }

    return keys;
  }

  /// The label a day section is rendered with — also the key its [GlobalKey]
  /// is filed under, which is how tapping a date finds its section.
  String _daySectionLabel(DateTime date, AppLocalizations l10n) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final formatted = DateFormat('d MMM', l10n.localeName).format(dateOnly);

    if (_isSameDate(dateOnly, today)) {
      return l10n.todayWithDate(formatted);
    }

    if (_isSameDate(dateOnly, today.add(const Duration(days: 1)))) {
      return l10n.tomorrowWithDate(formatted);
    }

    return formatted;
  }

  /// Smoothly scrolls the list to the section of [date]. The strip only lets
  /// days with a section be tapped, so the key is always there.
  Future<void> _scrollToDay(DateTime date) async {
    final l10n = AppLocalizations.of(context)!;
    final sectionContext =
        _sectionKeys[_daySectionLabel(date, l10n)]?.currentContext;

    if (sectionContext == null) return;

    _isAutoScrolling = true;
    try {
      await Scrollable.ensureVisible(
        sectionContext,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        alignment: 0,
      );
    } finally {
      _isAutoScrolling = false;
    }
  }

  void _onListScroll() {
    if (_isAutoScrolling || !_listController.hasClients) return;
    if (_sectionDates.isEmpty) return;

    final position = _listController.position;

    DateTime? active;

    if (position.pixels <= 0) {
      active = _sectionDates.first.date;
    } else if (position.pixels >= position.maxScrollExtent - 1) {
      active = _sectionDates.last.date;
    } else {
      final viewportBox =
      position.context.storageContext.findRenderObject() as RenderBox?;
      if (viewportBox == null || !viewportBox.attached) return;

      final viewportTop = viewportBox.localToGlobal(Offset.zero).dy;

      // The active day is the last section whose header has reached the top.
      for (final section in _sectionDates) {
        final box =
        _sectionKeys[section.label]?.currentContext?.findRenderObject()
        as RenderBox?;
        if (box == null || !box.attached) continue;

        final headerTop = box.localToGlobal(Offset.zero).dy;
        if (headerTop <= viewportTop + 24) {
          active = section.date;
        } else {
          break;
        }
      }
      active ??= _sectionDates.first.date;
    }

    // Only update if the day exists in the date strip and actually changed.
    final inStrip = _dates.any((d) => _isSameDate(d, active));
    if (inStrip && !_isSameDate(_selectedDate, active)) {
      setState(() => _selectedDate = active!);
    }
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

  /// If multiple classes exist in the same city, the nearest
  /// class/court in that city is used.
  Map<String, double> _buildCityDistances(List<Class> classes) {
    final cityDistances = <String, double>{};
    for (final classModel in classes) {
      final city = classModel.court?.city.trim();
      if (city == null || city.isEmpty) {
        continue;
      }
      final distance = _clubDistance(classModel);
      if (distance.isInfinite || distance.isNaN) {
        continue;
      }
      final existingDistance = cityDistances[city];
      if (existingDistance == null || distance < existingDistance) {
        cityDistances[city] = distance;
      }
    }
    return cityDistances;
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _anchorDate = DateTime(now.year, now.month, now.day);
    _selectedDate = _anchorDate;
    _listController.addListener(_onListScroll);
    context.read<DiscoverySportFilter>().ensureInitialized(
      context.read<AuthBloc>().state.user?.sportsInfo.map((s) => s.sport) ??
          const [],
    );
    _initUserLocation();
  }

  @override
  void dispose() {
    _listController.removeListener(_onListScroll);
    _searchController.dispose();
    _listController.dispose();
    super.dispose();
  }

  void _toggleSport(String sport) {
    context.read<DiscoverySportFilter>().toggle(sport);
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

  Future<void> _openFilters(List<Class> classes) async {
    final availableCities = classes
        .map((classModel) => classModel.court?.city)
        .whereType<String>()
        .map((city) => city.trim())
        .where((city) => city.isNotEmpty)
        .toSet()
        .toList();
    final cityDistances = _buildCityDistances(classes);
    final result = await FilterBottomSheet.show(
      context,
      selectedTimes: _selectedTimes,
      gender: _gender,
      levels: _levels,
      format: _format,
      distance: _distance,
      city: _city,
      availableCities: availableCities,
      cityDistances: cityDistances,
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

  Future<void> _refreshClasses() async {
    context.read<ClassesBloc>().add(FetchAllClasses());
    await context.read<ClassesBloc>().stream.firstWhere(
      (s) => s.status == ClassStats.success || s.status == ClassStats.failure,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isMapView) {
      return BlocBuilder<ClassesBloc, ClassesState>(
        builder: (context, state) {
          return ClassMapView(
            classes: _filtered(state.classes),
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
        },
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
          final filtered = _filtered(state.classes);
          final grouped = _groupedClasses(filtered);
          _sectionDates = [
            for (final entry in grouped.entries)
              if (entry.value.first.date != null)
                (
                label: entry.key,
                date: DateTime(
                  entry.value.first.date!.year,
                  entry.value.first.date!.month,
                  entry.value.first.date!.day,
                ),
                ),
          ];
          final availableDateKeys = _availableDateKeys(filtered);
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
                onFilterTap: () => _openFilters(state.classes),
                onMapTap: () => setState(() => _isMapView = true),
                dates: _dates,
                selectedDate: _selectedDate,
                availableDateKeys: availableDateKeys,
                onDateSelected: (date) {
                  setState(() => _selectedDate = date);
                  _scrollToDay(date);
                },
              ),

              Expanded(
                child: (state.status == ClassStats.loading && state.classes.isEmpty)
                    ? Center(child: CustomLoadingView())
                    : grouped.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noClassesFound,
                          style: AppStyles.w600f18inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                      )
                    // Every day section is laid out, not lazily built, so a tap
                    // on the date strip can scroll straight to its section.
                    : RefreshIndicator(
                        color: kPrimaryColor,
                        onRefresh: _refreshClasses,
                        child: SingleChildScrollView(
                          controller: _listController,
                          padding: const EdgeInsets.only(top: 4, bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final entry in grouped.entries) ...[
                                KeyedSubtree(
                                  key: _sectionKeys.putIfAbsent(
                                    entry.key,
                                    () => GlobalKey(),
                                  ),
                                  child: _dateGroupHeader(label: entry.key),
                                ),
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
