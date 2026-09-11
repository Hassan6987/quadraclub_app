import '../../../../app_exports.dart';

class CourtConfirmationBadge extends StatelessWidget {
  final String label;

  const CourtConfirmationBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: kGreen06.withValues(alpha: 0.10),
        border: Border.all(color: kGreen06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: AppStyles.w500f10inter.copyWith(color: kGreen06),
      ),
    );
  }
}
