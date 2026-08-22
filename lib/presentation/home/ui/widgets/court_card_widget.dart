import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/models/court_model.dart';

class CourtCardWidget extends StatelessWidget {
  final Court court;
  final VoidCallback? onTap;
  final Function(Sport, String)? onTimeSlotTap;

  const CourtCardWidget({
    super.key,
    required this.court,
    this.onTap,
    this.onTimeSlotTap,
  });

  @override
  Widget build(BuildContext context) {
    final sports = court.sports ?? [];

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
                AppCachedImage(
                  imageUrl: court.courtPhoto ?? '',
                  height: 100,
                  width: double.infinity,
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
                        court.courtName ?? '',
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
                              court.location ?? '',
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
          // Sports and Time Slots
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: sports.map((sport) {
                final slots = sport.hourlySlots;
                if (slots.isEmpty) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sport.sportName ?? '',
                        style: AppStyles.w400f12inter.copyWith(
                          color: kTextPrimaryColor,
                        ),
                      ),
                      2.heightBox,
                      SizedBox(
                        height: 32,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: slots.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 4),
                          itemBuilder: (context, index) {
                            final time = slots[index];
                            return GestureDetector(
                              onTap: () => onTimeSlotTap?.call(sport, time),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: kWhiteColor,
                                  border: Border.all(
                                      color: kBorderColor, width: 1),
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
              }).toList(),
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
                          color: kDarkTextColor),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                        Icons.chevron_right, size: 14, color: kTextColor),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}