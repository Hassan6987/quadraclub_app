import '../../../../app_exports.dart';

class ProfileSummaryCard extends StatelessWidget {
  final String location;
  final String gender;
  final String dominantHand;
  final String dateOfBirth;
  final String preferredSide;

  const ProfileSummaryCard({super.key,
    required this.location,
    required this.gender,
    required this.dominantHand,
    required this.dateOfBirth,
    required this.preferredSide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Summary',
            style: AppStyles.w500f14inter.copyWith(
              color: kDarkTextColor.withValues(alpha: 0.70),
            ),
          ),
          16.heightBox,
          _SummaryRow(label: 'Location', value: location),
          _SummaryRow(label: 'Gender', value: gender),
          _SummaryRow(label: 'Dominant Hand', value: dominantHand),
          _SummaryRow(label: 'Date of Birth', value: dateOfBirth),
          _SummaryRow(
            label: 'Preferred side',
            value: preferredSide,
            isLast: true,
          ),
        ],
      ),
    );
  }
}
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
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
      ),
    );
  }
}
