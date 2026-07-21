import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/court_model.dart';

class CourtCardWidget extends StatelessWidget {
  final CourtModel court;
  final VoidCallback? onTap;
  final Function(SportType, String)? onTimeSlotTap;

  const CourtCardWidget({
    super.key,
    required this.court,
    this.onTap,
    this.onTimeSlotTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            // Header Image with title and location overlay
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  AppCachedImage(
                    imageUrl: court.imageUrl,
                    height: 180,
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
                          court.name,
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
                            Text(
                              '${court.location} • ${court.distanceMiles} miles',
                              style: AppStyles.w400f12inter.copyWith(
                                color: kWhiteColor.withValues(alpha: 0.8),
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
            const SizedBox(height: 12),
            // Sports and Time Slots
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: court.sports.map((sport) {
                  final slots = court.timeSlots[sport] ?? [];
                  if (slots.isEmpty) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Sport Label
                        SizedBox(
                          width: 80,
                          child: Text(
                            sport.label,
                            style: AppStyles.w600f14inter.copyWith(
                              color: kTextPrimaryColor,
                            ),
                          ),
                        ),
                        // Horizontally scrollable slots
                        Expanded(
                          child: SizedBox(
                            height: 32,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: slots.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final time = slots[index];
                                return GestureDetector(
                                  onTap: () {
                                    if (onTimeSlotTap != null) {
                                      onTimeSlotTap!(sport, time);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
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
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            // View Details link
            Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 12),
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
                          color: kTextColor,
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
      ),
    );
  }
}
