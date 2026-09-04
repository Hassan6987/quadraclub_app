import 'package:cached_network_image/cached_network_image.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:shimmer/shimmer.dart';

class CourtCardWidget extends StatelessWidget {
  final Club club;
  final DateTime selectedDate;
  final VoidCallback? onTap;
  final Function(Court, Sport, String)? onTimeSlotTap;

  const CourtCardWidget({
    super.key,
    required this.club,
    required this.selectedDate,
    this.onTap,
    this.onTimeSlotTap,
  });

  String get _locationLabel {
    final city = club.city ?? '';
    final state = club.state ?? '';
    if (city.isEmpty) return state;
    if (state.isEmpty) return city;
    return '$city, $state';
  }

  String _dateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  Widget build(BuildContext context) {
    final courts = club.courts;

    return Container(
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
          // Header Image with title and location overlay
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: club.photo ?? '',
                  height: 100,
                  width: double.infinity,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      Assets.png.clubLogo.path,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
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
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        club.name ?? '',
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
          // Courts -> Sports -> Time Slots (for the selected date)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: courts.isEmpty
                ? _buildNoCourtsFallback()
                : Column(
                    children: courts
                        .map((court) => _buildCourtSection(court))
                        .toList(),
                  ),
          ),
          Divider(color: kBorderColor),
          Padding(
            padding: const EdgeInsets.only(right: 12, bottom: 12, top: 8),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onTap,
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

  /// One physical court within the club: its name plus each of its
  /// sports, with slots pulled from weeklySlots[selectedDate] — not the
  /// theoretical open/close-time range.
  Widget _buildCourtSection(Court court) {
    final sports = court.sports;
    if (sports.isEmpty) return const SizedBox.shrink();

    final daySlots = court.weeklySlots[_dateKey(selectedDate)];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((court.courtName ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                court.courtName!,
                style: AppStyles.w500f12inter.copyWith(color: kDarkTextColor),
              ),
            ),
          ...sports.map((sport) => _buildSportSlots(court, sport, daySlots)),
        ],
      ),
    );
  }

  /// Slots for one sport on the selected day, filtered to Available only.
  /// WeeklySlot only decodes "Tennis"/"Padel" keys today, so any other
  /// sport shows a "not available to book yet" state rather than guessing.
  Widget _buildSportSlots(Court court, Sport sport, WeeklySlot? daySlots) {
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

    final availableSlots = slots.where((s) => s.status == 'Available').toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sport.sportName ?? '',
            style: AppStyles.w400f12inter.copyWith(color: kTextPrimaryColor),
          ),
          2.heightBox,
          if (availableSlots.isEmpty)
            Text(
              'No available slots for this day',
              style: AppStyles.w400f12inter.copyWith(color: kTextColor),
            )
          else
            SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: availableSlots.length,
                separatorBuilder: (_, __) => const SizedBox(width: 4),
                itemBuilder: (context, index) {
                  final slot = availableSlots[index];
                  final time = slot.startTime ?? '';
                  return GestureDetector(
                    onTap: () => onTimeSlotTap?.call(court, sport, time),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        border: Border.all(color: kBorderColor, width: 1),
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

  /// A club may have no courts registered yet (see "Beira Mar Padel" in
  /// the sample payload). Fall back to showing the sports it offers as
  /// plain badges, with no bookable time slots since none exist.
  Widget _buildNoCourtsFallback() {
    if (club.sports.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: club.sports.map((sport) {
          final label = sport.isNotEmpty
              ? '${sport[0].toUpperCase()}${sport.substring(1).replaceAll('_', ' ')}'
              : sport;
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
