import '../../../../app_exports.dart';

class PriceCard extends StatelessWidget {
  final double classPrice;
  final double convenienceFee;
  final double total;

  const PriceCard({super.key,
    required this.classPrice,
    required this.convenienceFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
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
            label: 'Classroom',
            value: '\$${classPrice.toStringAsFixed(2)}',
            isTotal: false,
          ),
          const SizedBox(height: 6),
          _PriceRow(
            label: 'Convenience fee',
            value: '\$${convenienceFee.toStringAsFixed(2)}',
            isTotal: false,
          ),
         Divider(color: kDividerColor,).withPaddingSymmetric(0, 8),
          _PriceRow(
            label: 'Total',
            value: '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }
}
class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.value,
    required this.isTotal,
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
        Text(
          value,
          style: AppStyles.w400f14inter.copyWith(
            color: isTotal ? kBlueColor : kDarkTextColor,
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
