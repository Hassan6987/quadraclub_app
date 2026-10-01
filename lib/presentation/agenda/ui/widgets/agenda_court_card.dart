import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/utils/helper/date_formatter.dart';

class AgendaCourtCard extends StatelessWidget {
  final double distance;
  final AgendaItem item;

  const AgendaCourtCard({super.key, required this.item, required this.distance});

  bool _isBeforeToday(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bookingDay = DateTime(date.year, date.month, date.day);
    return bookingDay.isBefore(today);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kBorderF0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCachedImage(
            imageUrl: item.clubImage,
            // still a placeholder unless API sends one
            height: 72,
            width: double.infinity,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(20),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${item.dateString} | ${item.courtName}",
                      style: AppStyles.w600f12inter.copyWith(
                        color: kLightGreenColor,
                      ),
                    ),
                    Text(
                      item.title,
                      style: AppStyles.w600f16inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                    Text(
                      "${item.location} • ${formatDistanceKm(distance)}",
                      style: AppStyles.w400f14inter.copyWith(
                        color: kGreyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).withPaddingAll(10),
          16.heightBox,
          if (_isBeforeToday(item.bookingDate))
            CustomActionButton(
              backgroundColor: kPrimaryColor,
              buttonText: AppLocalizations.of(context)!.rebook,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteName.customBottomNavbar,
                  (_) => false,
                  arguments: {"index": 2},
                );
              },
            ).withPaddingSymmetric(16, 12),
        ],
      ),
    );
  }
}
