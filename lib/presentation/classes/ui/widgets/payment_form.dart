import '/app_exports.dart';

class PaymentForm extends StatelessWidget {
  final TextEditingController cardholderController;
  final TextEditingController cardNumberController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;

  const PaymentForm({super.key,
    required this.cardholderController,
    required this.cardNumberController,
    required this.expiryController,
    required this.cvvController,
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
          CustomTextField(
            controller: cardholderController,
            hintText: 'Cardholder name',
            prefixIcon: SvgPicture.asset(Assets.svg.accontIcon.path),

          ),

          CustomTextField(
            controller: cardNumberController,
            hintText: 'Card number',
            prefixIcon: SvgPicture.asset(Assets.svg.creditCard.path),
            keyboardType: TextInputType.number,
          ).withPaddingSymmetric(0, 12),

          Row(
            spacing: getProportionateScreenWidth(12),
            children: [
              Expanded(
                child: CustomTextField(
                  controller: expiryController,
                  hintText: 'MM/YY',
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: CustomTextField(
                  controller: cvvController,
                  hintText: 'CVV',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          8.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              SvgPicture.asset(Assets.svg.lockIcon.path),
              6.widthBox,
              Text(
                'Secure Encrypted Payment',
                style: AppStyles.w400f14inter.copyWith(
                    color: kTextColor
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
