import '../../../../app_exports.dart';

class ToggleChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ToggleChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : kGreyColor,
          borderRadius: BorderRadius.circular(200),
        ),
        child: Text(
          label,
          style: AppStyles.w400f14inter.copyWith(color: kDarkTextColor),
        ).withPaddingSymmetric(12, 6),
      ),
    );
  }
}
