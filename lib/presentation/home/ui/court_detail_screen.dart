import 'package:cached_network_image/cached_network_image.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/common/widgets/slot_scroll_sync.dart';
import 'package:quadraclub_app/presentation/home/bloc/courts_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/booking_summary_sheet.dart';
import 'package:quadraclub_app/utils/helper/date_formatter.dart';
import 'package:quadraclub_app/utils/helper/time_slot_helper.dart';
import 'package:shimmer/shimmer.dart';

class CourtDetailScreen extends StatefulWidget {
  final Club club;
  final double distance;

  /// Carried over from "Create Match" so the Booking Summary opens on the
  /// right booking type.
  final BookingType bookingIntent;

  const CourtDetailScreen({
    super.key,
    required this.club,
    required this.distance,
    this.bookingIntent = BookingType.individual,
  });

  @override
  State<CourtDetailScreen> createState() => _CourtDetailScreenState();
}

class _CourtDetailScreenState extends State<CourtDetailScreen> {
  static const double _photoHeight = 100;

  String? _selectedSportSlug;
  late final DateTime _anchorDate;
  late DateTime _selectedDate;
  late List<DateTime> _dates;

  /// All court slot rows scroll together.
  final SlotScrollSync _slotScrollSync = SlotScrollSync();

  final Map<String, ScrollController> _courtScrollControllers = {};

  // ------------------------------------------------------------
  // Sports
  // ------------------------------------------------------------

  /// Unique sport slugs across every court in the club, so tab labels and
  /// weeklySlots lookups agree whatever casing the API sends.
  List<String> get _sportSlugs {
    final slugs = <String>{};

    for (final court in widget.club.courts) {
      for (final sport in court.sports) {
        if ((sport.sportName ?? '').isNotEmpty) {
          slugs.add(sportSlug(sport.sportName));
        }
      }
    }

    return slugs.toList();
  }

  @override
  void initState() {
    super.initState();

    final slugs = _sportSlugs;

    _selectedSportSlug = slugs.isNotEmpty ? slugs.first : null;

    final now = DateTime.now();

    _anchorDate = DateTime(now.year, now.month, now.day);

    _selectedDate = _anchorDate;

    _dates = List.generate(14, (i) => _anchorDate.add(Duration(days: i)));
  }

  @override
  void dispose() {
    _slotScrollSync.dispose();

    _courtScrollControllers.clear();

    super.dispose();
  }

  ScrollController _courtScrollController(String key) {
    return _courtScrollControllers[key] ??= _slotScrollSync.create();
  }

  // ------------------------------------------------------------
  // Date
  // ------------------------------------------------------------

  String _dateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');

