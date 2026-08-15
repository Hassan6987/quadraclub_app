// lib/presentation/booking/ui/widgets/booking_summary_sheet.dart
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';
import 'package:quadraclub_app/presentation/home/data/court_model.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/match_config_screen.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/payment_method_screen.dart';

class BookingSummarySheet extends StatefulWidget {
  final CourtModel court;
  final SportType sport;
  final DateTime date;
  final int blockIndex;
  final String startTime;

  const BookingSummarySheet({
    super.key,
    required this.court,
    required this.sport,
    required this.date,
    required this.blockIndex,
    required this.startTime,
  });

  static Future<void> show(
    BuildContext context, {
    required CourtModel court,
    required SportType sport,
    required DateTime date,
    required int blockIndex,
    required String startTime,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => BookingSummarySheet(
        court: court,
        sport: sport,
        date: date,
        blockIndex: blockIndex,
        startTime: startTime,
      ),
    );
  }

  @override
  State<BookingSummarySheet> createState() => _BookingSummarySheetState();
}

class _BookingSummarySheetState extends State<BookingSummarySheet> {
  late int _selectedBlock;
  late Duration _selectedDuration;
  BookingType _bookingType = BookingType.individual;

  final List<Duration> _durationOptions = const [
    Duration(hours: 1),
    Duration(minutes: 90),
    Duration(hours: 2),
  ];

  @override
  void initState() {
    super.initState();
    _selectedBlock = widget.blockIndex;
    _selectedDuration = _durationOptions.first;
  }

  String get _endTime => addDurationToTime(widget.startTime, _selectedDuration);

  String get _dateLabel {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final d = widget.date;
    return '${weekdays[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}';
  }

  void _onPrimaryTap() {
    if (_bookingType == BookingType.individual) {
      Navigator.pop(context); // close sheet
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentMethodScreen(
            court: widget.court,
            dateLabel: _dateLabel,
            timeLabel: '${widget.startTime}-$_endTime',
            blockLabel: 'Block ${_selectedBlock + 1}',
            amount: widget.court.demoPricePerBooking,
          ),
        ),
      );
    } else {
      Navigator.pop(context); // close sheet
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MatchConfigScreen(
            court: widget.court,
            dateLabel: _dateLabel,
            timeLabel: '${widget.startTime}-$_endTime',
            blockLabel: 'Block ${_selectedBlock + 1}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIndividual = _bookingType == BookingType.individual;

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
                    Icons.close,
                    color: kDarkTextColor,
                    size: 24,
                  ),
                ),
              ],
            ).withPaddingSymmetric(16, 0),
            30.heightBox,

            // Court details card
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
                  border: Border.all(color: kBorderF0)
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AppCachedImage(
                      imageUrl: widget.court.imageUrl,
                      width: 96,
                      height: 96,
                    ),
                  ),
                  12.widthBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.court.name,
                          style: AppStyles.w600f16inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                        Text(
                          '${widget.court.location} • ${widget.court.distanceMiles} miles',
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

            Text(
              'BLOCK',
              style: AppStyles.w500f12inter.copyWith(
                  color: kDarkTextColor.withValues(alpha: 0.7)),
            ).withPaddingSymmetric(16, 0),
            8.heightBox,
            Row(
              children: List.generate(3, (index) {
                final isSelected = _selectedBlock == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedBlock = index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? kPrimaryColor : kGreyColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Block ${index + 1}',
                          style: AppStyles.w500f14inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ).withPaddingSymmetric(16, 0),
            20.heightBox,

            Text(
              'Time • ${_selectedDuration.inMinutes ~/ 60}h${_selectedDuration.inMinutes % 60 == 0 ? '' : ' 30m'}',
              style: AppStyles.w500f12inter.copyWith(
                  color: kDarkTextColor.withValues(alpha: 0.7)),
            ).withPaddingSymmetric(16, 0),
            8.heightBox,
            Row(
              children: _durationOptions.map((duration) {
                final isSelected = _selectedDuration == duration;
                final label =
                    '${widget.startTime}-${addDurationToTime(widget.startTime, duration)}';
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDuration = duration),
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
                              fontSize: 13
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ).withPaddingSymmetric(16, 0),
            20.heightBox,

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
                          borderRadius: BorderRadius.only(bottomLeft: Radius
                              .circular(16), topLeft: Radius.circular(16))
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
                          borderRadius: BorderRadius.only(bottomRight: Radius
                              .circular(16), topRight: Radius.circular(16))
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
              onTap: _onPrimaryTap,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(76),
                ),
                child: Center(
                  child: Text(
                    isIndividual
                        ? 'Book - ${formatPrice(widget.court.demoPricePerBooking)}'
                        : 'Configure Match - ${formatPrice(widget.court.demoPricePerBooking)}',
                    style: AppStyles.w500f16inter.copyWith(
                      color: kDarkTextColor,
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
