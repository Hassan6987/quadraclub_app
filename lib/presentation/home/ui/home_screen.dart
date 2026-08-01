import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/court_model.dart';
import 'package:quadraclub_app/presentation/home/data/location_result.dart';
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
  SportType? _selectedSport;
  DateTime _selectedDate = DateTime(2025, 4, 1);
  String _searchQuery = '';

  // Filter criteria states
  String? _filterTimeOfDay;
  String? _filterCity;
  double _filterDistance = 25.0;

  List<DateTime> get _dates =>
      List.generate(7, (i) => DateTime(2025, 4, 1).add(Duration(days: i)));

  List<CourtModel> get _filteredCourts {
    return dummyCourts.where((court) {
      // 1. Sport filter (Multi-select or single select, let's match single select for simplicity, or if null, all)
      if (_selectedSport != null && !court.sports.contains(_selectedSport)) {
        return false;
      }

      // 2. Search query filter
      if (_searchQuery.isNotEmpty &&
          !court.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !court.location.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }

      // 3. City filter (from filter bottom sheet)
      if (_filterCity != null &&
          court.city.toLowerCase() != _filterCity!.toLowerCase()) {
        return false;
      }

      // 4. Distance filter
      if (court.distanceMiles > _filterDistance) {
        return false;
      }

      // 5. Time of day filter
      if (_filterTimeOfDay != null) {
        // Simple logic matching:
        // Morning -> court has slots between 06:00 and 12:00
        // Afternoon -> court has slots between 12:00 and 18:00
        // Night -> court has slots between 18:00 and 24:00
        bool hasMatchingSlot = false;
        final currentSlots = court.timeSlots[_selectedSport ?? court.sports.first] ?? [];
        for (var slot in currentSlots) {
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
    if (_isMapView) {
      return CourtMapView(
        courts: _filteredCourts,
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
            _filterDistance = dist;
          });
        },
        selectedSport: _selectedSport,
        onSportSelected: (sport) => setState(() => _selectedSport = sport),
      );
    }

    final courtsList = _filteredCourts;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Find courts near you.",
        centerTile: false,
        backgroundColor: kWhiteColor,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 2. Sport Filter Chip List (Horizontal)
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: SportType.values.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final sport = SportType.values[index];
                  final isSelected = _selectedSport == sport;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSport = isSelected ? null : sport;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? kPrimaryColor : kGreyColor,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected ? null : Border.all(color: kBorderColor),
                      ),
                      child: Center(
                        child: Text(
                          sport.label,
                          style: AppStyles.w400f14inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            12.heightBox,

            // 3. Search and Action Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        SearchCourtsSheet.show(
                          context,
                          courts: dummyCourts,
                          onCourtSelected: (court) {
                            setState(() {
                              _searchQuery = court.name;
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
                            const Icon(
                                Icons.search, color: kDarkTextColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              _searchQuery.isNotEmpty ? _searchQuery : 'Search by name...',
                              style: AppStyles.w400f14inter.copyWith(
                                  color: kDarkTextColor
                              ),
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
                        initialDistance: _filterDistance,
                        onApply: (timeOfDay, city, dist) {
                          setState(() {
                            _filterTimeOfDay = timeOfDay;
                            _filterCity = city;
                            _filterDistance = dist;
                          });
                        },
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
                          colorFilter: const ColorFilter.mode(kDarkTextColor, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                  8.widthBox,
                  // Map View Toggle Button
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
                        child: Icon(Icons.map_outlined, color: kDarkTextColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            12.heightBox,

            // 4. Date Selector Row
            CommonDateSelectionRow(
              dates: _dates,
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
            12.heightBox,

            // 5. Scrollable Court Cards List
            Expanded(
              child: courtsList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_off_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No courts match your search/filters.',
                            style: AppStyles.w500f14inter.copyWith(color: kTextColor),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _selectedSport = null;
                                _filterTimeOfDay = null;
                                _filterCity = null;
                                _filterDistance = 50.0;
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
                            Navigator.push(context, MaterialPageRoute(builder: (
                                _) =>
                                CourtDetailScreen(court: courtsList[index],)));
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
