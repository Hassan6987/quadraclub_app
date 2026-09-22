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

  late final DateTime _anchorDate;
  DateTime? _selectedDate;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _filterTimeOfDay;
  String? _filterCity;
  double? _filterDistance;
  MatchFormat? _filterFormat;

  @override
  void initState() {
    final now = DateTime.now();
    _anchorDate = DateTime(now.year, now.month, now.day);
    _initUserLocation();
    super.initState();
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

  int? _parseHour(String? time) {
    if (time == null || time.isEmpty) return null;
    final parts = time.split(':');
    if (parts.isEmpty) return null;
    return int.tryParse(parts[0]);
  }

  bool _hasMatchingSlot(Booking match) {
    final startHour = _parseHour(match.startTime);
    final endHour = _parseHour(match.endTime);

    if (startHour == null || endHour == null) return false;

    final timeOfDay = _filterTimeOfDay?.toLowerCase();
    if (timeOfDay == 'morning' && startHour >= 6 && endHour < 12) {
      return true;
    }
    if (timeOfDay == 'afternoon' && startHour >= 12 && endHour < 18) {
      return true;
    }
    if (timeOfDay == 'night' && (startHour >= 18 || endHour < 6)) {
      return true;
    }
    return false;
  }

  List<Booking> _filteredMatches(List<Booking> allBookings) {
    final query = _searchQuery.trim().toLowerCase();

    final filtered = allBookings.where((match) {
      if (_selectedSports.isNotEmpty &&
          !_selectedSports.contains(sportSlug(match.sport.label))) {
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

      if (_filterTimeOfDay != null && !_hasMatchingSlot(match)) {
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
      if (_filterTimeOfDay != null)
        HeaderFilterBadge(
          label: localizedTimeOfDay(context, _filterTimeOfDay!),
          icon: Icons.access_time,
          onClear: () => setState(() => _filterTimeOfDay = null),
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
          _filterTimeOfDay = null;
          _filterCity = null;
          _filterDistance = null;
          _filterFormat = null;
        }),
      ),
    ];
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState.user == null) {
          return GuestLoginPrompt(
            title: l10n.openMatches,
            subtitle: l10n.signInToViewJoinOpenMatches,
          );
        }
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
                    _currentLatLng = LatLng(
                      location.latitude,
                      location.longitude,
                    );
                    _hasUserLocation = true;
                  });
                },
                onBackToList: () => setState(() => _isMapView = false),
                filterTimeOfDay: _filterTimeOfDay,
                filterCity: _filterCity,
                filterDistance: _filterDistance,
                onApplyFilters: (timeOfDay, city, dist) {
                  setState(() {
                    _filterTimeOfDay = timeOfDay;
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
                _filterTimeOfDay != null ||
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
              body:
                  (state.status == MatchesStateStatus.loading &&
                      state.bookings.isEmpty)
                  ? const Center(child: CustomLoadingView())
                  : Column(
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
                            initialTimeOfDay: _filterTimeOfDay,
                            initialCity: _filterCity,
                            initialDistance: _filterDistance,
                            initialFormat: _filterFormat,
                            availableCities: availableCities,
                            onApply: (timeOfDay, city, dist, format) {
                              setState(() {
                                _filterTimeOfDay = timeOfDay;
                                _filterCity = city;
                                _filterDistance = dist;
                                _filterFormat = format;
                              });
                            },
                          ),
                          onMapTap: () => setState(() => _isMapView = true),
                          dates: _dates,
                          selectedDate: _selectedDate,
                          onDateSelected: (date) =>
                              setState(() => _selectedDate = date),
                        ),
                        Expanded(
                          child: grouped.isEmpty
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
                                          onTap: () => _openJoinMatch(
                                            match,
                                            _clubDistance(match),
                                          ),
                                        ),
                                    ],
                                  ],
                                ),
                        ),
                      ],
                    ),
              floatingActionButton: Container(
                margin: EdgeInsets.only(bottom: 5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kBlackColor,
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => CreateMatchDialog(),
                    );
                  },
                  child: Icon(Icons.add, color: kWhiteColor, size: 26),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openJoinMatch(Booking match, double distanceKm) {
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
