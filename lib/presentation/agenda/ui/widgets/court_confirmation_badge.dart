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
        _localizedLabel(context, label),
        style: AppStyles.w500f10inter.copyWith(color: kGreen06),
      ),
    );
  }

  String _localizedLabel(BuildContext context, String label) {
    final l10n = AppLocalizations.of(context)!;
    switch (label.toLowerCase()) {
      case 'court confirmed':
      case 'confirmed':
        return l10n.courtConfirmed;
      case 'pending confirmed':
      case 'pending':
        return l10n.pendingConfirmed;
      default:
        return label;
    }
  }
}
