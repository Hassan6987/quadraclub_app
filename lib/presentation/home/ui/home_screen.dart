import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/common/widgets/slot_scroll_sync.dart';
import 'package:quadraclub_app/presentation/home/bloc/courts_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/location_result.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/booking_summary_sheet.dart';
import 'package:quadraclub_app/presentation/home/ui/court_detail_screen.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_card_widget.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_filter_bottom_sheet.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_map_view.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMapView = false;
  String _currentLocation = 'London, UK';
  LatLng _currentLatLng = const LatLng(51.5072, -0.1276);
  bool _hasUserLocation = false;

  final Set<String> _selectedSports = {};

  // Anchor is fixed once (today, at load time) so the two-week strip doesn't
  // shift underneath the user; _selectedDate moves as they tap a day.
  late final DateTime _anchorDate;
  late DateTime _selectedDate;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final Set<TimeOfDayFilter> _filterTimes = {};
  String? _filterCity;
  double? _filterDistance;

  /// Every slot row on this screen shares one group, so dragging any club's
  /// slots scrolls all of them.
  final SlotScrollSync _slotScrollSync = SlotScrollSync();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _anchorDate = DateTime(now.year, now.month, now.day);
    _selectedDate = _anchorDate;
    _initUserLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _slotScrollSync.dispose();
    super.dispose();
  }

  /// Unauthenticated users get the sign-in prompt instead of the booking or
  /// detail flow. Returns true when the caller may continue.
  bool _requireSignIn(AppLocalizations l10n) {
    if (context.read<AuthBloc>().state.user != null) return true;

    LoginToBookDialog.show(
      context,
      title: l10n.signInToBookThisCourt,
      subtitle: l10n.pleaseLogInCreateAccountToReserveYourSpot,
    );

    return false;
  }

  void _openClubDetail(Club club) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CourtDetailScreen(club: club, distance: _clubDistance(club)),
      ),
    );
  }

  void _openBookingSummary(Club club, Court court, Sport sport, String time) {
    context.read<CourtsBloc>().add(LoadPortfolio());

    BookingSummarySheet.show(
      context,
      club: club,
      court: court,
      sportName: sportSlug(sport.sportName),
      date: _selectedDate,
      startTime: time,
      distance: _clubDistance(club),
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

  String _dateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  double _clubDistance(Club club) {
    if (club.coordinates?.latitude == null ||
        club.coordinates?.longitude == null) {
      return double.infinity;
    }
    return Geolocator.distanceBetween(
          _currentLatLng.latitude,
          _currentLatLng.longitude,
          club.coordinates!.latitude!,
          club.coordinates!.longitude!,
        ) /
        1000.0;
  }

  /// Checks whether any court in [club] has an Available slot for
  /// _selectedDate that falls into the selected time-of-day bucket, for
  /// any of the currently-selected sports (or any sport if none selected).
  bool _hasMatchingSlot(Club club) {
    final key = _dateKey(_selectedDate);
    final sportsToCheck = _selectedSports.isEmpty
        ? kAllSportSlugs.toSet()
        : _selectedSports;

    for (final court in club.courts) {
      final daySlots = court.weeklySlots[key];
      if (daySlots == null) continue;

      final List<Padel> slots = [
        if (sportsToCheck.contains('tennis')) ...daySlots.tennis,
        if (sportsToCheck.contains('padel')) ...daySlots.padel,
        if (sportsToCheck.contains('pickleball')) ...daySlots.pickleball,
        if (sportsToCheck.contains('beach_tennis')) ...daySlots.beachTennis,
      ];

      for (final slot in slots) {
        if ((slot.status ?? '').toLowerCase() != 'available') continue;
        final hour = parseHour(slot.startTime);
        if (hour == null) continue;

        if (_filterTimes.any((t) => t.containsHour(hour))) return true;
      }
    }
    return false;
  }

  List<Club> _filteredClubs(List<Club> clubs) {
    final query = _searchQuery.trim().toLowerCase();

    final filtered = clubs.where((club) {
      // Sport filter
      if (_selectedSports.isNotEmpty &&
          !club.sports.any((s) => _selectedSports.contains(sportSlug(s)))) {
        return false;
      }

      // Search text query
      if (query.isNotEmpty &&
          !(club.name ?? '').toLowerCase().contains(query) &&
          !(club.city ?? '').toLowerCase().contains(query)) {
        return false;
      }

      // City filter
      if (_filterCity != null && _filterCity!.trim().isNotEmpty) {
        final fc = _filterCity!.trim().toLowerCase();
        final cc = (club.city ?? '').toLowerCase();
        final cs = (club.state ?? '').toLowerCase();
        final fullCity = '$cc, $cs';
        if (!cc.contains(fc) && !fc.contains(cc) && !fullCity.contains(fc)) {
          return false;
        }
      }

      // Time of Day filter
      if (_filterTimes.isNotEmpty && !_hasMatchingSlot(club)) {
        return false;
      }

      // Distance filter
      if (_filterDistance != null) {
        final dist = _clubDistance(club);
        if (dist.isInfinite || dist > _filterDistance!) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort by proximity if coordinates are available
    filtered.sort((a, b) {
      final distA = _clubDistance(a);
      final distB = _clubDistance(b);
      return distA.compareTo(distB);
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
          _filterCity = null;
          _filterDistance = null;
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<CourtsBloc, CourtsState>(
      builder: (context, state) {
        // If GPS is not active and location is still the London placeholder,
        // anchor default center to the first club's city/coordinates if available.
        if (!_hasUserLocation &&
            _currentLocation == 'London, UK' &&
            state.courts.isNotEmpty) {
          final firstClub = state.courts.first;
          if (firstClub.coordinates?.latitude != null &&
              firstClub.coordinates?.longitude != null) {
            _currentLatLng = LatLng(
              firstClub.coordinates!.latitude!,
              firstClub.coordinates!.longitude!,
            );
            _currentLocation =
                '${firstClub.city ?? ''}, ${firstClub.state ?? ''}';
          }
        }

        final clubsList = _filteredClubs(state.courts);
        final hasActiveFilters =
            _filterTimes.isNotEmpty ||
            _filterCity != null ||
            _filterDistance != null;

        if (_isMapView) {
          return CourtMapView(
            courts: clubsList,
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
            selectedSports: _selectedSports,
            onSportSelected: _toggleSport,
          );
        }

        return Scaffold(
          backgroundColor: kCardColor,
          appBar: CustomAppBar(
            title: l10n.findCourtsNearYou,
            centerTile: false,
            backgroundColor: kWhiteColor,
          ),
          body: state.status == CourtStateStatus.loading
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
                      onFilterTap: () {
                        CourtFilterBottomSheet.show(
                          context,
                          initialTimes: _filterTimes,
                          initialCity: _filterCity,
                          initialDistance: _filterDistance,
                          availableCities: state.courts
                              .map((c) => c.city)
                              .whereType<String>()
                              .where((s) => s.trim().isNotEmpty)
                              .toSet()
                              .toList(),
                          onApply: (times, city, dist) {
                            setState(() {
                              _filterTimes
                                ..clear()
                                ..addAll(times);
                              _filterCity = city;
                              _filterDistance = dist;
                            });
                          },
                        );
                      },
                      onMapTap: () => setState(() => _isMapView = true),
                      dates: _dates,
                      selectedDate: _selectedDate,
                      onDateSelected: (date) =>
                          setState(() => _selectedDate = date),
                    ),
                    Expanded(
                      child: clubsList.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_off_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.noCourtsMatchSearchFilters,
                                    style: AppStyles.w500f14inter.copyWith(
                                      color: kTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _searchQuery = '';
                                        _selectedSports.clear();
                                        _filterTimes.clear();
                                        _filterCity = null;
                                        _filterDistance = null;
                                      });
                                    },
                                    child: Text(l10n.resetFilters),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: clubsList.length,
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 24,
                              ),
                              itemBuilder: (context, index) {
                                final club = clubsList[index];
                                final dist = _clubDistance(club);

                                return CourtCardWidget(
                                  club: club,
                                  selectedDate: _selectedDate,
                                  selectedSports: _selectedSports,
                                  scrollSync: _slotScrollSync,
                                  distanceKm: dist.isInfinite ? null : dist,
                                  onTap: () {
                                    if (!_requireSignIn(l10n)) return;
                                    _openClubDetail(club);
                                  },
                                  onTimeSlotTap: (court, sport, time) {
                                    if (!_requireSignIn(l10n)) return;
                                    _openBookingSummary(
                                      club,
                                      court,
                                      sport,
                                      time,
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
