import 'dart:async';

import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/data/places_service.dart';

class CourtFilterBottomSheet extends StatefulWidget {
  final Set<TimeOfDayFilter> initialTimes;
  final String? initialCity;
  final double? initialDistance;
  final List<String> availableCities;

  final Function(Set<TimeOfDayFilter> times, String? city, double? distance)
  onApply;

  const CourtFilterBottomSheet({
    super.key,
    this.initialTimes = const {},
    this.initialCity,
    this.initialDistance,
    this.availableCities = const [],
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    Set<TimeOfDayFilter> initialTimes = const {},
    String? initialCity,
    double? initialDistance,
    List<String> availableCities = const [],
    required Function(Set<TimeOfDayFilter> times, String? city, double? distance)
    onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CourtFilterBottomSheet(
          initialTimes: initialTimes,
          initialCity: initialCity,
          initialDistance: initialDistance,
          availableCities: availableCities,
          onApply: onApply,
        ),
      ),
    );
  }

  @override
  State<CourtFilterBottomSheet> createState() => _CourtFilterBottomSheetState();
}

class _CourtFilterBottomSheetState extends State<CourtFilterBottomSheet> {
  final Set<TimeOfDayFilter> _selectedTimes = {};
  String? _selectedCity;

  double _distance = 25.0;
  bool _enableDistance = false;

  final TextEditingController _cityController = TextEditingController();

  // City autocomplete state
  List<PlacePrediction> _cityPredictions = [];

  bool _isSearchingCity = false;

  Timer? _cityDebounce;

  List<String> get _quickCities {
    if (widget.availableCities.isNotEmpty) {
      return widget.availableCities;
    }

    return const ['Balneário Camboriú', 'Florianópolis', 'Itajaí'];
  }

  @override
  void initState() {
    super.initState();

    _selectedTimes.addAll(widget.initialTimes);

    _selectedCity = widget.initialCity;

    if (widget.initialDistance != null) {
      _distance = widget.initialDistance!;
      _enableDistance = true;
    } else {
      _distance = 25.0;
      _enableDistance = false;
    }

    if (_selectedCity != null) {
      _cityController.text = _selectedCity!;
    }

    _cityController.addListener(_onCitySearchChanged);
  }

  @override
  void dispose() {
    _cityDebounce?.cancel();

    _cityController.removeListener(_onCitySearchChanged);

    _cityController.dispose();

    super.dispose();
  }

  void _onCitySearchChanged() {
    final query = _cityController.text.trim();

    _cityDebounce?.cancel();

    // Keep _selectedCity in sync as a plain
    // filter value even before a suggestion
    // is picked.
    _selectedCity = query.isEmpty ? null : query;

    if (query.isEmpty) {
      setState(() {
        _cityPredictions = [];
        _isSearchingCity = false;
      });
      return;
    }

    setState(() => _isSearchingCity = true);

    _cityDebounce = Timer(const Duration(milliseconds: 400), () async {
      final results = await PlacesService.autocomplete(query);

      if (!mounted) return;

      setState(() {
        _cityPredictions = results;
        _isSearchingCity = false;
      });
    });
  }

  void _selectCityPrediction(PlacePrediction prediction) {
    // Autocomplete descriptions look like:
    // "New York, NY, USA"
    //
    // Take the first segment as the city name.
    final cityName = prediction.description.split(',').first.trim();

    setState(() {
      _selectedCity = cityName;
      _cityController.text = cityName;
      _cityPredictions = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final maxSheetHeight = MediaQuery.of(context).size.height * 0.9;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===============================================================
            // HEADER
            // ===============================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.filters,
                  style: AppStyles.w600f18inter.copyWith(
                    color: kDarkTextColor,
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: kDarkTextColor,
                    size: 24,
                  ),
                ),
              ],
            ).withPaddingSymmetric(16, 0),

            20.heightBox,

            const Divider(thickness: 5, color: kCardColor),

            20.heightBox,

            // ===============================================================
            // TIME OF DAY
            // ===============================================================
            TimeOfDayFilterSection(
              selected: _selectedTimes,
              onToggled: (time) => setState(() {
                if (!_selectedTimes.remove(time)) _selectedTimes.add(time);
              }),
            ).withPaddingSymmetric(16, 0),

            24.heightBox,

            // ===============================================================
            // CITY
            // ===============================================================
            Text(
              l10n.city,
              style: AppStyles.w600f14inter.copyWith(color: kDarkTextColor),
            ).withPaddingSymmetric(16, 0),

            6.heightBox,

