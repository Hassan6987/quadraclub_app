import 'package:quadraclub_app/data/service_fees/service_fees_model.dart';
import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';
import 'package:quadraclub_app/utils/components/service_fee_amount.dart';

import '../../../../app_exports.dart';

class PriceCard extends StatelessWidget {
  final double classPrice;
  final FeeTier convenienceFee;
  final double total;

  const PriceCard({
    super.key,
    required this.classPrice,
    required this.convenienceFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kWhiteFo),
      ),
      child: Column(
        children: [
          _PriceRow(
            label: l10n.classroom,
            value: Text(
              formatPrice(classPrice),
              style: AppStyles.w400f14inter.copyWith(color: kDarkTextColor),
            ),
          ),
          const SizedBox(height: 6),
          _PriceRow(
            label: l10n.convenienceFee,
            value: ServiceFeeAmount(fee: convenienceFee),
          ),
          Divider(color: kDividerColor).withPaddingSymmetric(0, 8),
          _PriceRow(
            label: l10n.total,
            value: Text(
              formatPrice(total),
              style: AppStyles.w400f14inter.copyWith(
                color: kBlueColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final Widget value;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
        ),
        value,
      ],
    );
  }
}
