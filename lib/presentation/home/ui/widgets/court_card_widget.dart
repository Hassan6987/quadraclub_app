import 'package:cached_network_image/cached_network_image.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:quadraclub_app/utils/helper/time_slot_helper.dart';
import 'package:shimmer/shimmer.dart';

/// One available slot, together with the court it belongs to, so tapping it
/// can open the booking sheet for the right court.
class _SportSlot {
  final Court court;
  final Sport sport;
  final Padel slot;

  const _SportSlot(this.court, this.sport, this.slot);

  String get time => slot.startTime ?? '';
}

class CourtCardWidget extends StatefulWidget {
  final Club club;
  final DateTime selectedDate;
  final double? distanceKm;

  /// Sport slugs selected in the header. Empty means "no filter", so every
  /// sport row is shown; otherwise only the selected sports get a row.
  final Set<String> selectedSports;

  final VoidCallback? onTap;
  final void Function(Court court, Sport sport, String time)? onTimeSlotTap;

  const CourtCardWidget({
    super.key,
    required this.club,
    required this.selectedDate,
    this.selectedSports = const {},
    this.distanceKm,
    this.onTap,
    this.onTimeSlotTap,
  });

  @override
  State<CourtCardWidget> createState() => _CourtCardWidgetState();
}

class _CourtCardWidgetState extends State<CourtCardWidget> {
  /// One horizontal scroller for every sport in this card (same as the
  /// reference clubs page — sports scroll together; cards do not sync).
  final ScrollController _slotsScrollController = ScrollController();

  static const double _labelHeight = 16;
  static const double _labelToChipsGap = 2;
  static const double _chipRowHeight = 32;
  static const double _sportBlockBottom = 8;

  @override
  void dispose() {
    _slotsScrollController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // LOCATION
  // ---------------------------------------------------------------------------

  String get _locationLabel {
    final city = widget.club.city ?? '';
    final state = widget.club.state ?? '';

    String loc = '';

    if (city.isNotEmpty && state.isNotEmpty) {
      loc = '$city, $state';
    } else if (city.isNotEmpty) {
      loc = city;
    } else {
      loc = state;
    }

    if (widget.distanceKm != null &&
        !widget.distanceKm!.isInfinite &&
        !widget.distanceKm!.isNaN) {
      final d = widget.distanceKm!;

      final dStr = d < 10 ? '${d.toStringAsFixed(1)} km' : '${d.round()} km';

      return loc.isNotEmpty ? '$loc • $dStr' : dStr;
    }

    return loc;
  }

  // ---------------------------------------------------------------------------
  // DATE KEY
  // ---------------------------------------------------------------------------

  String _dateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');

    return '$y-$m-$d';
  }

  // ---------------------------------------------------------------------------
  // SPORT ROWS
  // ---------------------------------------------------------------------------

