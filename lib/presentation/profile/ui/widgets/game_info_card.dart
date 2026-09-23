import '/app_exports.dart';

class GameInfoCard extends StatelessWidget {
  final String dominantHand;
  final String preferredSide;

  const GameInfoCard({
    super.key,
    required this.dominantHand,
    required this.preferredSide,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.gameInformation,
            style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
          ),
          16.heightBox,
          buildInfoRow(
            label: l10n.dominantHand,
            value: _localizedSide(l10n, dominantHand),
          ),
          8.heightBox,
          buildInfoRow(
            label: l10n.preferredSide,
            value: _localizedSide(l10n, preferredSide),
          ),
        ],
      ),
    );
  }

  String _localizedSide(AppLocalizations l10n, String value) {
    switch (value) {
      case 'Left':
        return l10n.left;
      case 'Right':
        return l10n.right;
      case 'Both':
        return l10n.both;
      case 'Unknown':
        return l10n.unknown;
      default:
        return value;
    }
  }
}

Widget buildInfoRow({required String label, required String value}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          label,
          style: AppStyles.w400f14inter.copyWith(
            color: kDarkTextColor.withValues(alpha: 0.70),
          ),
        ),
      ),
      Expanded(
        child: Text(
          value,
          style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
        ),
      ),
    ],
  );
}
