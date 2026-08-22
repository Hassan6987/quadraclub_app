import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/bloc/courts_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/models/court_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/location_result.dart';
import 'package:quadraclub_app/presentation/home/ui/court_detail_screen.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_card_widget.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_filter_bottom_sheet.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_map_view.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/search_courts_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMapView = false;
  String _currentLocation = 'London, UK';
  LatLng _currentLatLng = const LatLng(51.5072, -0.1276);
  String? _selectedSportName;
  DateTime _selectedDate = DateTime(2025, 4, 1);
  String _searchQuery = '';

  String? _filterTimeOfDay;
  String? _filterCity;

  List<DateTime> get _dates =>
      List.generate(7, (i) => DateTime(2025, 4, 1).add(Duration(days: i)));

  List<Court> _filteredCourts(List<Court> courts) {
    return courts.where((court) {
      final sports = court.sports ?? [];

      if (_selectedSportName != null &&
          !sports.any((s) => s.sportName == _selectedSportName)) {
        return false;
      }

      if (_searchQuery.isNotEmpty &&
          !(court.courtName ?? '').toLowerCase().contains(
              _searchQuery.toLowerCase()) &&
          !(court.location ?? '').toLowerCase().contains(
              _searchQuery.toLowerCase())) {
        return false;
      }

      if (_filterCity != null &&
          (court.city ?? '').toLowerCase() != _filterCity!.toLowerCase()) {
        return false;
      }

      if (_filterTimeOfDay != null) {
        bool hasMatchingSlot = false;
        final targetSport = sports.firstWhere(
              (s) => s.sportName == _selectedSportName,
          orElse: () => sports.isNotEmpty ? sports.first : Sport(),
        );
        for (var slot in targetSport.hourlySlots) {
          final hour = int.tryParse(slot.split(':')[0]) ?? 0;
          if (_filterTimeOfDay == 'Morning' && hour >= 6 && hour < 12) {
            hasMatchingSlot = true;
          } else if (_filterTimeOfDay == 'Afternoon' && hour >= 12 && hour < 18) {
            hasMatchingSlot = true;
          } else if (_filterTimeOfDay == 'Night' && (hour >= 18 || hour < 6)) {
            hasMatchingSlot = true;
          }
        }
        if (!hasMatchingSlot) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourtsBloc, CourtsState>(
      builder: (context, state) {
        final courtsList = _filteredCourts(state.courts);
        final sportNames = state.courts
            .expand((c) => c.sports ?? [])
            .map((s) => s.sportName)
            .whereType<String>()
            .toSet()
            .toList();

        if (_isMapView) {
          return CourtMapView(
            courts: courtsList,
            currentLocation: _currentLocation,
            initialCenter: _currentLatLng,
            onLocationChanged: (LocationResult location) {
              setState(() {
                _currentLocation = location.address;
                _currentLatLng = LatLng(location.latitude, location.longitude);
              });
            },
            onBackToList: () => setState(() => _isMapView = false),
            onApplyFilters: (timeOfDay, city, dist) {
              setState(() {
                _filterTimeOfDay = timeOfDay;
                _filterCity = city;
              });
            },
            selectedSport: _selectedSportName,
            onSportSelected: (sport) =>
                setState(() => _selectedSportName = sport),
          );
        }

        return Scaffold(
          appBar: CustomAppBar(
            title: "Find courts near you.",
            centerTile: false,
            backgroundColor: kWhiteColor,
          ),
          body: state.status == CourtStateStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: sportNames.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final sport = sportNames[index];
                    final isSelected = _selectedSportName == sport;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSportName = isSelected ? null : sport;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? kPrimaryColor : kGreyColor,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected ? null : Border.all(
                              color: kBorderColor),
                        ),
                        child: Center(
                          child: Text(
                            sport,
                            style: AppStyles.w400f14inter.copyWith(
                                color: kDarkTextColor),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              12.heightBox,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          SearchCourtsSheet.show(
                            context,
                            courts: state.courts,
                            onCourtSelected: (court) {
                              setState(() {
                                _searchQuery = court.courtName ?? '';
                              });
                            },
                          );
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: kBorderColor),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: kDarkTextColor,
                                  size: 20),
                              const SizedBox(width: 8),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? _searchQuery
                                    : 'Search by name...',
                                style: AppStyles.w400f14inter.copyWith(
                                    color: kDarkTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    8.widthBox,
                    GestureDetector(
                      onTap: () {
                        CourtFilterBottomSheet.show(
                          context,
                          initialTimeOfDay: _filterTimeOfDay,
                          initialCity: _filterCity,
                          onApply: (timeOfDay, city, dist) {
                            setState(() {
                              _filterTimeOfDay = timeOfDay;
                              _filterCity = city;
                            });
                          }, initialDistance: 2.5,
                        );
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: kBorderColor),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            Assets.svg.filterLines.path,
                            colorFilter: const ColorFilter.mode(
                                kDarkTextColor, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                    8.widthBox,
                    GestureDetector(
                      onTap: () => setState(() => _isMapView = true),
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
                              Icons.map_outlined, color: kDarkTextColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              12.heightBox,
              CommonDateSelectionRow(
                dates: _dates,
                selectedDate: _selectedDate,
                onDateSelected: (date) => setState(() => _selectedDate = date),
              ),
              12.heightBox,
              Expanded(
                child: courtsList.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off_outlined, size: 64,
                          color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No courts match your search/filters.',
                        style: AppStyles.w500f14inter.copyWith(
                            color: kTextColor),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _selectedSportName = null;
                            _filterTimeOfDay = null;
                            _filterCity = null;
                          });
                        },
                        child: const Text('Reset Filters'),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: courtsList.length,
                  padding: const EdgeInsets.only(bottom: 24),
                  itemBuilder: (context, index) {
                    return CourtCardWidget(
                      court: courtsList[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CourtDetailScreen(court: courtsList[index]),
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