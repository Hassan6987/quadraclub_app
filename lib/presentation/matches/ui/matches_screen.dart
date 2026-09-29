import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';
import 'package:quadraclub_app/presentation/home/bloc/courts_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/models/location_result.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_map_view.dart';
import 'package:quadraclub_app/presentation/matches/bloc/matches_bloc.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/create_match_dialog.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/match_card.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/match_filter_bottom_sheet.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/match_join_bottom_sheet.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/helper/date_formatter.dart';

import '/app_exports.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  bool _isMapView = false;

  String _currentLocation = 'London, UK';

  LatLng _currentLatLng = const LatLng(51.5072, -0.1276);

  bool _hasUserLocation = false;

  /// Level sections follow the header's sport selection.
  List<String> get _levelSports => _selectedSports.toList();

  Set<String> get _selectedSports =>
      context.read<DiscoverySportFilter>().selected;

  late final DateTime _anchorDate;

  /// The highlighted day in the strip.
  late DateTime _selectedDate;

  /// One key per rendered day section.
  final Map<String, GlobalKey> _sectionKeys = {};

  final ScrollController _listController = ScrollController();

  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  final Set<TimeOfDayFilter> _filterTimes = {};

  GenderFilter _filterGender = GenderFilter.misto;

  Set<SportLevel> _filterLevels = {};

  String? _filterCity;

  double? _filterDistance;

  MatchFormat? _filterFormat;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _anchorDate = DateTime(now.year, now.month, now.day);

    _selectedDate = _anchorDate;

    context.read<DiscoverySportFilter>().ensureInitialized(
      context.read<AuthBloc>().state.user?.sportsInfo.map((s) => s.sport) ??
          const [],
    );

    _initUserLocation();
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

            _hasUserLocation = true;
          });
        }
      }
    } catch (_) {}
  }

  List<DateTime> get _dates =>
      List.generate(14, (i) => _anchorDate.add(Duration(days: i)));

  /// Distance between the current user location and a club.
  double _clubDistance(Booking match) {
    return getDistanceKm(
      fromLat: _currentLatLng.latitude,
      fromLng: _currentLatLng.longitude,
      toLat: match.club?.latitude,
      toLng: match.club?.longitude,
    );
  }

  /// Creates a map like:
  ///
  /// {
  ///   "Balneário Camboriú": 4.2,
  ///   "Florianópolis": 78.5,
  ///   "Itajaí": 31.7,
  /// }
  ///
  /// If multiple clubs exist in the same city, the nearest club
  /// in that city is used.
  Map<String, double> _buildCityDistances(List<Booking> bookings) {
    final cityDistances = <String, double>{};

    for (final booking in bookings) {
      final city = booking.club?.city?.trim();

      if (city == null || city.isEmpty) {
        continue;
      }

      final distance = _clubDistance(booking);

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

  List<Booking> _filteredMatches(List<Booking> allBookings) {
    final query = _searchQuery.trim().toLowerCase();

    final filtered = allBookings.where((match) {
      if (!_selectedSports.contains(sportSlug(match.sport.label))) {
        return false;
      }

      if (query.isNotEmpty &&
          !(match.club?.name ?? '').toLowerCase().contains(query) &&
          !(match.club?.city ?? '').toLowerCase().contains(query)) {
        return false;
      }

      final matchDate = match.bookingDate;

      if (matchDate == null) {
        return false;
      }

      final matchDateOnly = DateTime(
        matchDate.year,
        matchDate.month,
        matchDate.day,
      );

      if (matchDateOnly.isBefore(_anchorDate)) {
        return false;
      }

      if (_filterCity != null && _filterCity!.trim().isNotEmpty) {
        final fc = _filterCity!.trim().toLowerCase();

        final cc = (match.club?.city ?? '').toLowerCase();

        final cs = (match.club?.state ?? '').toLowerCase();

        final fullCity = '$cc, $cs';

        if (!cc.contains(fc) && !fc.contains(cc) && !fullCity.contains(fc)) {
          return false;
        }
      }

      if (!matchesSelectedTimes(_filterTimes, parseHour(match.startTime))) {
        return false;
      }

      if (!matchesSelectedLevelsAgainstPlayers(
        _filterLevels,
        matchSport: match.sport.label,
        playerSports: match.joinedPlayerSports,
        fallbackLevel: match.category,
      )) {
        return false;
      }

      if (_filterFormat != null && match.format != _filterFormat) {
        return false;
      }

      if (_filterDistance != null) {
        final dist = _clubDistance(match);

        if (dist.isInfinite || dist > _filterDistance!) {
          return false;
        }
      }

      return true;
    }).toList();

    filtered.sort((a, b) {
      final aDate = a.bookingDate;
      final bDate = b.bookingDate;

      if (aDate != null && bDate != null) {
        final byDay = DateTime(
          aDate.year,
          aDate.month,
          aDate.day,
        ).compareTo(DateTime(bDate.year, bDate.month, bDate.day));

        if (byDay != 0) {
          return byDay;
        }
      }

      return (a.startTime ?? '').compareTo(b.startTime ?? '');
    });

    return filtered;
  }

  List<Widget> _activeFilterBadges(AppLocalizations l10n) {
    return [
      for (final time in _filterTimes)
        HeaderFilterBadge(
          label: time.label(context),
          icon: Icons.access_time,
          onClear: () => setState(() => _filterTimes.remove(time)),
        ),

      if (_filterGender != GenderFilter.misto)
        HeaderFilterBadge(
          label: _filterGender.label(context),
          icon: Icons.people_outline,
          onClear: () => setState(() => _filterGender = GenderFilter.misto),
        ),

      for (final level in _filterLevels)
        HeaderFilterBadge(
          label: localizedLevelName(context, level.level),
          icon: Icons.bar_chart,
          onClear: () =>
              setState(() => _filterLevels = {..._filterLevels}..remove(level)),
        ),

      if (_filterFormat != null)
        HeaderFilterBadge(
          label: _filterFormat!.localizedLabel(context),
          icon: Icons.groups_outlined,
          onClear: () => setState(() => _filterFormat = null),
        ),

      if (_filterCity != null)
        HeaderFilterBadge(
          label: _filterCity!,
          icon: Icons.location_city,
          onClear: () => setState(() => _filterCity = null),
        ),

      if (_filterDistance != null)
        HeaderFilterBadge(
          label: l10n.distanceKm(_filterDistance!.round().toString()),
          icon: Icons.near_me_outlined,
          onClear: () => setState(() => _filterDistance = null),
        ),

      HeaderClearAllButton(
        onTap: () => setState(() {
          _filterTimes.clear();
          _filterGender = GenderFilter.misto;
          _filterLevels = {};
          _filterCity = null;
          _filterDistance = null;
          _filterFormat = null;
        }),
      ),
    ];
  }

  void _toggleSport(String sport) {
    context.read<DiscoverySportFilter>().toggle(sport);
  }

  bool _isSameDate(DateTime a, DateTime? b) {
    if (b == null) {
      return true;
    }

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Map<String, List<Booking>> _groupedBookings(List<Booking> matches) {
    final l10n = AppLocalizations.of(context)!;

    final result = <String, List<Booking>>{};

    for (final match in matches) {
      final date = match.bookingDate;

      if (date == null) {
        continue;
      }

      final label = _daySectionLabel(date, l10n);

      result.putIfAbsent(label, () => []).add(match);
    }

    return result;
  }

  Set<String> _availableDateKeys(List<Booking> matches) {
    final keys = <String>{};

    for (final match in matches) {
      final date = match.bookingDate;

      if (date == null) {
        continue;
      }

      keys.add(dateKey(DateTime(date.year, date.month, date.day)));
    }

    return keys;
  }

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

  void _scrollToDay(DateTime date) {
    final l10n = AppLocalizations.of(context)!;

    final sectionContext =
        _sectionKeys[_daySectionLabel(date, l10n)]?.currentContext;

    if (sectionContext == null) {
      return;
    }

    Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      alignment: 0,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<MatchesBloc, MatchesState>(
      builder: (context, state) {
        if (_isMapView) {
          return CourtMapView(
            courts: context.read<CourtsBloc>().state.courts,
            currentLocation: _currentLocation,
            initialCenter: _currentLatLng,
            onLocationChanged: (LocationResult location) {
              setState(() {
                _currentLocation = location.address;

                _currentLatLng = LatLng(location.latitude, location.longitude);

                _hasUserLocation = true;
              });
            },
            onBackToList: () => setState(() => _isMapView = false),
            filterTimes: _filterTimes,
            filterCity: _filterCity,
            filterDistance: _filterDistance,
            onApplyFilters: (times, city, dist) {
              setState(() {
                _filterTimes
                  ..clear()
                  ..addAll(times);

                _filterCity = city;

                _filterDistance = dist;
              });
            },
            onSportSelected: _toggleSport,
            selectedSports: _selectedSports,
          );
        }

        final filtered = _filteredMatches(state.bookings);

        final grouped = _groupedBookings(filtered);

        final availableDateKeys = _availableDateKeys(filtered);

        final hasActiveFilters =
            _filterTimes.isNotEmpty ||
            _filterGender != GenderFilter.misto ||
            _filterLevels.isNotEmpty ||
            _filterCity != null ||
            _filterDistance != null ||
            _filterFormat != null;

        /// All available cities.
        final availableCities = state.bookings
            .map((booking) => booking.club?.city)
            .whereType<String>()
            .map((city) => city.trim())
            .where((city) => city.isNotEmpty)
            .toSet()
            .toList();

        /// Distance of each city from the current user.
        ///
        /// When multiple clubs exist in one city, the nearest club
        /// is used as the city's distance.
        final cityDistances = _buildCityDistances(state.bookings);

        return Scaffold(
          backgroundColor: kCardColor,
          appBar: CustomAppBar(
            title: l10n.openMatches,
            centerTile: false,
            backgroundColor: kWhiteColor,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DiscoveryHeader(
                selectedSports: _selectedSports,
                onSportToggled: _toggleSport,
                searchController: _searchController,
                searchHint: l10n.searchByName,
                onSearchChanged: (value) {
                  setState(() => _searchQuery = value);
                },
                hasActiveFilters: hasActiveFilters,
                activeFilterBadges: hasActiveFilters
                    ? _activeFilterBadges(l10n)
                    : const [],
                onFilterTap: () => MatchFilterBottomSheet.show(
                  context,
                  initialTimes: _filterTimes,
                  initialGender: _filterGender,
                  initialLevels: _filterLevels,
                  sports: _levelSports,
                  initialCity: _filterCity,
                  initialDistance: _filterDistance,
                  initialFormat: _filterFormat,
                  availableCities: availableCities,

                  /// NEW
                  cityDistances: cityDistances,

                  userLat: _currentLatLng.latitude,
                  userLong: _currentLatLng.longitude,

                  onApply: (times, gender, levels, city, dist, format) {
                    setState(() {
                      _filterTimes
                        ..clear()
                        ..addAll(times);

                      _filterGender = gender;

                      _filterLevels = levels;

                      _filterCity = city;

                      _filterDistance = dist;

                      _filterFormat = format;
                    });
                  },
                ),
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
                child:
                    (state.status == MatchesStateStatus.loading &&
                        state.bookings.isEmpty)
                    ? const Center(child: CustomLoadingView())
                    : grouped.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noMatchesFound,
                          style: AppStyles.w600f18inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
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
                              for (final match in entry.value)
                                MatchCard(
                                  match: match,
                                  distanceKm: _clubDistance(match),
                                  onTap: () => _openJoinMatch(
                                    match,
                                    _clubDistance(match),
                                  ),
                                ),
                            ],
                          ],
                        ),
                      ),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => CreateMatchDialog(),
                );
              },
              child: Text(
                "+ Create Match",
                style: AppStyles.w600f16inter.copyWith(color: kDeepGreen),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openJoinMatch(Booking match, double distanceKm) {
    final l10n = AppLocalizations.of(context)!;

    final authState = context.read<AuthBloc>().state;

    if (authState.user == null) {
      LoginToBookDialog.show(
        context,
        title: l10n.signInToJoinThismatch,
        subtitle: l10n.signInToJoinOpenMatch,
      );

      return;
    }

    MatchJoinBottomSheet.show(context, match, distanceKm);
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
}
