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
      List.generate(7, (i) => _anchorDate.add(Duration(days: i)));

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

  String _sportSlug(SportType sport) {
    switch (sport) {
      case SportType.pedal:
        return 'padel';
      case SportType.tennis:
        return 'tennis';
      case SportType.beachTennis:
        return 'beach_tennis';
      case SportType.pickleball:
        return 'pickleball';
    }
  }

  List<Booking> _filteredMatches(List<Booking> allBookings) {
    final query = _searchQuery.trim().toLowerCase();

    final filtered = allBookings.where((match) {
      if (_selectedSports.isNotEmpty &&
          !_selectedSports.contains(_sportSlug(match.sport))) {
        return false;
      }

      if (query.isNotEmpty &&
          !(match.club?.name ?? '').toLowerCase().contains(query) &&
          !(match.club?.name ?? '').toLowerCase().contains(query)) {
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

  Widget _buildFilterBadge({
    required String label,
    required IconData icon,
    required VoidCallback onClear,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: kPrimaryColor.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPrimaryColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: kDarkTextColor),
          4.widthBox,
          Text(
            label,
            style: AppStyles.w500f12inter.copyWith(color: kDarkTextColor),
          ),
          4.widthBox,
          GestureDetector(
            onTap: onClear,
            child: const Icon(Icons.close, size: 14, color: kDarkTextColor),
          ),
        ],
      ),
    );
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
                  });
                },
                onBackToList: () => setState(() => _isMapView = false),
                onApplyFilters: (timeOfDay, city, dist) {
                  setState(() {
                    _filterTimeOfDay = timeOfDay;
                    _filterCity = city;
                    _filterDistance = dist!;
                  });
                },
                onSportSelected: (sport) => setState(() {
                  // <-- simple toggle, no null case
                  if (_selectedSports.contains(sport)) {
                    _selectedSports.remove(sport);
                  } else {
                    _selectedSports.add(sport);
                  }
                }),
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
              backgroundColor: kWhiteFo,
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
                        Container(
                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            border: Border(
                              bottom: BorderSide(color: kBorderColor),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 38,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  itemCount: kAllSportSlugs.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final sport = kAllSportSlugs[index];
                                    final isSelected = _selectedSports.contains(
                                      sport,
                                    );
                                    final label = localizedSportName(
                                      context,
                                      sport,
                                    );
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            _selectedSports.remove(sport);
                                          } else {
                                            _selectedSports.add(sport);
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? kPrimaryColor
                                              : kGreyColor,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: isSelected
                                              ? null
                                              : Border.all(color: kBorderColor),
                                        ),
                                        child: Center(
                                          child: Text(
                                            label,
                                            style: AppStyles.w400f14inter
                                                .copyWith(
                                                  color: kDarkTextColor,
                                                ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
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
                                      hintStyle: AppStyles.w400f14inter,
                                      onChanged: (value) =>
                                          setState(() => _searchQuery = value),
                                    ),
                                  ),
                                  8.widthBox,
                                  GestureDetector(
                                    onTap: () => MatchFilterBottomSheet.show(
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
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: hasActiveFilters
                                            ? kPrimaryColor
                                            : kWhiteColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: kBorderColor),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          Assets.svg.filterLines.path,
                                          colorFilter: const ColorFilter.mode(
                                            kDarkTextColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  8.widthBox,
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isMapView = true;
                                      });
                                    },
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: kWhiteColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: kBorderColor),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.map_outlined,
                                          color: kDarkTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ).withPaddingSymmetric(16, 0),
                              if (hasActiveFilters) ...[
                                8.heightBox,
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      if (_filterTimeOfDay != null) ...[
                                        _buildFilterBadge(
                                          label: localizedTimeOfDay(
                                            context,
                                            _filterTimeOfDay!,
                                          ),
                                          icon: Icons.access_time,
                                          onClear: () => setState(
                                            () => _filterTimeOfDay = null,
                                          ),
                                        ),
                                        8.widthBox,
                                      ],
                                      if (_filterFormat != null) ...[
                                        _buildFilterBadge(
                                          label: _filterFormat!.localizedLabel(
                                            context,
                                          ),
                                          icon: Icons.groups_outlined,
                                          onClear: () => setState(
                                            () => _filterFormat = null,
                                          ),
                                        ),
                                        8.widthBox,
                                      ],
                                      if (_filterCity != null) ...[
                                        _buildFilterBadge(
                                          label: _filterCity!,
                                          icon: Icons.location_city,
                                          onClear: () => setState(
                                            () => _filterCity = null,
                                          ),
                                        ),
                                        8.widthBox,
                                      ],
                                      if (_filterDistance != null) ...[
                                        _buildFilterBadge(
                                          label: l10n.distanceKm(
                                            _filterDistance!.round().toString(),
                                          ),
                                          icon: Icons.near_me_outlined,
                                          onClear: () => setState(
                                            () => _filterDistance = null,
                                          ),
                                        ),
                                        8.widthBox,
                                      ],
                                      GestureDetector(
                                        onTap: () => setState(() {
                                          _filterTimeOfDay = null;
                                          _filterCity = null;
                                          _filterDistance = null;
                                          _filterFormat = null;
                                        }),
                                        child: Text(
                                          l10n.clearAll,
                                          style: AppStyles.w500f12inter
                                              .copyWith(
                                                color: kDarkTextColor,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              12.heightBox,
                              CommonDateSelectionRow(
                                dates: _dates,
                                selectedDate: _selectedDate,
                                onDateSelected: (date) {
                                  setState(() {
                                    _selectedDate = date;
                                  });
                                },
                              ),
                              16.heightBox,
                            ],
                          ),
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
