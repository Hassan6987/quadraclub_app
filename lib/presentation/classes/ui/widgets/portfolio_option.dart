// lib/presentation/common/widgets/payment_options.dart
import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';

import '/app_exports.dart';

class PortfolioPaymentOption extends StatelessWidget {
  final double balance;
  final double amount;
  final bool isEnabled;
  final bool isSelected;
  final VoidCallback onTap;

  const PortfolioPaymentOption({
    super.key,
    required this.balance,
    required this.amount,
    required this.isEnabled,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isEnabled ? 1 : 0.5,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? kPrimaryColor : kWhiteFo,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: kPrimaryColor,
                ),
              ),
              12.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.portfolioBalance,
                      style: AppStyles.w500f14inter.copyWith(
                          color: kDarkTextColor),
                    ),
                    4.heightBox,
                    Text(
                      l10n.balanceAmount(formatPrice(balance)),
                      style: AppStyles.w400f12inter.copyWith(
                          color: kGreyTextColor),
                    ),
                    if (!isEnabled) ...[
                      4.heightBox,
                      Text(
                        l10n.insufficientBalance,
                        style: AppStyles.w400f12inter.copyWith(
                            color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
              Radio<bool>(
                value: true,
                groupValue: isSelected ? true : null,
                onChanged: isEnabled ? (_) => onTap() : null,
                activeColor: kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardPaymentOption extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const CardPaymentOption(
      {super.key, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? kPrimaryColor : kWhiteFo,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                  Icons.credit_card_outlined, color: kPrimaryColor),
            ),
            12.widthBox,
            Expanded(
              child: Text(
                l10n.creditDebitCard,
                style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: isSelected ? true : null,
              onChanged: (_) => onTap(),
              activeColor: kPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}