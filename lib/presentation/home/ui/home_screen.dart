import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/court_model.dart';
import 'package:quadraclub_app/presentation/home/data/home_dummy_data.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_card_widget.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_map_view.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_filter_bottom_sheet.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/search_courts_sheet.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMapView = false;
  String _currentLocation = 'London, UK';
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
        onLocationChanged: (newLoc) {
          setState(() {
            _currentLocation = newLoc;
          });
        },
        onBackToList: () {
          setState(() {
            _isMapView = false;
          });
        },
        onApplyFilters: (timeOfDay, city, dist) {
          setState(() {
            _filterTimeOfDay = timeOfDay;
            _filterCity = city;
            _filterDistance = dist;
          });
        },
        selectedSport: _selectedSport,
        onSportSelected: (sport) {
          setState(() {
            _selectedSport = sport;
          });
        },
      );
    }

    final courtsList = _filteredCourts;

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Row
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Find courts near you.',
                    style: AppStyles.w600f24inter.copyWith(
                      color: kDarkTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      // Notification Bell Button
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RouteName.notifications);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: kCardColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_none,
                            color: kOrangeColor,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Chat Button
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RouteName.myChats);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: kCardColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline,
                            color: kOrangeColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? kPrimaryColor : kCardColor,
                        borderRadius: BorderRadius.circular(100),
                        border: isSelected ? null : Border.all(color: kBorderColor),
                      ),
                      child: Center(
                        child: Text(
                          sport.label,
                          style: AppStyles.w500f12inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

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
                          color: kCardColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: kTextColor, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              _searchQuery.isNotEmpty ? _searchQuery : 'Search by name...',
                              style: AppStyles.w400f14inter.copyWith(
                                color: _searchQuery.isNotEmpty ? kDarkTextColor : kTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Filter Sheet Button
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
                        color: kCardColor,
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
                  const SizedBox(width: 8),
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
                        color: kCardColor,
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
            const SizedBox(height: 12),

            // 4. Date Selector Row
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: CommonDateSelectionRow(
                dates: _dates,
                selectedDate: _selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),

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
                            // Navigate to detail screen if required
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
