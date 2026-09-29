import 'package:cached_network_image/cached_network_image.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/bloc/courts_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/match_config_screen.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/payment_method_screen.dart';
import 'package:quadraclub_app/utils/helper/date_formatter.dart';
import 'package:quadraclub_app/utils/helper/time_slot_helper.dart';
import 'package:shimmer/shimmer.dart';

class BookingSummarySheet extends StatefulWidget {
  final Club club;
  final Court court;
  final String? sportName;
  final DateTime date;
  final String startTime;
  final String? endTime;
  final double distance;

  /// Which booking type the sheet opens on. Coming from the "create a
  /// match" flow this is [BookingType.match]; booking straight off the
  /// Courts page it stays [BookingType.individual].
  final BookingType initialBookingType;

  const BookingSummarySheet({
    super.key,
    required this.club,
    required this.court,
    required this.sportName,
    required this.date,
    required this.startTime,
    required this.distance,
    this.endTime,
    this.initialBookingType = BookingType.individual,
  });

  static Future<void> show(
    BuildContext context, {
    required Club club,
    required Court court,
    required String? sportName,
    required DateTime date,
    required String startTime,
    String? endTime,
    required double distance,
    BookingType initialBookingType = BookingType.individual,
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
        distance: distance,
        initialBookingType: initialBookingType,
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

  // Replace: int _selectedDurationSlots = 1;
  static const List<int> _durationOptionsMinutes = [60, 90, 120];
  int _selectedDurationMinutes = 60;

  int? _parseMinutes(String? t) {
    if (t == null) return null;
    final m = RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)?', caseSensitive: false)
        .firstMatch(t.trim());
    if (m == null) return null;

    var h = int.parse(m.group(1)!);
    final min = int.parse(m.group(2)!);
    final ampm = m.group(3)?.toUpperCase();

    if (ampm == 'PM' && h < 12) h += 12;
    if (ampm == 'AM' && h == 12) h = 0;

    return h * 60 + min;
  }

  /// Length of one slot in minutes, read from the slot data.
  int get _slotMinutes {
    for (final s in _daySlotsForSport) {
      final st = _parseMinutes(s.startTime);
      final en = _parseMinutes(s.endTime);
      if (st != null && en != null && en > st) return en - st;
    }
    return 60;
  }

  /// How many slots a duration needs (0 = not possible with this slot length).
  /// Slots that must be free to cover this duration (rounded up).
  int _slotsFor(int minutes) => (minutes / _slotMinutes).ceil();

  String _formatTime(int totalMinutes) {
    final h = (totalMinutes ~/ 60) % 24;
    final m = totalMinutes % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  /// End time = start + duration (in minutes), e.g. 08:00 + 90 -> 09:30.
  String? _endTimeForDuration(String startTime, int durationMinutes) {
    final all = _daySlotsForSport;
    final startIndex = all.indexWhere((s) => s.startTime == startTime);
    final startMin = _parseMinutes(startTime);
    final slotsNeeded = _slotsFor(durationMinutes);

    if (startIndex == -1 ||
        startMin == null ||
        startIndex + slotsNeeded > all.length) {
      return null;
    }

    return _formatTime(startMin + durationMinutes);
  }

  String _formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final r = minutes % 60;
    return r == 0 ? '${h}h' : '$h:${r.toString().padLeft(2, '0')}h';
  }

  late BookingType _bookingType;

  String _dateKey(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');

    return '$y-$m-$day';
  }

  /// Every court in the club that offers this sport.
  List<Court> get _eligibleCourts {
    final sport = (widget.sportName ?? '').toLowerCase();

    return widget.club.courts
        .where(
          (c) =>
              c.sports.any((s) => (s.sportName ?? '').toLowerCase() == sport),
        )
        .toList();
  }

  /// The full ordered slot list for the current
  /// court/date/sport.
  List<Padel> get _daySlotsForSport {
    final daySlots = _selectedCourt.weeklySlots[_dateKey(widget.date)];

    if (daySlots == null) {
      return const [];
    }

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

  bool _isBookable(Padel slot) {
    if (slot.status != 'Available') return false;
    return !TimeSlotHelper.isSlotInPast(widget.date, slot.startTime);
  }

  List<Padel> get _startableSlots =>
      _daySlotsForSport.where(_isBookable).toList();

  int _maxContiguousFrom(String startTime) {
    final all = _daySlotsForSport;

    final startIndex = all.indexWhere((s) => s.startTime == startTime);

    if (startIndex == -1) {
      return 0;
    }

    var count = 0;

    for (var i = startIndex; i < all.length; i++) {
      if (!_isBookable(all[i])) {
        break;
      }

      count++;
    }

    return count;
  }

  Sport? get _sportInfo {
    final sport = (widget.sportName ?? '').toLowerCase();

    for (final s in _selectedCourt.sports) {
      if ((s.sportName ?? '').toLowerCase() == sport) {
        return s;
      }
    }

    return null;
  }

  double get _hourlyRate => (_sportInfo?.hourlyRate ?? 10).toDouble();

  double get _amount => _hourlyRate * _selectedDurationMinutes / 60;

  @override
  void initState() {
    super.initState();

    _selectedCourt = widget.court;
    _selectedStartTime = widget.startTime;
    _bookingType = widget.initialBookingType;

    _selectedEndTime =
        widget.endTime ??
            _endTimeForDuration(_selectedStartTime, _selectedDurationMinutes);
    if (context.read<CourtsBloc>().state.players.isEmpty) {
      context.read<CourtsBloc>().add(FetchAllUsers());
    }
  }

  void _onCourtSelected(Court court) {
    setState(() {
      _selectedCourt = court;
      _selectedDurationMinutes = 60;

      final slots = _startableSlots;

      final match = slots.where((s) => s.startTime == _selectedStartTime);

      if (match.isNotEmpty) {
        _selectedEndTime = _endTimeForDuration(_selectedStartTime, 60);
      } else if (slots.isNotEmpty) {
        _selectedStartTime = slots.first.startTime ?? _selectedStartTime;
        _selectedEndTime = _endTimeForDuration(_selectedStartTime, 60);
      } else {
        _selectedEndTime = null;
      }
    });
  }

  void _onDurationSelected(int minutes) {
    if (_maxContiguousFrom(_selectedStartTime) < _slotsFor(minutes)) {
      return;
    }

    final end = _endTimeForDuration(_selectedStartTime, minutes);
    if (end == null) return;

    setState(() {
      _selectedDurationMinutes = minutes;
      _selectedEndTime = end;
    });
  }

  String get _dateLabel {
    const weekdays = dayNames;
    const months = monthNames;

    final d = widget.date;

    return '${weekdays[d.weekday - 1]}, '
        '${months[d.month - 1]} ${d.day}';
  }

  String get _locationLabel {
    final city = widget.club.city ?? '';
    final state = widget.club.state ?? '';

    if (city.isEmpty) {
      return state;
    }

    if (state.isEmpty) {
      return city;
    }

    return '$city, $state';
  }

  void _onPrimaryTap() {
    if (_selectedEndTime == null) {
      return;
    }

    if (_bookingType == BookingType.individual) {
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentMethodScreen(
            club: widget.club,
            court: _selectedCourt,
            dateLabel: _dateLabel,
            startTime: _selectedStartTime,
            endTime: _selectedEndTime ?? '',
            bookingDate: widget.date,
            timeLabel: '$_selectedStartTime-$_selectedEndTime',
            amount: _amount,
            distance: widget.distance,
          ),
        ),
      );
    } else {
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MatchConfigScreen(
            club: widget.club,
            court: _selectedCourt,
            startTime: _selectedStartTime,
            endTime: _selectedEndTime ?? '',
            bookingDate: widget.date,
            dateLabel: _dateLabel,
            timeLabel: '$_selectedStartTime-$_selectedEndTime',
            amount: _amount,
            distance: widget.distance,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final isIndividual = _bookingType == BookingType.individual;

    final startableSlots = _startableSlots;

    final maxContiguous = _maxContiguousFrom(_selectedStartTime);

    final canBook = _selectedEndTime != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.bookingSummary,
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

            16.heightBox,

            Text(
              l10n.courtDetails,
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
                      height: 72,
                      width: 72,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 72,
                          width: 72,
                          decoration: const BoxDecoration(color: Colors.white),
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        return Image.asset(
                          Assets.png.clubLogo.path,
                          height: 72,
                          width: 72,
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
                          '$_locationLabel • '
                          '${formatDistanceKm(widget.distance, AppLocalizations.of(context)!)}',
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

            14.heightBox,

            Text(
              l10n.court,
              style: AppStyles.w500f12inter.copyWith(
                color: kDarkTextColor.withValues(alpha: 0.7),
              ),
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
                            color: kDarkTextColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ).withPaddingSymmetric(16, 0),

            14.heightBox,

            if (startableSlots.isNotEmpty) ...[
              Text(
                '${l10n.time} • ${_formatDuration(_selectedDurationMinutes)}',
                style: AppStyles.w500f12inter.copyWith(
                  color: kDarkTextColor.withValues(alpha: 0.7),
                ),
              ).withPaddingSymmetric(16, 0),

              8.heightBox,

              Row(
                children: _durationOptionsMinutes.map((minutes) {
                  final isSelected = _selectedDurationMinutes == minutes;
                  final enabled = maxContiguous >= _slotsFor(minutes) &&
                      _endTimeForDuration(_selectedStartTime, minutes) != null;

                  final end = _endTimeForDuration(_selectedStartTime, minutes);
                  final label = end != null
                      ? '$_selectedStartTime-$end'
                      : _formatDuration(minutes);

                  return Expanded(
                    child: GestureDetector(
                      onTap: enabled ? () => _onDurationSelected(minutes) : null,
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

              14.heightBox,
            ],

            Text(
              l10n.bookingType,
              style: AppStyles.w500f12inter.copyWith(
                color: kDarkTextColor.withValues(alpha: 0.7),
              ),
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
                          topLeft: Radius.circular(16),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          l10n.reserveIndividual,
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
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          l10n.createAMatch,
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
                        ? l10n.bookCourtWithoutMatch
                        : l10n.createGameForPlayers,
                    style: AppStyles.w400f12inter.copyWith(
                      color: kDarkTextColor.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ).withPaddingSymmetric(16, 0),

            16.heightBox,

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
                          ? '${l10n.book} - '
                                '${formatPrice(_amount)}'
                          : '${l10n.configureMatch} - '
                                '${formatPrice(_amount)}',
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
