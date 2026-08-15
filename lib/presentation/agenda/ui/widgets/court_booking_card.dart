import '../../../../app_exports.dart';

class CourtBookingCard extends StatelessWidget {
  final String imgUrl;
  final bool showActions;

  const CourtBookingCard({
    super.key,
    required this.imgUrl,
    required this.showActions,
  });

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
            imageUrl: imgUrl,
            height: 72,
            borderRadius: BorderRadius.circular(20),
            width: double.infinity,
            fit: BoxFit.cover,
          ).withPaddingAll(4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SUN, OCT 22 | 8:00 | BLOCK 1',
                  style: AppStyles.w500f12inter.copyWith(
                    color: kLightGreenColor,
                  ),
                ),
                2.heightBox,
                Text(
                  'Riverside Sports Hub',
                  style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
                ),
                2.heightBox,
                Text(
                  'Santa Monica · 2.5 miles',
                  style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
                ),
                if (showActions) ...[
                  12.heightBox,
                  CustomActionButton(buttonText: "Rebook", onTap: () {}),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