  List<Padel> _slotsOfSport(WeeklySlot daySlots, String sportSlug) {
    switch (sportSlug) {
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

  /// One entry per sport, pooling the available slots of every court that
  /// offers it — the card shows a single row per sport, not per court.
  /// Slots are de-duplicated by start time and sorted chronologically.
  Map<String, List<_SportSlot>> get _slotsBySport {
    final dateKey = _dateKey(widget.selectedDate);

    final bySport = <String, List<_SportSlot>>{};
    final seenTimes = <String, Set<String>>{};

    for (final court in widget.club.courts) {
      final daySlots = court.weeklySlots[dateKey];

      for (final sport in court.sports) {
        final slug = sportSlug(sport.sportName);

        if (slug.isEmpty) continue;

        if (widget.selectedSports.isNotEmpty &&
            !widget.selectedSports.contains(slug)) {
          continue;
        }

        final pooled = bySport.putIfAbsent(slug, () => []);
        final seen = seenTimes.putIfAbsent(slug, () => {});

        if (daySlots == null) continue;

        for (final slot in _slotsOfSport(daySlots, slug)) {
          if (slot.status != 'Available') continue;
          if (TimeSlotHelper.isSlotInPast(
            widget.selectedDate,
            slot.startTime,
          )) {
            continue;
          }

          final time = slot.startTime ?? '';

          if (time.isEmpty || !seen.add(time)) continue;

          pooled.add(_SportSlot(court, sport, slot));
        }
      }
    }

    for (final slots in bySport.values) {
      slots.sort((a, b) => a.time.compareTo(b.time));
    }

    return bySport;
  }

  double _sportBlockHeight(List<_SportSlot> slots) {
    final bodyHeight = slots.isEmpty ? _labelHeight : _chipRowHeight;
    return _labelHeight + _labelToChipsGap + bodyHeight + _sportBlockBottom;
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final slotsBySport = _slotsBySport;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImage(),

            12.heightBox,

            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: slotsBySport.isEmpty
                  ? _buildNoCourtsFallback()
                  : _buildSyncedSportsScroller(slotsBySport),
            ),

            Divider(color: kBorderColor).withPaddingSymmetric(16, 0),
            Align(alignment: Alignment.centerRight, child: _buildViewDetails()),

            12.heightBox,
          ],
        ),
      ),
    );
  }

  /// Single horizontal scroller for the whole card: every sport's chips
  /// move together. Labels stay pinned on the left (like CSS `sticky`).
  Widget _buildSyncedSportsScroller(Map<String, List<_SportSlot>> slotsBySport) {
    final entries = slotsBySport.entries.toList();

    return Stack(
      children: [
        SingleChildScrollView(
          controller: _slotsScrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final entry in entries)
                _buildScrollableSportBlock(entry.key, entry.value),
            ],
          ),
        ),
        // Sticky sport labels — cover chips that scroll underneath.
        IgnorePointer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final entry in entries)
                _buildStickySportLabel(entry.key, entry.value),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScrollableSportBlock(String slug, List<_SportSlot> slots) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      height: _sportBlockHeight(slots),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Space reserved for the sticky label overlay.
          const SizedBox(height: _labelHeight),
          const SizedBox(height: _labelToChipsGap),
          if (slots.isEmpty)
            Text(
              l10n.noAvailableSlotsForDay,
              style: AppStyles.w400f12inter.copyWith(color: kTextColor),
            )
          else
            SizedBox(
              height: _chipRowHeight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < slots.length; i++) ...[
                    if (i > 0) const SizedBox(width: 4),
                    _buildTimeChip(slots[i]),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStickySportLabel(String slug, List<_SportSlot> slots) {
    return SizedBox(
      height: _sportBlockHeight(slots),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          color: kWhiteColor,
          padding: const EdgeInsets.only(right: 8),
          height: _labelHeight,
          alignment: Alignment.centerLeft,
          child: Text(
            localizedSportName(context, slug),
            style: AppStyles.w400f12inter.copyWith(color: kTextPrimaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeChip(_SportSlot entry) {
    return GestureDetector(
      // Absorbs the tap so it doesn't fall through to the
      // card's "open club page" gesture.
      onTap: () => widget.onTimeSlotTap?.call(
        entry.court,
        entry.sport,
        entry.time,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: kWhiteColor,
          border: Border.all(color: kBorderColor, width: 1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            entry.time,
            style: AppStyles.w400f12inter.copyWith(color: kDarkTextColor),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER IMAGE
  // ---------------------------------------------------------------------------

  Widget _buildHeaderImage() {
    const imageHeight = 72.0;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.club.photo ?? '',
            height: imageHeight,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: imageHeight,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              );
            },
            errorWidget: (context, url, error) {
              return Image.asset(
                Assets.png.clubLogo.path,
                height: imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),

          // Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: kBlackColor.withValues(alpha: 0.8),
              ),
            ),
          ),

          // Club name + location
          Positioned(
            bottom: 13,
            top: 13,
            left: 16,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.club.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.w600f18inter.copyWith(
                    color: kWhiteColor,
                    fontSize: 16,
                  ),
                ),

                2.heightBox,

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: kWhiteColor,
                      size: 14,
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        _locationLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.w400f14inter.copyWith(
                          color: kWhiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // VIEW DETAILS
  // ---------------------------------------------------------------------------

  Widget _buildViewDetails() {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(right: 12, bottom: 8, top: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.viewDetails,
            style: AppStyles.w500f12inter.copyWith(color: kDarkTextColor),
          ),

          const SizedBox(width: 2),

          const Icon(Icons.chevron_right, size: 14, color: kTextColor),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NO COURTS FALLBACK
  // ---------------------------------------------------------------------------

  Widget _buildNoCourtsFallback() {
    final sports = widget.selectedSports.isEmpty
        ? widget.club.sports
        : widget.club.sports
              .where((s) => widget.selectedSports.contains(sportSlug(s)))
              .toList();

    if (sports.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4, right: 16),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: sports.map((sport) {
          final label = localizedSportName(context, sport);

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: kGreyColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              label,
              style: AppStyles.w400f12inter.copyWith(color: kDarkTextColor),
            ),
          );
        }).toList(),
      ),
    );
  }
}
