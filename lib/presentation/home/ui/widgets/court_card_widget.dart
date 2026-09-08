import 'package:cached_network_image/cached_network_image.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:shimmer/shimmer.dart';

class CourtCardWidget extends StatefulWidget {
  final Club club;
  final DateTime selectedDate;
  final double? distanceKm;
  final VoidCallback? onTap;
  final Function(Court, Sport, String)? onTimeSlotTap;

  const CourtCardWidget({
    super.key,
    required this.club,
    required this.selectedDate,
    this.distanceKm,
    this.onTap,
    this.onTimeSlotTap,
  });

  @override
  State<CourtCardWidget> createState() => _CourtCardWidgetState();
}

class _CourtCardWidgetState extends State<CourtCardWidget> {
  /// Each sport/time-slot row has its own controller.
  ///
  /// Example:
  /// Court 1 - Tennis      -> controller
  /// Court 1 - Padel       -> controller
  /// Court 2 - Tennis      -> controller
  /// Court 2 - Padel       -> controller
  ///
  /// All of them are synchronized.
  final Map<String, ScrollController> _scrollControllers = {};

  bool _isSyncingScroll = false;

  // ---------------------------------------------------------------------------
  // GET / CREATE CONTROLLER
  // ---------------------------------------------------------------------------

  ScrollController _getScrollController(String key) {
    final existingController = _scrollControllers[key];

    if (existingController != null) {
      return existingController;
    }

    final controller = ScrollController();

    controller.addListener(() {
      _syncScroll(controller);
    });

    _scrollControllers[key] = controller;

    return controller;
  }

  // ---------------------------------------------------------------------------
  // SYNCHRONIZE ALL HORIZONTAL LISTS
  // ---------------------------------------------------------------------------

  void _syncScroll(ScrollController sourceController) {
    if (_isSyncingScroll || !sourceController.hasClients) {
      return;
    }

    _isSyncingScroll = true;

    final sourceOffset = sourceController.offset;

    for (final controller in _scrollControllers.values) {
      // Don't update the controller that is currently scrolling.
      if (controller == sourceController) {
        continue;
      }

      if (!controller.hasClients) {
        continue;
      }

      final maxScrollExtent = controller.position.maxScrollExtent;

      // Different rows can have different content widths.
      //
      // Therefore we clamp the offset so that a shorter row doesn't
      // receive an invalid offset.
      final targetOffset = sourceOffset.clamp(
        0.0,
        maxScrollExtent,
      );

      if ((controller.offset - targetOffset).abs() > 0.5) {
        controller.jumpTo(targetOffset);
      }
    }

    _isSyncingScroll = false;
  }

  // ---------------------------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------------------------

  @override
  void dispose() {
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }

