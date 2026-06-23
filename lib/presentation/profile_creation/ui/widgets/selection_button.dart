import 'package:quadraclub_app/app_exports.dart';

class SelectionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? icon;

  const SelectionButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF01386C) : kWhiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF01386C)
                : const Color(0xFFE4E4E7),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              8.widthBox,
            ],
            Text(
              label,
              style: AppStyles.w500f14inter.copyWith(
                color: isSelected ? kWhiteColor : kTextPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
