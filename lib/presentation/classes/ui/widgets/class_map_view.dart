import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/classes/bloc/classes_bloc.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';
import 'package:quadraclub_app/presentation/classes/ui/class_details_screen.dart';
import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';
import 'package:quadraclub_app/presentation/home/data/models/location_result.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/change_location_sheet.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/court_filter_bottom_sheet.dart';

class ClassMapView extends StatefulWidget {
  final List<Class> classes;
  final String currentLocation;
  final LatLng initialCenter;
  final Function(LocationResult) onLocationChanged;
  final VoidCallback onBackToList;
  final Function(Set<TimeOfDayFilter> times, String? city, double? distance)
  onApplyFilters;
  final Set<TimeOfDayFilter> filterTimes;
  final String? filterCity;
  final double? filterDistance;
  final Set<String> selectedSports;
  final Function(String) onSportSelected;

  const ClassMapView({
    super.key,
    required this.classes,
    required this.currentLocation,
    required this.initialCenter,
    required this.onLocationChanged,
    required this.onBackToList,
    required this.onApplyFilters,
    this.filterTimes = const {},
    this.filterCity,
    this.filterDistance,
    required this.selectedSports,
    required this.onSportSelected,
  });

  @override
  State<ClassMapView> createState() => _ClassMapViewState();
}

class _ClassMapViewState extends State<ClassMapView> {
  GoogleMapController? _mapController;
  late final PageController _pageController;
  int _activePageIndex = 0;
  LatLng _currentLatLng = const LatLng(51.5072, -0.1276);

  List<Class> get _mappableClasses => widget.classes.where((c) {
    final coords = c.court?.coordinates;
    return coords?.latitude != null && coords?.longitude != null;
  }).toList();

  double _classDistance(Class classModel) {
    final coords = classModel.court?.coordinates;
    if (coords?.latitude == null || coords?.longitude == null) {
      return double.infinity;
    }
    return Geolocator.distanceBetween(
          _currentLatLng.latitude,
          _currentLatLng.longitude,
          coords!.latitude!,
          coords.longitude!,
        ) /
        1000.0;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _currentLatLng = widget.initialCenter;
    _initUserLocation();
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
          });
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Set<Marker> get _markers {
    final classes = _mappableClasses;
    return classes.asMap().entries.map((entry) {
      final index = entry.key;
      final classModel = entry.value;
      final coords = classModel.court!.coordinates!;
      final isActive = index == _activePageIndex;
      return Marker(
        markerId: MarkerId(classModel.id ?? 'class_$index'),
        position: LatLng(coords.latitude!, coords.longitude!),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isActive ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
        ),
        onTap: () => _onMarkerTap(index),
      );
    }).toSet();
  }

  void _onPageChanged(int index) {
    setState(() => _activePageIndex = index);
    final classes = _mappableClasses;
    if (index >= classes.length) return;
    final coords = classes[index].court!.coordinates!;
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(coords.latitude!, coords.longitude!)),
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
        setState(() {
          _currentLatLng = LatLng(location.latitude, location.longitude);
        });
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(location.latitude, location.longitude),
            13,
          ),
        );
      },
    );
  }

  void _openClassDetails(Class classModel) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.read<AuthBloc>().state;
    if (authState.user == null) {
      LoginToBookDialog.show(
        context,
        title: l10n.signInToBookThisClass,
        subtitle: l10n.loginToReserveYourSpot,
      );
      return;
    }

    context.read<ClassesBloc>().add(FetchPortfolioBalance());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClassDetailsScreen(
          classModel: classModel,
          distanceKm: _classDistance(classModel),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final classes = _mappableClasses;
    final l10n = AppLocalizations.of(context)!;

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
                              size: 20,
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
                            initialTimes: widget.filterTimes,
                            initialCity: widget.filterCity,
                            initialDistance: widget.filterDistance,
                            availableCities: widget.classes
                                .map((c) => c.locationName)
                                .whereType<String>()
                                .where((s) => s.trim().isNotEmpty)
                                .toSet()
                                .toList(),
                            onApply: widget.onApplyFilters,
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                (widget.filterTimes.isNotEmpty ||
                                    widget.filterCity != null ||
                                    widget.filterDistance != null)
                                ? kPrimaryColor
                                : kWhiteColor,
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
                  SportFilterRow(
                    horizontalPadding: 0,
                    selectedSports: widget.selectedSports,
                    onSportToggled: widget.onSportSelected,
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
                  mapToolbarEnabled: false,
                ),
                Positioned(
                  right: 16,
                  bottom: classes.isEmpty ? 32 : 160,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _mapController?.animateCamera(
                            CameraUpdate.newLatLngZoom(_currentLatLng, 13),
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
                if (classes.isEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 32,
                    child: Center(
                      child: Text(
                        l10n.noClassesFound,
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
                        itemCount: classes.length,
                        onPageChanged: _onPageChanged,
                        itemBuilder: (context, index) {
                          final classModel = classes[index];
                          final levelLabel = localizedClassLevelLabel(
                            context,
                            classModel.level,
                          );
                          return GestureDetector(
                            onTap: () => _openClassDetails(classModel),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.all(12),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      SportBadge(
                                        sport: SportTypeExtension.fromString(
                                          classModel.sportName ?? '',
                                        ),
                                      ),
                                      if (levelLabel.isNotEmpty) ...[
                                        4.widthBox,
                                        CommonBadge(label: levelLabel),
                                      ],
                                      const Spacer(),
                                      Text(
                                        formatPriceWhole(classModel.price),
                                        style: AppStyles.w600f14inter.copyWith(
                                          color: kBlueF1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  6.heightBox,
                                  Text(
                                    classModel.className,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.w600f14inter.copyWith(
                                      color: kDarkTextColor,
                                    ),
                                  ),
                                  2.heightBox,
                                  Text(
                                    '${classModel.startTime}-${classModel.endTime}'
                                    '  •  ${classModel.locationName ?? ''}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.w400f12inter.copyWith(
                                      color: kGreyTextColor,
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