    _scrollControllers.clear();

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
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final courts = widget.club.courts;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
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
          // -------------------------------------------------------------------
          // HEADER IMAGE
          // -------------------------------------------------------------------

          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.club.photo ?? '',
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      Assets.png.clubLogo.path,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),

                // Gradient
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ),

                // Club name + location
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.club.name ?? '',
                        style: AppStyles.w600f18inter.copyWith(
                          color: kWhiteColor,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: kWhiteColor.withValues(alpha: 0.8),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _locationLabel,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.w400f12inter.copyWith(
                                color: kWhiteColor.withValues(alpha: 0.8),
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
          ),

          12.heightBox,

          // -------------------------------------------------------------------
          // COURTS
          // -------------------------------------------------------------------

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: courts.isEmpty
                ? _buildNoCourtsFallback()
                : Column(
              children: courts
                  .map(
                    (court) => _buildCourtSection(court),
              )
                  .toList(),
            ),
          ),

          Divider(
            color: kBorderColor,
          ),

          // -------------------------------------------------------------------
          // VIEW DETAILS
          // -------------------------------------------------------------------

          Padding(
            padding: const EdgeInsets.only(
              right: 12,
              bottom: 12,
              top: 8,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: widget.onTap,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Details',
                      style: AppStyles.w500f12inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.chevron_right,
                      size: 14,
                      color: kTextColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COURT SECTION
  // ---------------------------------------------------------------------------

  Widget _buildCourtSection(Court court) {
    final sports = court.sports;

    if (sports.isEmpty) {
      return const SizedBox.shrink();
    }

    final daySlots = court.weeklySlots[
    _dateKey(widget.selectedDate)
    ];

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Court name
          if ((court.courtName ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                bottom: 4,
              ),
              child: Text(
                court.courtName!,
                style: AppStyles.w500f12inter.copyWith(
                  color: kDarkTextColor,
                ),
              ),
            ),

          // Sports
          ...sports.map(
                (sport) =>
                _buildSportSlots(
                  court,
                  sport,
                  daySlots,
                ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SPORT SLOTS
  // ---------------------------------------------------------------------------

  Widget _buildSportSlots(Court court,
      Sport sport,
      WeeklySlot? daySlots,) {
    final sportKey = (sport.sportName ?? '').toLowerCase();

    List<Padel> slots;

    if (daySlots == null) {
      slots = const [];
    } else if (sportKey == 'tennis') {
      slots = daySlots.tennis;
    } else if (sportKey == 'padel') {
      slots = daySlots.padel;
    } else if (sportKey == 'pickleball') {
      slots = daySlots.pickleball;
    } else if (sportKey == 'beach_tennis') {
      slots = daySlots.beachTennis;
    } else {
      slots = const [];
    }

    final availableSlots = slots
        .where(
          (s) => s.status == 'Available',
    )
        .toList();

    // -------------------------------------------------------------------------
    // UNIQUE KEY
    // -------------------------------------------------------------------------
    //
    // We need a different controller for every sport row.
    //
    // Example:
    //
    // court1 + tennis
    // court1 + padel
    // court2 + tennis
    // court2 + padel
    //
    // Each gets its own ScrollController.
    //

    final controllerKey =
        '${court.courtName ?? 'court'}_${sport.sportName ?? 'sport'}';

    final scrollController = _getScrollController(
      controllerKey,
    );

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sport name
          Text(
            sport.sportName ?? '',
            style: AppStyles.w400f12inter.copyWith(
              color: kTextPrimaryColor,
            ),
          ),

          2.heightBox,

          // -------------------------------------------------------------------
          // NO SLOTS
          // -------------------------------------------------------------------

          if (availableSlots.isEmpty)
            Text(
              'No available slots for this day',
              style: AppStyles.w400f12inter.copyWith(
                color: kTextColor,
              ),
            )

          // -------------------------------------------------------------------
          // TIME SLOTS
          // -------------------------------------------------------------------

          else
            SizedBox(
              height: 32,
              child: ListView.separated(
                controller: scrollController,
                scrollDirection: Axis.horizontal,

                // This is important because we want this ListView to
                // respond to horizontal drag gestures.
                physics: const BouncingScrollPhysics(),

                itemCount: availableSlots.length,

                separatorBuilder: (_, __) {
                  return const SizedBox(
                    width: 4,
                  );
                },

                itemBuilder: (context, index) {
                  final slot = availableSlots[index];

                  final time = slot.startTime ?? '';

                  return GestureDetector(
                    onTap: () {
                      widget.onTimeSlotTap?.call(
                        court,
                        sport,
                        time,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        border: Border.all(
                          color: kBorderColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          time,
                          style: AppStyles.w400f12inter.copyWith(
                            color: kDarkTextColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NO COURTS FALLBACK
  // ---------------------------------------------------------------------------

  Widget _buildNoCourtsFallback() {
    if (widget.club.sports.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: widget.club.sports.map((sport) {
          final label = sport.isNotEmpty
              ? '${sport[0].toUpperCase()}${sport.substring(1).replaceAll('_', ' ')}'
              : sport;

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: kGreyColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              label,
              style: AppStyles.w400f12inter.copyWith(
                color: kDarkTextColor,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}