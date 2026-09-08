import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/location_result.dart';
import 'package:quadraclub_app/presentation/home/ui/court_detail_screen.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/change_location_sheet.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_filter_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';

class CourtMapView extends StatefulWidget {
  final List<Club> courts;
  final String currentLocation;
  final LatLng initialCenter;
  final Function(LocationResult) onLocationChanged;
  final VoidCallback onBackToList;
  final Function(String? timeOfDay, String? city, double distance)
  onApplyFilters;
  final Set<String> selectedSports; // <-- was: final String? selectedSport;
  final Function(String)
  onSportSelected; // <-- was: final Function(String?) onSportSelected;

  const CourtMapView({
    super.key,
    required this.courts,
    required this.currentLocation,
    required this.initialCenter,
    required this.onLocationChanged,
    required this.onBackToList,
    required this.onApplyFilters,
    required this.selectedSports,
    required this.onSportSelected,
  });

  @override
  State<CourtMapView> createState() => _CourtMapViewState();
}

class _CourtMapViewState extends State<CourtMapView> {
  GoogleMapController? _mapController;
  late final PageController _pageController;
  int _activePageIndex = 0;

  // Only courts we can actually place a pin for.
  List<Club> get _mappableCourts => widget.courts.toList();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Set<Marker> get _markers {
    final courts = _mappableCourts;
    return courts
        .asMap()
        .entries
        .map((entry) {
      final index = entry.key;
      final court = entry.value;
      final isActive = index == _activePageIndex;
      return Marker(
        markerId: MarkerId(court.id ?? 'court_$index'),
        position: LatLng(
          court.coordinates!.latitude!,
          court.coordinates!.longitude!,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isActive ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
        ),
        onTap: () => _onMarkerTap(index),
      );
    }).toSet();
  }

  void _onPageChanged(int index) {
    setState(() => _activePageIndex = index);
    final courts = _mappableCourts;
    if (index >= courts.length) return;
    final court = courts[index];
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(court.coordinates!.latitude!, court.coordinates!.longitude!),
      ),
    );
  }

  void _onMarkerTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _openLocationSearch() async {
    await ChangeLocationSheet.show(
      context,
      onLocationSelected: (location) {
        widget.onLocationChanged(location);
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(location.latitude, location.longitude),
            13,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final courts = _mappableCourts;

    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: widget.onBackToList,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: kBorderColor, width: 1),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back,
                              color: kDarkTextColor,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _openLocationSearch,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: kBorderColor, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.currentLocation,
                                style: AppStyles.w500f14inter.copyWith(
                                  color: kDarkTextColor,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: kDarkTextColor,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          CourtFilterBottomSheet.show(
                            context,
                            initialDistance: 25.0,
                            onApply: widget.onApplyFilters,
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: kBorderColor, width: 1),
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
                    ],
                  ),
                  4.heightBox,
                  Divider(color: kBorderColor, thickness: 1),
                  4.heightBox,
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: kAllSportSlugs.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final sport = kAllSportSlugs[index];
                        final isSelected = widget.selectedSports.contains(
                          sport,
                        );
                        final label =
                            '${sport[0].toUpperCase()}${sport
                            .substring(1)
                            .replaceAll('_', ' ')}';
                        return GestureDetector(
                          onTap: () => widget.onSportSelected(sport),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? kPrimaryColor : kWhiteColor,
                              borderRadius: BorderRadius.circular(12),
                              border: isSelected
                                  ? null
                                  : Border.all(color: kBorderColor),
                            ),
                            child: Center(
                              child: Text(
                                label,
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
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: widget.initialCenter,
                    zoom: 13,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onTap: (_) {},
                ),
                Positioned(
                  right: 16,
                  top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.35,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            _mapController?.animateCamera(
                              CameraUpdate.zoomIn(),
                            ),
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
                        onTap: () =>
                            _mapController?.animateCamera(
                              CameraUpdate.zoomOut(),
                            ),
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
                      GestureDetector(
                        onTap: () {
                          _mapController?.animateCamera(
                            CameraUpdate.newLatLngZoom(
                              widget.initialCenter,
                              13,
                            ),
                          );
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: kWhiteColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.navigation,
                              color: Colors.blue,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (courts.isEmpty)
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 32,
                    child: Center(
                      child: Text(
                        'No courts with a location to show here yet',
                        style: TextStyle(color: kTextColor),
                      ),
                    ),
                  )
                else
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 32,
                    child: SizedBox(
                      height: 110,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: courts.length,
                        onPageChanged: _onPageChanged,
                        itemBuilder: (context, index) {
                          final court = courts[index];
                          final sports = court.sports;
                          return GestureDetector(
                            onTap: () {
                              final authState = context
                                  .read<AuthBloc>()
                                  .state;
                              if (authState.user == null) {
                                LoginToBookDialog.show(
                                  context,
                                  title: 'Sign in to book this court',
                                  subtitle:
                                  'Please log in or create an account to reserve your spot.',
                                );
                                return;
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CourtDetailScreen(club: court),
                                ),
                              );
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: court.photo ?? '',
                                      height: 96,
                                      width: 96,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor: Colors.grey
                                                .shade100,
                                            child: Container(
                                              height: 96,
                                              width: 96,
                                              decoration: const BoxDecoration(
                                                  color: Colors.white),
                                            ),
                                          ),
                                      errorWidget: (context, url, error) {
                                        return Image.asset(
                                          Assets.png.clubLogo.path,
                                          height: 96,
                                          width: 96,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          court.name ?? '',
                                          style: AppStyles.w600f14inter
                                              .copyWith(
                                            color: kDarkTextColor,
                                            fontSize: 15,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          court.city ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.w400f12inter
                                              .copyWith(color: kTextColor),
                                        ),
                                        const SizedBox(height: 8),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: sports.map((sport) {
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                  right: 4,
                                                ),
                                                padding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    100,
                                                  ),
                                                ),
                                                child: Text(
                                                  sport,
                                                  style: AppStyles.w500f8inter
                                                      .copyWith(
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
          ),
        ],
      ),
    );
  }
}
