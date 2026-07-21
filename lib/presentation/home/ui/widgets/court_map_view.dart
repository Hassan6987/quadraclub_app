import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/court_model.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_filter_bottom_sheet.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/change_location_sheet.dart';

class CourtMapView extends StatefulWidget {
  final List<CourtModel> courts;
  final String currentLocation;
  final Function(String) onLocationChanged;
  final VoidCallback onBackToList;
  final Function(String? timeOfDay, String? city, double distance) onApplyFilters;
  final SportType? selectedSport;
  final Function(SportType?) onSportSelected;

  const CourtMapView({
    super.key,
    required this.courts,
    required this.currentLocation,
    required this.onLocationChanged,
    required this.onBackToList,
    required this.onApplyFilters,
    required this.selectedSport,
    required this.onSportSelected,
  });

  @override
  State<CourtMapView> createState() => _CourtMapViewState();
}

class _CourtMapViewState extends State<CourtMapView> {
  late final PageController _pageController;
  int _activePageIndex = 0;
  double _zoomLevel = 13.0;
  Offset _mapOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _activePageIndex = index;
      // Animate map view center to selected court coordinates (simulated)
      _mapOffset = Offset(
        (widget.courts[index].latitude - widget.courts[0].latitude) * 500,
        (widget.courts[index].longitude - widget.courts[0].longitude) * 500,
      );
    });
  }

  void _onMarkerTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Map center image representing the satellite map
    const mapBackgroundUrl = 'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=1200&auto=format&fit=crop&q=80';

    return Scaffold(
      body: Stack(
        children: [
          // 1. Draggable Simulated Map Canvas
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _mapOffset += details.delta;
              });
            },
            child: Transform.scale(
              scale: _zoomLevel / 13.0,
              child: Transform.translate(
                offset: _mapOffset,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(mapBackgroundUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: List.generate(widget.courts.length, (index) {
                      final court = widget.courts[index];
                      final isActive = index == _activePageIndex;

                      // Simulated marker placement offset from center
                      final double markerX = 180 + (court.latitude - 34.0) * 1500;
                      final double markerY = 320 + (court.longitude + 118.0) * 1500;

                      return Positioned(
                        left: markerX,
                        top: markerY,
                        child: GestureDetector(
                          onTap: () => _onMarkerTap(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isActive ? kPrimaryColor : kWhiteColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: isActive ? kBlackColor : kPrimaryColor,
                              size: isActive ? 28 : 22,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),

          // 2. Top Float Panel Controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Upper Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back to list
                      GestureDetector(
                        onTap: widget.onBackToList,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: kWhiteColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.arrow_back, color: kDarkTextColor),
                          ),
                        ),
                      ),
                      // Dropdown selection for city
                      GestureDetector(
                        onTap: () {
                          ChangeLocationSheet.show(
                            context,
                            onLocationSelected: widget.onLocationChanged,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.currentLocation,
                                style: AppStyles.w600f14inter.copyWith(color: kDarkTextColor),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.keyboard_arrow_down, color: kDarkTextColor, size: 18),
                            ],
                          ),
                        ),
                      ),
                      // Filter icon
                      GestureDetector(
                        onTap: () {
                          CourtFilterBottomSheet.show(
                            context,
                            initialDistance: 25.0,
                            onApply: widget.onApplyFilters,
                          );
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: kWhiteColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              Assets.svg.filterLines.path,
                              colorFilter: const ColorFilter.mode(kDarkTextColor, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Sport Filter tags
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: SportType.values.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final sport = SportType.values[index];
                        final isSelected = widget.selectedSport == sport;
                        return GestureDetector(
                          onTap: () {
                            widget.onSportSelected(isSelected ? null : sport);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? kPrimaryColor : kWhiteColor,
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
                ],
              ),
            ),
          ),

          // 3. Zoom Controls on the Right
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_zoomLevel < 18) _zoomLevel += 1;
                    });
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: kWhiteColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.add, color: kDarkTextColor),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_zoomLevel > 10) _zoomLevel -= 1;
                    });
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: kWhiteColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.remove, color: kDarkTextColor),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Compass navigation pointer
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _mapOffset = Offset.zero;
                      _zoomLevel = 13.0;
                    });
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: kWhiteColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(Icons.navigation, color: Colors.blue, size: 24),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Bottom Horizontal Court Slider Pager
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: SizedBox(
              height: 110,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.courts.length,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final court = widget.courts[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to details or click event
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Court Left Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AppCachedImage(
                              imageUrl: court.imageUrl,
                              width: 90,
                              height: 90,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Court Right Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  court.name,
                                  style: AppStyles.w600f14inter.copyWith(
                                    color: kDarkTextColor,
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${court.location} • ${court.distanceMiles} miles',
                                  style: AppStyles.w400f12inter.copyWith(
                                    color: kTextColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Sports Badges
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: court.sports.map((sport) {
                                      return Container(
                                        margin: const EdgeInsets.only(right: 4),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: Text(
                                          sport.label,
                                          style: AppStyles.w500f8inter.copyWith(
                                            color: kDarkTextColor,
                                            fontSize: 9,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