            // Search City box
            Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: kBorderColor),
              ),
              child: Row(
                children: [
                  16.widthBox,

                  const Icon(
                    Icons.share_location_sharp,
                    color: kTextColor,
                    size: 20,
                  ),

                  8.widthBox,

                  Expanded(
                    child: TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        hintText: l10n.searchCity,
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: AppStyles.w400f14inter,
                    ),
                  ),

                  if (_isSearchingCity)
                    const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else if (_cityController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _cityController.clear();
                          _selectedCity = null;
                          _cityPredictions = [];
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(Icons.close, color: kTextColor, size: 18),
                      ),
                    ),
                ],
              ),
            ).withPaddingSymmetric(16, 0),

            // ===============================================================
            // AUTOCOMPLETE PREDICTIONS
            // ===============================================================
            if (_cityPredictions.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 6),
                constraints: const BoxConstraints(maxHeight: 180),
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kBorderColor),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _cityPredictions.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: kBorderColor),
                  itemBuilder: (context, index) {
                    final prediction = _cityPredictions[index];

                    return ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.location_on_outlined,
                        color: kTextColor,
                        size: 18,
                      ),
                      title: Text(
                        prediction.description,
                        style: AppStyles.w400f14inter.copyWith(
                          color: kDarkTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => _selectCityPrediction(prediction),
                    );
                  },
                ),
              ).withPaddingSymmetric(16, 0),

            12.heightBox,

            // ===============================================================
            // QUICK CITY SELECTION
            // ===============================================================
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _quickCities.map((cityName) {
                  final isSelected =
                      _selectedCity?.toLowerCase() == cityName.toLowerCase();

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedCity = null;
                            _cityController.clear();
                          } else {
                            _selectedCity = cityName;
                            _cityController.text = cityName;
                            _cityPredictions = [];
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? kPrimaryColor : kGreyColor,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? null
                              : Border.all(color: kBorderColor),
                        ),
                        child: Text(
                          cityName,
                          style: AppStyles.w500f12inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            24.heightBox,

            // ===============================================================
            // DISTANCE
            // ===============================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.distance,
                  style: AppStyles.w600f14inter.copyWith(color: kDarkTextColor),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      _enableDistance = !_enableDistance;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _enableDistance ? kPrimaryColor : kGreyColor,
                      borderRadius: BorderRadius.circular(12),
                      border: _enableDistance
                          ? null
                          : Border.all(color: kBorderColor),
                    ),
                    child: Text(
                      _enableDistance
                          ? l10n.withinDistance(_distance.round())
                          : l10n.anyDistance,
                      style: AppStyles.w500f12inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ).withPaddingSymmetric(16, 0),

            6.heightBox,

            Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: _enableDistance
                        ? kPrimaryColor
                        : kBorderColor,
                    thumbColor: kWhiteColor,
                    inactiveTrackColor: kCardColor,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10,
                      elevation: 2,
                    ),
                    trackHeight: 8,
                  ),
                  child: Slider(
                    value: _distance,
                    min: 1,
                    max: 50,
                    onChanged: (val) {
                      setState(() {
                        _distance = val;
                        _enableDistance = true;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '1 km',
                      style: AppStyles.w500f12inter.copyWith(
                        color: kGreyTextColor,
                      ),
                    ),

                    Text(
                      '${_distance.round()} km',
                      style: AppStyles.w500f12inter.copyWith(
                        color: _enableDistance
                            ? kDarkTextColor
                            : kGreyTextColor,
                        fontWeight: _enableDistance
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),

                    Text(
                      '50 km',
                      style: AppStyles.w500f12inter.copyWith(
                        color: kGreyTextColor,
                      ),
                    ),
                  ],
                ).withPaddingSymmetric(16, 0),
              ],
            ),

            32.heightBox,

            // ===============================================================
            // ACTION BUTTONS
            // ===============================================================
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTimes.clear();
                        _selectedCity = null;
                        _enableDistance = false;
                        _distance = 25.0;
                        _cityController.clear();
                        _cityPredictions = [];
                      });
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(76),
                        border: Border.all(color: kBorderColor),
                      ),
                      child: Center(
                        child: Text(
                          l10n.clearFilters,
                          style: AppStyles.w500f16inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                12.widthBox,

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.onApply(
                        {..._selectedTimes},
                        _selectedCity,
                        _enableDistance ? _distance : null,
                      );

                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          l10n.showResults,
                          style: AppStyles.w500f16inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ).withPaddingSymmetric(16, 0),

            12.heightBox,
          ],
        ),
      ),
    );
  }
}
