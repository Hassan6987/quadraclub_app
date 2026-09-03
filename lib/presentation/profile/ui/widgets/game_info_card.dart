import '/app_exports.dart';

class GameInfoCard extends StatelessWidget {
  final String dominantHand;
  final String preferredSide;

  const GameInfoCard(
      {super.key, required this.dominantHand, required this.preferredSide});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Game Information',
            style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
          ),
          16.heightBox,
          buildInfoRow(label: 'Dominant Hand', value: dominantHand),
          8.heightBox,
          buildInfoRow(label: 'Preferred side', value: preferredSide),
        ],
      ),
    );
  }
}

Widget buildInfoRow({required String label, required String value}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: AppStyles.w400f14inter.copyWith(
          color: kDarkTextColor.withValues(alpha: 0.70),
        ),
      ),
      Text(
        value,
        style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
      ),
    ],
  );
}
