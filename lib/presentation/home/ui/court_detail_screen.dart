// lib/presentation/booking/ui/court_detail_screen.dart
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';
import 'package:quadraclub_app/presentation/home/data/court_model.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/booking_summary_sheet.dart';

class _TimeSlot {
  final String time;
  final bool available;
  const _TimeSlot(this.time, this.available);
}

class CourtDetailScreen extends StatefulWidget {
  final CourtModel court;

  const CourtDetailScreen({super.key, required this.court});

  @override
  State<CourtDetailScreen> createState() => _CourtDetailScreenState();
}

class _CourtDetailScreenState extends State<CourtDetailScreen> {
  late SportType _selectedSport;
  late DateTime _selectedDate;
  late List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    _selectedSport = widget.court.sports.first;
    _selectedDate = DateTime.now();
    _dates = List.generate(7, (i) => DateTime.now().add(Duration(days: i)));
  }

  // 3 identical demo blocks, each derived from the court's hourly slots,
  // expanded to half-hour granularity, with the 10:xx slot marked
  // unavailable to mirror the mock.
  List<_TimeSlot> _buildSlotsForBlock() {
    final hourlySlots = widget.court.timeSlots[_selectedSport] ?? [];
    final List<_TimeSlot> slots = [];
    for (final hourSlot in hourlySlots) {
      final hour = int.tryParse(hourSlot.split(':')[0]) ?? 0;
      final available = hour != 10;
      slots.add(_TimeSlot('${hour.toString().padLeft(2, '0')}:00', available));
      slots.add(_TimeSlot('${hour.toString().padLeft(2, '0')}:30', available));
    }
    return slots;
  }

  void _onTimeSlotTap(int blockIndex, String time) {
    BookingSummarySheet.show(
      context,
      court: widget.court,
      sport: _selectedSport,
      date: _selectedDate,
      blockIndex: blockIndex,
      startTime: time,
    );
  }

  @override
  Widget build(BuildContext context) {
    final court = widget.court;
    final slots = _buildSlotsForBlock();

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: CustomScrollView(
        slivers: [
          // Collapsible image header
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: kWhiteColor,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: kBorderColor),
                  ),
                  child: const Icon(Icons.arrow_back, color: kDarkTextColor),
                ),
              ),
            ),
            title: Text(
              'Court Details',
              style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: AppCachedImage(
                imageUrl: court.imageUrl,
                width: double.infinity,
                height: 120,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    court.name,
                    style: AppStyles.w600f16inter.copyWith(
                      color: kDarkTextColor,
                    ),
                  ),
                  4.heightBox,
                  Text(
                    '${court.location} • ${court.distanceMiles} miles',
                    style: AppStyles.w400f14inter.copyWith(color: kTextColor),
                  ),

                  // Amenities
                  SizedBox(
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: court.demoAmenities.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: kGreyColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              court.demoAmenities[index],
                              style: AppStyles.w400f12inter.copyWith(
                                color: kDarkTextColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  10.heightBox,
                  Divider(color: kBorderColor, thickness: 5),
                  10.heightBox,
                  Text(
                    'Available Time Slots',
                    style: AppStyles.w500f14inter.copyWith(
                      color: kDarkTextColor,
                    ),
                  ),
                  12.heightBox,

                  // Sport tabs
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: court.sports.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final sport = court.sports[index];
                        final isSelected = _selectedSport == sport;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSport = sport),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? kPrimaryColor : kGreyColor,
                              borderRadius: BorderRadius.circular(12),
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

                  // Date selector (reusing existing shared widget)
                  CommonDateSelectionRow(
                    dates: _dates,
                    selectedDate: _selectedDate,
                    onDateSelected: (date) =>
                        setState(() => _selectedDate = date),
                  ),
                  10.heightBox,
                  Divider(color: kBorderColor, thickness: 5),
                  10.heightBox,

                  // 3 demo blocks
                  ...List.generate(3, (blockIndex) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Block ${blockIndex + 1}',
                            style: AppStyles.w600f14inter.copyWith(
                              color: kDarkTextColor,
                            ),
                          ),
                          10.heightBox,
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: slots.map((slot) {
                              return GestureDetector(
                                onTap: slot.available
                                    ? () =>
                                          _onTimeSlotTap(blockIndex, slot.time)
                                    : null,
                                child: Opacity(
                                  opacity: slot.available ? 1.0 : 0.5,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: kWhiteColor,
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(color: kBorderColor),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          slot.time,
                                          style: AppStyles.w500f14inter
                                              .copyWith(color: kDarkTextColor),
                                        ),
                                        4.widthBox,
                                        if (slot.available) ...[
                                          const CircleAvatar(
                                            radius: 3,
                                            backgroundColor: kGreen06,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
