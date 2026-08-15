import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

class SelectionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? icon;
  final double borderRadius;
  final TextStyle? labelStyle;
  final double? verticalPadding;
  final double? width;


  const SelectionButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon, this.borderRadius=12, this.labelStyle, this.verticalPadding,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width:width ,
        decoration: BoxDecoration(
          color: isSelected ? kLightPrimaryColor : kWhiteColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isSelected ? kPrimaryColor : kBorderColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(

          children: [
            if (icon != null) ...[SvgPicture.asset(icon!), 12.heightBox],
            Text(
              label,
              style:labelStyle?? AppStyles.w400f14inter.copyWith(color: kDarkTextColor),
            ),
          ],
        ).withPaddingSymmetric(16, verticalPadding??12),
      ),
    );
  }
}
