import '../../../../app_exports.dart';

class CommonBadge extends StatelessWidget {
  final String label;
  const CommonBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderColor),
      ),
      child: Text(
        label,
        style: AppStyles.w500f10inter.copyWith(color: kDarkTextColor),
      ),
    );
  }
}
