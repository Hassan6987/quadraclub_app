// lib/presentation/booking/ui/widgets/booking_summary_sheet.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/match_config_screen.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/payment_method_screen.dart';
import 'package:shimmer/shimmer.dart';

class BookingSummarySheet extends StatefulWidget {
  final Club club;
  final Court court;
  final String? sportName;
  final DateTime date;
  final String startTime;
  final String? endTime;

  const BookingSummarySheet({
    super.key,
    required this.club,
    required this.court,
    required this.sportName,
    required this.date,
    required this.startTime,
    this.endTime,
  });

  static Future<void> show(BuildContext context, {
    required Club club,
        required Court court,
    required String? sportName,
    required DateTime date,
    required String startTime,
    String? endTime,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => BookingSummarySheet(
        club: club,
        court: court,
        sportName: sportName,
        date: date,
        startTime: startTime,
        endTime: endTime,
      ),
    );
  }

  @override
  State<BookingSummarySheet> createState() => _BookingSummarySheetState();
}

class _BookingSummarySheetState extends State<BookingSummarySheet> {
  late Court _selectedCourt;
  late String _selectedStartTime;
  late String? _selectedEndTime;
  int _selectedDurationSlots = 1;
  BookingType _bookingType = BookingType.individual;

  String _dateKey(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  /// Every court in the club that offers this sport — lets the user
  /// switch courts, the same role the mock's "Block" picker played,
  /// but driven by which courts actually exist and carry this sport.
  List<Court> get _eligibleCourts {
    final sport = (widget.sportName ?? '').toLowerCase();
    return widget.club.courts
        .where((c) =>
        c.sports.any((s) => (s.sportName ?? '').toLowerCase() == sport))
        .toList();
  }

  /// The full ordered slot list for the current court/date/sport,
  /// Available and Booked alike — needed to check contiguity.
  /// WeeklySlot only decodes "Tennis"/"Padel" keys today.
  List<Padel> get _daySlotsForSport {
    final daySlots = _selectedCourt.weeklySlots[_dateKey(widget.date)];
    if (daySlots == null) return const [];

    final sport = (widget.sportName ?? '').toLowerCase();
    switch (sport) {
      case 'tennis':
        return daySlots.tennis;
      case 'padel':
        return daySlots.padel;
      case 'pickleball':
        return daySlots.pickleball;
      case 'beach tennis':
      case 'beach_tennis':
        return daySlots.beachTennis;
      default:
        return const [];
    }
  }

  List<Padel> get _startableSlots =>
      _daySlotsForSport.where((s) => s.status == 'Available').toList();

  int _maxContiguousFrom(String startTime) {
    final all = _daySlotsForSport;
    final startIndex = all.indexWhere((s) => s.startTime == startTime);
    if (startIndex == -1) return 0;
    var count = 0;
    for (var i = startIndex; i < all.length; i++) {
      if (all[i].status != 'Available') break;
      count++;
    }
    return count;
  }

  String? _endTimeForDuration(String startTime, int durationSlots) {
    final all = _daySlotsForSport;
    final startIndex = all.indexWhere((s) => s.startTime == startTime);
    if (startIndex == -1 || startIndex + durationSlots - 1 >= all.length)
      return null;
    return all[startIndex + durationSlots - 1].endTime;
  }

  Sport? get _sportInfo {
    final sport = (widget.sportName ?? '').toLowerCase();
    for (final s in _selectedCourt.sports) {
      if ((s.sportName ?? '').toLowerCase() == sport) return s;
    }
    return null;
  }

  double get _hourlyRate => (_sportInfo?.hourlyRate ?? 10).toDouble();

  double get _amount => _hourlyRate * _selectedDurationSlots;

  @override
  void initState() {
    super.initState();
    _selectedCourt = widget.court;
    _selectedStartTime = widget.startTime;
    _selectedEndTime = widget.endTime;
  }

  void _onCourtSelected(Court court) {
    setState(() {
      _selectedCourt = court;
      _selectedDurationSlots = 1;
      final slots = _startableSlots;
      final match = slots.where((s) => s.startTime == _selectedStartTime);
      if (match.isNotEmpty) {
        _selectedEndTime = match.first.endTime;
      } else if (slots.isNotEmpty) {
        _selectedStartTime = slots.first.startTime ?? _selectedStartTime;
        _selectedEndTime = slots.first.endTime;
      } else {
        _selectedEndTime = null;
      }
    });
  }

  void _onDurationSelected(int slots) {
    if (_maxContiguousFrom(_selectedStartTime) < slots) return;
    setState(() {
      _selectedDurationSlots = slots;
      _selectedEndTime = _endTimeForDuration(_selectedStartTime, slots);
    });
  }

  String get _dateLabel {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final d = widget.date;
    return '${weekdays[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}';
  }

  String get _locationLabel {
    final city = widget.club.city ?? '';
    final state = widget.club.state ?? '';
    if (city.isEmpty) return state;
    if (state.isEmpty) return city;
    return '$city, $state';
  }

  void _onPrimaryTap() {
    if (_selectedEndTime == null) return;

    if (_bookingType == BookingType.individual) {
      Navigator.pop(context); // close sheet
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentMethodScreen(
            club: widget.club,
            court: _selectedCourt,
            dateLabel: _dateLabel,
            timeLabel: '$_selectedStartTime-$_selectedEndTime',
            amount: _amount,
          ),
        ),
      );
    } else {
      Navigator.pop(context); // close sheet
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MatchConfigScreen(
            club: widget.club,
            court: _selectedCourt,
            dateLabel: _dateLabel,
            timeLabel: '$_selectedStartTime-$_selectedEndTime',
            amount: _amount,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIndividual = _bookingType == BookingType.individual;
    final startableSlots = _startableSlots;
    final maxContiguous = _maxContiguousFrom(_selectedStartTime);
    final canBook = _selectedEndTime != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking Summary',
                  style: AppStyles.w600f16inter.copyWith(
                    color: kDarkTextColor,
                    fontSize: 18,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                      Icons.close, color: kDarkTextColor, size: 24),
                ),
              ],
            ).withPaddingSymmetric(16, 0),
            30.heightBox,

            // Club / court details card
            Text(
              "COURT DETAILS",
              style: AppStyles.w500f12inter.copyWith(
                color: kDarkTextColor.withValues(alpha: 0.7),
              ),
            ).withPaddingSymmetric(16, 0),
            8.heightBox,
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: kBorderF0),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: widget.club.photo ?? '',
                      height: 96,
                      width: 96,
                      placeholder: (context, url) =>
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
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
                  12.widthBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.club.name ?? '',
                          style: AppStyles.w600f16inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                        Text(
                          // Distance isn't real geodata yet — carried over
                          // from the original mock as a visual placeholder.
                          '$_locationLabel  •  2.5 miles',
                          style: AppStyles.w400f14inter.copyWith(
                            color: kGreyTextColor,
                          ),
                        ),
                        Text(
                          _dateLabel,
                          style: AppStyles.w500f12inter.copyWith(
                            color: kLightGreenColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).withPaddingSymmetric(16, 0),
            20.heightBox,

            // Court switcher — only shown when more than one court in
            // this club offers the sport being booked.
            Text(
              'COURT',
              style: AppStyles.w500f12inter.copyWith(
                  color: kDarkTextColor.withValues(alpha: 0.7)),
            ).withPaddingSymmetric(16, 0),
            8.heightBox,
            Row(
              children: _eligibleCourts.map((court) {
                final isSelected = court.id == _selectedCourt.id;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onCourtSelected(court),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? kPrimaryColor : kGreyColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          court.courtName ?? '',
                          style: AppStyles.w500f14inter.copyWith(
                              color: kDarkTextColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ).withPaddingSymmetric(16, 0),
            20.heightBox,

            if (startableSlots.isNotEmpty) ...[
              Text(
                'TIME',
                style: AppStyles.w500f12inter.copyWith(
                    color: kDarkTextColor.withValues(alpha: 0.7)),
              ).withPaddingSymmetric(16, 0),
              8.heightBox,
              Row(
                children: [1, 2, 3].map((slots) {
                  final isSelected = _selectedDurationSlots == slots;
                  final enabled = maxContiguous >= slots;
                  final end = _endTimeForDuration(_selectedStartTime, slots);
                  final label = end != null
                      ? '$_selectedStartTime-$end'
                      : '${slots}h';
                  return Expanded(
                    child: GestureDetector(
                      onTap: enabled ? () => _onDurationSelected(slots) : null,
                      child: Opacity(
                        opacity: enabled ? 1.0 : 0.4,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? kPrimaryColor : kGreyColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              label,
                              style: AppStyles.w500f12inter.copyWith(
                                color: kDarkTextColor,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ).withPaddingSymmetric(16, 0),
              20.heightBox,
            ],

            Text(
              'BOOKING TYPE',
              style: AppStyles.w500f12inter.copyWith(
                  color: kDarkTextColor.withValues(alpha: 0.7)),
            ).withPaddingSymmetric(16, 0),
            8.heightBox,
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _bookingType = BookingType.individual),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isIndividual ? kPrimaryColor : kGreyColor,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            topLeft: Radius.circular(16)),
                      ),
                      child: Center(
                        child: Text(
                          'Reserve Individual',
                          style: AppStyles.w500f14inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _bookingType = BookingType.match),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: !isIndividual ? kPrimaryColor : kGreyColor,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(16),
                            topRight: Radius.circular(16)),
                      ),
                      child: Center(
                        child: Text(
                          'Create a Match',
                          style: AppStyles.w500f14inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ).withPaddingSymmetric(16, 0),
            8.heightBox,
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: kDarkTextColor.withValues(alpha: 0.7),
                ),
                6.widthBox,
                Expanded(
                  child: Text(
                    isIndividual
                        ? 'Book the court without creating a match in the app.'
                        : 'Create a game where other players can join.',
                    style: AppStyles.w400f12inter.copyWith(
                        color: kDarkTextColor.withValues(alpha: 0.7)),
                  ),
                ),
              ],
            ).withPaddingSymmetric(16, 0),
            24.heightBox,

            GestureDetector(
              onTap: canBook ? _onPrimaryTap : null,
              child: Opacity(
                opacity: canBook ? 1.0 : 0.5,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(76),
                  ),
                  child: Center(
                    child: Text(
                      isIndividual
                          ? 'Book - ${formatPrice(_amount)}'
                          : 'Configure Match - ${formatPrice(_amount)}',
                      style: AppStyles.w500f16inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            ).withPaddingSymmetric(16, 0),
          ],
        ),
      ),
    );
  }
}