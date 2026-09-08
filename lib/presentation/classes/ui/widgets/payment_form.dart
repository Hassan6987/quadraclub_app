import 'package:quadraclub_app/presentation/home/ui/booking/payment_method_screen.dart';

import '/app_exports.dart';

class PaymentForm extends StatelessWidget {
  final TextEditingController cardholderController;
  final TextEditingController cardNumberController;
  final TextEditingController expiryController;
  final TextEditingController cvvController;

  final String? Function(String?)? cardholderValidator;
  final String? Function(String?)? cardNumberValidator;
  final String? Function(String?)? expiryValidator;
  final String? Function(String?)? cvvValidator;

  const PaymentForm({
    super.key,
    required this.cardholderController,
    required this.cardNumberController,
    required this.expiryController,
    required this.cvvController,
    this.cardholderValidator,
    this.cardNumberValidator,
    this.expiryValidator,
    this.cvvValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            prefixIcon: SvgPicture.asset(
              Assets.svg.accontIcon.path,
            ),
            validator: cardholderValidator,
            keyboardType: TextInputType.name,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-Z\s]'),
              ),
            ],
            borderRadius: 14,
          ),

          12.heightBox,

          CustomTextField(
            controller: cardNumberController,
            hintText: 'Card number',
            prefixIcon: SvgPicture.asset(
              Assets.svg.creditCard.path,
            ),
            keyboardType: TextInputType.number,
            validator: cardNumberValidator,
            inputFormatters: [
              CardNumberInputFormatter(),
            ],
            maxLength: 19,
            borderRadius: 14,
          ),

          12.heightBox,

          Row(
            spacing: getProportionateScreenWidth(12),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextField(
                  controller: expiryController,
                  hintText: 'MM/YY',
                  keyboardType: TextInputType.number,
                  validator: expiryValidator,
                  inputFormatters: [
                    ExpiryDateInputFormatter(),
                  ],
                  maxLength: 5,
                  borderRadius: 14,
                ),
              ),

              Expanded(
                child: CustomTextField(
                  controller: cvvController,
                  hintText: 'CVV',
                  keyboardType: TextInputType.number,
                  validator: cvvValidator,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  maxLength: 4,
                  obscureText: true,
                  borderRadius: 14,
                ),
              ),
            ],
          ),

          8.heightBox,

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.svg.lockIcon.path,
              ),
              6.widthBox,
              Text(
                'Secure Encrypted Payment',
                style: AppStyles.w400f14inter.copyWith(
                  color: kTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
