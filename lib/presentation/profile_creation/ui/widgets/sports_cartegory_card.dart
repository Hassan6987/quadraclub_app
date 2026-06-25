import '../../../../app_exports.dart';

class SportCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const SportCategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: kWhiteColor,
        border: Border.all(color: kBorderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
          ),
          4.heightBox,
          Text(
            subtitle,
            style: AppStyles.w400f14inter.copyWith(
              color: kTextSecondary.withValues(alpha: 0.70),
            ),
          ),
        ],
      ),
    );
  }
}
