import 'package:quadraclub_app/data/service_fees/service_fees_model.dart';
import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';

import '../../app_exports.dart';

/// Renders the payable service fee, with an optional struck-through full price
/// when [FeeTier.current] is less than [FeeTier.full].
class ServiceFeeAmount extends StatelessWidget {
  const ServiceFeeAmount({
    super.key,
    required this.fee,
    this.style,
    this.struckStyle,
  });

  final FeeTier fee;
  final TextStyle? style;
  final TextStyle? struckStyle;

  @override
  Widget build(BuildContext context) {
    final base =
        style ?? AppStyles.w500f14inter.copyWith(color: kDarkTextColor);

    if (!fee.showStrikeThrough) {
      return Text(formatPrice(fee.current), style: base);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatPrice(fee.full),
          style:
              struckStyle ??
              base.copyWith(
                decoration: TextDecoration.lineThrough,
                color: kGreyTextColor,
              ),
        ),
        6.widthBox,
        Text(formatPrice(fee.current), style: base),
      ],
    );
  }
}
