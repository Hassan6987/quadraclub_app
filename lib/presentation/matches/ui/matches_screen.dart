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

  final Set<String> _selectedSports = {};

  /// Level sections follow the header's sport selection.
  List<String> get _levelSports => _selectedSports.toList();

  late final DateTime _anchorDate;
  DateTime? _selectedDate;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<TimeOfDayFilter> _filterTimes = {};
  GenderFilter _filterGender = GenderFilter.misto;
  Set<SportLevel> _filterLevels = {};
  String? _filterCity;
  double? _filterDistance;
  MatchFormat? _filterFormat;

  @override
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _anchorDate = DateTime(now.year, now.month, now.day);
    _selectedSports.addAll(_profileSportSlugs());
    _initUserLocation();
  }

  Set<String> _profileSportSlugs() {
    final user = context.read<AuthBloc>().state.user;
    return defaultSelectedSportSlugs(
      user?.sportsInfo.map((s) => s.sport) ?? const [],
    );
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

  double _clubDistance(Booking match) {
    return getDistanceKm(
      fromLat: _currentLatLng.latitude,
      fromLng: _currentLatLng.longitude,
      toLat: match.club?.latitude,
      toLng: match.club?.longitude,
    );
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

      // --- new: date filter ---
      final matchDate = match.bookingDate;
      if (matchDate == null) return false;
      final matchDateOnly = DateTime(
        matchDate.year,
        matchDate.month,
        matchDate.day,
      );
      if (!_isSameDate(matchDateOnly, _selectedDate)) {
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

      // Format filter — new
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

    filtered.sort((a, b) => _clubDistance(a).compareTo(_clubDistance(b)));
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
    setState(() => toggleSportSelection(_selectedSports, sport));
  }

  bool _isSameDate(DateTime a, DateTime? b) {
    if (b == null) {
      return true;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Map<String, List<Booking>> _groupedBookings(List<Booking> allBookings) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final result = <String, List<Booking>>{};

    for (final c in _filteredMatches(allBookings)) {
      final classDate = c.bookingDate;
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

  @override
  void dispose() {
    _searchController.dispose();
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
        final grouped = _groupedBookings(state.bookings);
        final hasActiveFilters =
            _filterTimes.isNotEmpty ||
            _filterGender != GenderFilter.misto ||
            _filterLevels.isNotEmpty ||
            _filterCity != null ||
            _filterDistance != null ||
            _filterFormat != null;

        // available cities for quick-select chips, same pattern as HomeScreen
        final availableCities = state.bookings
            .map((b) => b.club?.city)
            .whereType<String>()
            .where((s) => s.trim().isNotEmpty)
            .toSet()
            .toList();

        return Scaffold(
          backgroundColor: kCardColor,
          appBar: CustomAppBar(
            title: l10n.openMatches,
            centerTile: false,
            backgroundColor: kWhiteColor,
          ),
          // The header stays mounted while loading and when nothing comes
          // back, so the sports, search, filters and dates are always there.
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DiscoveryHeader(
                selectedSports: _selectedSports,
                onSportToggled: _toggleSport,
                searchController: _searchController,
                searchHint: l10n.searchByName,
                onSearchChanged: (value) =>
                    setState(() => _searchQuery = value),
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
                onDateSelected: (date) => setState(() => _selectedDate = date),
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
                    : ListView(
                        children: [
                          for (final entry in grouped.entries) ...[
                            _dateGroupHeader(label: entry.key),
                            for (final match in entry.value)
                              MatchCard(
                                match: match,
                                distanceKm: _clubDistance(match),
                                onTap: () =>
                                    _openJoinMatch(match, _clubDistance(match)),
                              ),
                          ],
                        ],
                      ),
              ),
            ],
          ),
          floatingActionButton: Container(
            padding: EdgeInsets.all(8),
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
                style: AppStyles.w600f16inter.copyWith(color: kWhiteColor),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openJoinMatch(Booking match, double distanceKm) {
    final l10n = AppLocalizations.of(context)!;
    // Gate: show login dialog for unauthenticated users
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
