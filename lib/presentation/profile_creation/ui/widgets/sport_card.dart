import 'package:quadraclub_app/presentation/profile_creation/data/sport_model.dart';

import '/app_exports.dart';

class SportCard extends StatelessWidget {
  final SportModel sport;
  final bool isSelected;
  final VoidCallback? onTap; // ✅ Accept callback from parent

  const SportCard({
    super.key,
    this.isSelected = false,
    required this.sport,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? kLightPrimaryColor : kWhiteColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kPrimaryColor : kBorderColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(sport.icon),
            8.widthBox,
            Text(
              sport.name,
              style: AppStyles.w500f16inter.copyWith(color: kDarkTextColor),
            ),
            const Spacer(),
            _buildCheckbox()
          ],
        ).withPaddingSymmetric(12, 8),
      ),
    );
  }
  Widget _buildCheckbox() {
    return Container(
      width: getProportionateScreenWidth(22),
      height: getProportionateScreenHeight(22),
      decoration: BoxDecoration(
        color: isSelected ? kPrimaryColor : kWhiteColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected ? kPrimaryColor : kBorderColor,
          width: 1.5,
        ),
      ),
      child: isSelected
          ? Icon(
        Icons.check,
        size: 14,
        color: kDarkTextColor,
      )
          : null,
    );
  }
}
