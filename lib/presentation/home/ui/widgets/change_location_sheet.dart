import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/data/places_service.dart';
import 'package:quadraclub_app/presentation/home/data/location_result.dart';

class ChangeLocationSheet extends StatefulWidget {
  final Function(LocationResult) onLocationSelected;

  const ChangeLocationSheet({
    super.key,
    required this.onLocationSelected,
  });

  static Future<void> show(BuildContext context, {
    required Function(LocationResult) onLocationSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ChangeLocationSheet(
        onLocationSelected: onLocationSelected,
      ),
    );
  }

  @override
  State<ChangeLocationSheet> createState() => _ChangeLocationSheetState();
}

class _ChangeLocationSheetState extends State<ChangeLocationSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<PlacePrediction> _predictions = [];
  bool _isSearching = false;
  bool _isLocating = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    // Auto-focus so the real keyboard pops up immediately.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _controller.text.trim();

    _debounce?.cancel();
    if (query.isEmpty) {
      setState(() {
        _predictions = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    // Debounce so we don't hammer the Places API on every keystroke.
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final results = await PlacesService.autocomplete(query);
      if (!mounted) return;
      setState(() {
        _predictions = results;
        _isSearching = false;
      });
    });
  }

  Future<void> _selectPrediction(PlacePrediction prediction) async {
    setState(() => _isSearching = true);
    final details = await PlacesService.getPlaceDetails(prediction.placeId);
    if (!mounted) return;
    setState(() => _isSearching = false);

    if (details != null) {
      widget.onLocationSelected(details);
      Navigator.pop(context);
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLocating = true);
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied ||
            requested == LocationPermission.deniedForever) {
          setState(() => _isLocating = false);
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;
      widget.onLocationSelected(
        LocationResult(
          address: 'Current location',
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
      Navigator.pop(context);
    } catch (_) {
      // Swallow — user can still type a location manually.
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Change Location',
                  style: AppStyles.w600f18inter.copyWith(
                    color: kDarkTextColor,
                    fontSize: 20,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                      Icons.close, color: kDarkTextColor, size: 24),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: kBorderColor),
          // Search Location field (real keyboard now)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kBlackColor, width: 1.5),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.location_on_outlined, color: kTextColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        hintText: 'Search location',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: AppStyles.w400f14inter,
                    ),
                  ),
                  if (_isSearching)
                    const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Use current location
          const SizedBox(height: 8),
          // Predictions list
          Expanded(
            child: _controller.text.isEmpty
                ? const SizedBox.shrink()
                : _predictions.isEmpty && !_isSearching
                ? Center(
              child: Text(
                'No locations found',
                style: AppStyles.w400f14inter.copyWith(color: kTextColor),
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _predictions.length,
              separatorBuilder: (_, __) => const Divider(color: kBorderColor),
              itemBuilder: (context, index) {
                final prediction = _predictions[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.location_on, color: kTextColor),
                  title: Text(
                    prediction.description,
                    style: AppStyles.w500f14inter.copyWith(
                        color: kDarkTextColor),
                  ),
                  onTap: () => _selectPrediction(prediction),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}