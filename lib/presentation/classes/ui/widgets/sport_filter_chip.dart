import '/app_exports.dart';

class SportFilterChip extends StatelessWidget {
  final SportType sport;
  final bool isSelected;
  final VoidCallback onTap;

  const SportFilterChip({
    super.key,
    required this.sport,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(12),
            vertical: getProportionateScreenHeight(6)),
        decoration: BoxDecoration(
      color: isSelected ? kPrimaryColor :kGreyColor,
        borderRadius: BorderRadius.circular(12),

      ),
      child: Text(
        sport.label,
        style:AppStyles.w400f14inter.copyWith(
          color: kDarkTextColor
        )
      ),
    ),);
  }
}
