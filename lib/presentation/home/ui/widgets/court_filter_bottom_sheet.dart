import 'package:quadraclub_app/app_exports.dart';

class CourtFilterBottomSheet extends StatefulWidget {
  final String? initialTimeOfDay;
  final String? initialCity;
  final double initialDistance;
  final Function(String? timeOfDay, String? city, double distance) onApply;

  const CourtFilterBottomSheet({
    super.key,
    this.initialTimeOfDay,
    this.initialCity,
    required this.initialDistance,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    String? initialTimeOfDay,
    String? initialCity,
    required double initialDistance,
    required Function(String? timeOfDay, String? city, double distance) onApply,
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
          initialTimeOfDay: initialTimeOfDay,
          initialCity: initialCity,
          initialDistance: initialDistance,
          onApply: onApply,
        ),
      ),
    );
  }

  @override
  State<CourtFilterBottomSheet> createState() => _CourtFilterBottomSheetState();
}

class _CourtFilterBottomSheetState extends State<CourtFilterBottomSheet> {
  String? _selectedTimeOfDay;
  String? _selectedCity;
  double _distance = 25.0;
  final TextEditingController _cityController = TextEditingController();

  final List<Map<String, String>> _timeSlots = [
    {'label': 'Morning', 'time': '6h - 12h'},
    {'label': 'Afternoon', 'time': '12h - 18h'},
    {'label': 'Night', 'time': '6 PM - 12 AM'},
  ];

  final List<Map<String, dynamic>> _quickCities = [
    {'name': 'New York', 'dist': '0 km'},
    {'name': 'Los Angeles', 'dist': '10 km'},
    {'name': 'Chicago', 'dist': '15 km'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedTimeOfDay = widget.initialTimeOfDay;
    _selectedCity = widget.initialCity;
    _distance = widget.initialDistance;
    if (_selectedCity != null) {
      _cityController.text = _selectedCity!;
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Filters',
              style: AppStyles.w600f18inter.copyWith(
                color: kDarkTextColor,
                fontSize: 20,
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
        ),
        const SizedBox(height: 20),
        const Divider(height: 1, color: kBorderColor),
        const SizedBox(height: 20),

        // Time of Day
        Text(
          'Time of Day',
          style: AppStyles.w600f14inter.copyWith(color: kDarkTextColor),
        ),
        const SizedBox(height: 12),
        Row(
          children: _timeSlots.map((slot) {
            final isSelected = _selectedTimeOfDay == slot['label'];
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTimeOfDay = isSelected ? null : slot['label'];
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimaryColor : kCardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected ? null : Border.all(color: kBorderColor),
                  ),
                  child: Column(
                    children: [
                      Text(
                        slot['label']!,
                        style: AppStyles.w600f14inter.copyWith(
                          color: kDarkTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        slot['time']!,
                        style: AppStyles.w400f12inter.copyWith(
                          color: kTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // City Section
        Text(
          'City',
          style: AppStyles.w600f14inter.copyWith(color: kDarkTextColor),
        ),
        const SizedBox(height: 12),
        // Search City box
        Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: kBorderColor),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              const Icon(Icons.location_on_outlined, color: kTextColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    hintText: 'Search city',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: AppStyles.w400f14inter,
                  onChanged: (val) {
                    setState(() {
                      _selectedCity = val.trim().isEmpty ? null : val.trim();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Quick city selection chips
        Row(
          children: _quickCities.map((city) {
            final isSelected = _selectedCity?.toLowerCase() == city['name'].toString().toLowerCase();
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedCity = null;
                      _cityController.clear();
                    } else {
                      _selectedCity = city['name'];
                      _cityController.text = city['name'];
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimaryColor : kCardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected ? null : Border.all(color: kBorderColor),
                  ),
                  child: Column(
                    children: [
                      Text(
                        city['name'],
                        style: AppStyles.w600f14inter.copyWith(
                          color: kDarkTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        city['dist'],
                        style: AppStyles.w400f12inter.copyWith(
                          color: kTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Distance Section
        Text(
          'Distance',
          style: AppStyles.w600f14inter.copyWith(color: kDarkTextColor),
        ),
        const SizedBox(height: 12),
        // Use SliderTheme to build custom slider exactly matching UI
        Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: kPrimaryColor,
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
                  style: AppStyles.w500f12inter.copyWith(color: kGreyTextColor),
                ),
                Text(
                  '${_distance.toStringAsFixed(0)} km',
                  style: AppStyles.w500f12inter.copyWith(color: kGreyTextColor),
                ),
                Text(
                  '50 km',
                  style: AppStyles.w500f12inter.copyWith(color: kGreyTextColor),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Action Buttons
        Row(
          children: [
            // Clear Filters
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTimeOfDay = null;
                    _selectedCity = null;
                    _distance = 25.0;
                    _cityController.clear();
                  });
                },
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: kBorderColor),
                  ),
                  child: Center(
                    child: Text(
                      'Clear Filters',
                      style: AppStyles.w600f14inter.copyWith(color: kDarkTextColor),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Show Results
            Expanded(
              child: GestureDetector(
                onTap: () {
                  widget.onApply(_selectedTimeOfDay, _selectedCity, _distance);
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
                      'Show Results',
                      style: AppStyles.w600f14inter.copyWith(color: kDarkTextColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    ));
  }
}
