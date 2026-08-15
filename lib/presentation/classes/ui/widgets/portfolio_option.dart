import 'package:quadraclub_app/utils/components/custom_radio_button.dart';

import '/app_exports.dart';

class PortfolioOption extends StatelessWidget {
  final double balance;
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  const PortfolioOption({
    super.key,
    required this.balance,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kDividerColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kWhiteF9,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(Assets.svg.calendarBlank.path),
            ),
            8.widthBox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Portfolio',
                  style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
                ),
                Text(
                  '\$${balance.toStringAsFixed(2)} available',
                  style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
                ),
              ],
            ),
            const Spacer(),

            CustomRadioButton(
              value: isSelected,
              groupValue: true,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
