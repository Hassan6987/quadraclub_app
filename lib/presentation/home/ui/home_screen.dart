import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/home/bloc/courts_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/location_result.dart';
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

  String? _filterTimeOfDay;
  String? _filterCity;
  double? _filterDistance;

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
    super.dispose();
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
        final hour = int.tryParse((slot.startTime ?? '').split(':').first);
        if (hour == null) continue;

        if (_filterTimeOfDay == 'Morning' && hour >= 6 && hour < 12) {
          return true;
        }
        if (_filterTimeOfDay == 'Afternoon' && hour >= 12 && hour < 18) {
          return true;
        }
        if (_filterTimeOfDay == 'Night' && (hour >= 18 || hour < 6)) {
          return true;
        }
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
      if (_filterTimeOfDay != null && !_hasMatchingSlot(club)) {
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
      if (_filterTimeOfDay != null)
        HeaderFilterBadge(
          label: _filterTimeOfDay!,
          icon: Icons.access_time,
          onClear: () => setState(() => _filterTimeOfDay = null),
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
            _filterTimeOfDay != null ||
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
                          initialTimeOfDay: _filterTimeOfDay,
                          initialCity: _filterCity,
                          initialDistance: _filterDistance,
                          availableCities: state.courts
                              .map((c) => c.city)
                              .whereType<String>()
                              .where((s) => s.trim().isNotEmpty)
                              .toSet()
                              .toList(),
                          onApply: (timeOfDay, city, dist) {
                            setState(() {
                              _filterTimeOfDay = timeOfDay;
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
                                        _filterTimeOfDay = null;
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
                                final dist = _clubDistance(clubsList[index]);
                                return CourtCardWidget(
                                  club: clubsList[index],
                                  selectedDate: _selectedDate,
                                  selectedSports: _selectedSports,
                                  distanceKm: dist.isInfinite ? null : dist,
                                  onTap: () {
                                    // Gate: show login dialog for unauthenticated users
                                    final authState = context
                                        .read<AuthBloc>()
                                        .state;
                                    if (authState.user == null) {
                                      LoginToBookDialog.show(
                                        context,
                                        title: l10n.signInToBookThisCourt,
                                        subtitle: l10n
                                            .pleaseLogInCreateAccountToReserveYourSpot,
                                      );
                                      return;
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CourtDetailScreen(
                                          club: clubsList[index],
                                          distance: _clubDistance(
                                            clubsList[index],
                                          ),
                                        ),
                                      ),
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
