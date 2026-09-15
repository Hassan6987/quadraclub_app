import 'package:quadraclub_app/app_exports.dart';

class AgendaCourtCard extends StatelessWidget {
  final AgendaItem item;

  const AgendaCourtCard({super.key, required this.item});

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
            imageUrl: courtImageUrl,
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
                      item.location,
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
              buttonText: "Rebook",
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