    return '$y-$m-$d';
  }

  // ------------------------------------------------------------
  // Location
  // ------------------------------------------------------------

  String get _locationLabel {
    final city = widget.club.city ?? '';
    final state = widget.club.state ?? '';

    if (city.isEmpty) return state;

    if (state.isEmpty) return city;

    return '$city, $state';
  }

  String get _photoUrl =>
      widget.club.photo is String ? widget.club.photo as String : '';

  // ------------------------------------------------------------
  // Matching courts
  // ------------------------------------------------------------

  /// Every physical court in the club that offers the currently
  /// selected sport — usually one, but the UI supports several.
  List<Court> get _matchingCourts {
    final sport = _selectedSportSlug;

    if (sport == null) return const [];

    return widget.club.courts.where((court) {
      return court.sports.any((s) => sportSlug(s.sportName) == sport);
    }).toList();
  }

  /// Slots for [court] on the selected date, for the selected sport.
  List<Padel> _slotsFor(Court court) {
    final daySlots = court.weeklySlots[_dateKey(_selectedDate)];

    if (daySlots == null) return const [];

    switch (_selectedSportSlug) {
      case 'tennis':
        return daySlots.tennis;

      case 'padel':
        return daySlots.padel;

      case 'pickleball':
        return daySlots.pickleball;

      case 'beach_tennis':
        return daySlots.beachTennis;

      default:
        return const [];
    }
  }

  void _onTimeSlotTap(Court court, Padel slot) {
    if (slot.status != 'Available') return;
    if (TimeSlotHelper.isSlotInPast(_selectedDate, slot.startTime)) return;

    context.read<CourtsBloc>().add(LoadPortfolio());

    BookingSummarySheet.show(
      context,
      club: widget.club,
      date: _selectedDate,
      startTime: slot.startTime ?? '',
      sportName: _selectedSportSlug,
      court: court,
      distance: widget.distance,
      initialBookingType: widget.bookingIntent,
    );
  }

  // ------------------------------------------------------------
  // Build
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sportSlugs = _sportSlugs;

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: CustomAppBar(
        showBackIcon: true,
        showActions: false,
        title: l10n.clubDetails,
        titleStyle: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildPhoto(),

          16.heightBox,

          _buildClubSummary(),

          16.heightBox,

          const _EdgeToEdgeDivider(),

          16.heightBox,

          Text(
            l10n.availableTimeSlots,
            style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
          ).withPaddingSymmetric(16, 0),

          12.heightBox,

          if (sportSlugs.isEmpty)
            Text(
              l10n.noSportsInformationAvailable,
              style: AppStyles.w400f14inter.copyWith(color: kTextColor),
            ).withPaddingSymmetric(16, 0)
          else ...[
            SportFilterRow(
              sports: sportSlugs,
              selectedSports: {?_selectedSportSlug},
              onSportToggled: (slug) =>
                  setState(() => _selectedSportSlug = slug),
            ),

            12.heightBox,

            CommonDateSelectionRow(
              dates: _dates,
              selectedDate: _selectedDate,
              onDateSelected: (date) => setState(() => _selectedDate = date),
            ),

            16.heightBox,

            const _EdgeToEdgeDivider(),

            16.heightBox,

            ..._buildCourtBlocks(l10n),
          ],

          24.heightBox,
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Photo
  // ------------------------------------------------------------

  Widget _buildPhoto() {
    return CachedNetworkImage(
      imageUrl: _photoUrl,
      height: _photoHeight,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: _photoHeight,
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.white),
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        Assets.png.clubLogo.path,
        height: _photoHeight,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  // ------------------------------------------------------------
  // Name, location, amenities
  // ------------------------------------------------------------

  Widget _buildClubSummary() {
    final l10n = AppLocalizations.of(context)!;

    final amenities = widget.club.amenities
        .where((a) => a.trim().isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.club.name ?? '',
          style: AppStyles.w600f18inter.copyWith(color: kDarkTextColor),
        ).withPaddingSymmetric(16, 0),

        4.heightBox,

        Text(
          "$_locationLabel • ${formatDistanceKm(widget.distance, l10n)}",
          style: AppStyles.w400f14inter.copyWith(color: kTextColor),
        ).withPaddingSymmetric(16, 0),

        if ((widget.club.description ?? '').isNotEmpty) ...[
          8.heightBox,

          Text(
            widget.club.description!,
            style: AppStyles.w400f12inter.copyWith(color: kTextColor),
          ).withPaddingSymmetric(16, 0),
        ],

        if (amenities.isNotEmpty) ...[
          10.heightBox,

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (final amenity in amenities) ...[
                  _AmenityPill(label: amenity),
                  const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ------------------------------------------------------------
  // Court blocks
  // ------------------------------------------------------------

  List<Widget> _buildCourtBlocks(AppLocalizations l10n) {
    final courts = _matchingCourts;

    if (courts.isEmpty) {
      return [
        Text(
          l10n.noCourtsOfferThisSport,
          style: AppStyles.w400f14inter.copyWith(color: kTextColor),
        ).withPaddingSymmetric(16, 0),
      ];
    }

    return [
      for (final (index, court) in courts.indexed) ...[
        if (index > 0) ...[
          16.heightBox,
          const _EdgeToEdgeDivider(thickness: 1),
          16.heightBox,
        ],
        _buildCourtBlock(court, index, l10n),
      ],
    ];
  }

  Widget _buildCourtBlock(Court court, int index, AppLocalizations l10n) {
    final slots = _slotsFor(court);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          court.courtName ?? '',
          style: AppStyles.w600f14inter.copyWith(color: kDarkTextColor),
        ).withPaddingSymmetric(16, 0),

        10.heightBox,

        if (slots.isEmpty)
          Text(
            l10n.noSlotsPublishedForDate,
            style: AppStyles.w400f14inter.copyWith(color: kTextColor),
          ).withPaddingSymmetric(16, 0)
        else
          SingleChildScrollView(
            controller: _courtScrollController(
              '${court.courtName ?? 'court'}_$index',
            ),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Two slots per column, so the block reads as two rows of
                // times that scroll sideways together.
                for (int i = 0; i < slots.length; i += 2)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTimeSlotChip(court, slots[i]),

                        if (i + 1 < slots.length) ...[
                          const SizedBox(height: 10),
                          _buildTimeSlotChip(court, slots[i + 1]),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTimeSlotChip(Court court, Padel slot) {
    final available =
        slot.status == 'Available' &&
        !TimeSlotHelper.isSlotInPast(_selectedDate, slot.startTime);

    return GestureDetector(
      onTap: available ? () => _onTimeSlotTap(court, slot) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: available ? kWhiteColor : kGreyColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: kBorderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              slot.startTime ?? '',
              style: AppStyles.w500f14inter.copyWith(
                color: available ? kDarkTextColor : kGreyTextColor,
              ),
            ),

            if (available) ...[
              4.widthBox,
              const CircleAvatar(radius: 3, backgroundColor: kGreen06),
            ],
          ],
        ),
      ),
    );
  }
}

/// Grey separator that ignores the screen's horizontal padding and runs the
/// full width, the way the design shows it.
class _EdgeToEdgeDivider extends StatelessWidget {
  final double thickness;

  const _EdgeToEdgeDivider({this.thickness = 6});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 0, thickness: thickness, color: kCardColor);
  }
}

class _AmenityPill extends StatelessWidget {
  final String label;

  const _AmenityPill({required this.label});

  /// The API sends free-form amenity names, so match on keywords and fall
  /// back to a neutral icon for anything unrecognised.
  IconData get _icon {
    final value = label.toLowerCase();

    if (value.contains('shower')) return Icons.shower_outlined;
    if (value.contains('park')) return Icons.local_parking_outlined;
    if (value.contains('indoor')) return Icons.meeting_room_outlined;
    if (value.contains('outdoor')) return Icons.wb_sunny_outlined;
    if (value.contains('wifi') || value.contains('wi-fi')) return Icons.wifi;
    if (value.contains('locker')) return Icons.lock_outline;
    if (value.contains('bar') ||
        value.contains('restaurant') ||
        value.contains('cafe') ||
        value.contains('café')) {
      return Icons.restaurant_outlined;
    }
    if (value.contains('shop') || value.contains('store')) {
      return Icons.storefront_outlined;
    }
    if (value.contains('light')) return Icons.light_mode_outlined;

    return Icons.check_circle_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: kGreyColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: kBorderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 14, color: kTextColor),

          const SizedBox(width: 4),

          Text(
            label,
            style: AppStyles.w400f12inter.copyWith(color: kDarkTextColor),
          ),
        ],
      ),
    );
  }
}
