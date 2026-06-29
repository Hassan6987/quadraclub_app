import '/app_exports.dart';

class TimeChip extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const TimeChip({
    super.key,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(

          decoration: BoxDecoration(
            color: isSelected ? kPrimaryColor : kGreyColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            spacing: getProportionateScreenHeight(6),
            children: [
              Text(
                label,
                style: AppStyles.w500f12inter.copyWith(color: kDarkTextColor),
              ),
              Text(
                subtitle,
                style: AppStyles.w400f12inter.copyWith(color: kDarkTextColor),
              ),
            ],
          ).withPaddingSymmetric(8, 8),
        ),
      ),
    );
  }
}
