// lib/presentation/booking/ui/payment_method_screen.dart
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';
import 'package:quadraclub_app/presentation/home/data/court_model.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/booking_confirmation_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  final CourtModel court;
  final String dateLabel;
  final String timeLabel;
  final String blockLabel;
  final double amount;

  const PaymentMethodScreen({
    super.key,
    required this.court,
    required this.dateLabel,
    required this.timeLabel,
    required this.blockLabel,
    required this.amount,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final _cardholderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _agreedToTerms = false;

  static const double _serviceFee = 2.0;
  double get _total => widget.amount + _serviceFee;

  @override
  void dispose() {
    _cardholderController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _onPayNow() {
    if (!_agreedToTerms) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BookingConfirmationScreen(
          court: widget.court,
          dateLabel: widget.dateLabel,
          timeLabel: widget.timeLabel,
          blockLabel: widget.blockLabel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCardColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kBorderColor),
            ),
            child: Icon(Icons.arrow_back, size: 24, color: kDarkTextColor),
          ),
        ),
        title: Text(
          'Booking Summary',
          style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COURT DETAILS',
                    style: AppStyles.w500f12inter.copyWith(color: kTextColor),
                  ),
                  8.heightBox,
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: kBorderF0),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AppCachedImage(
                            imageUrl: widget.court.imageUrl,
                            width: 95,
                            height: 95,
                          ),
                        ),
                        12.widthBox,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.court.name,
                                style: AppStyles.w600f16inter.copyWith(
                                  color: kDarkTextColor,
                                ),
                              ),
                              Text(
                                '${widget.court.location} • ${widget.court.distanceMiles} miles',
                                style: AppStyles.w400f14inter.copyWith(
                                  color: kTextColor,
                                ),
                              ),
                              Text(
                                '${widget.dateLabel} | ${widget.timeLabel} | ${widget.blockLabel}',
                                style: AppStyles.w500f12inter.copyWith(
                                  color: kLightGreenColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.heightBox,

                  Text(
                    'PAYMENT METHOD',
                    style: AppStyles.w500f12inter.copyWith(color: kTextColor),
                  ),
                  8.heightBox,
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      border: Border.all(color: kBorderF0),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        buildTextField(
                          _cardholderController,
                          'Cardholder name',
                          icon: Icons.person_outline,
                        ),
                        10.heightBox,
                        buildTextField(
                          _cardNumberController,
                          'Card number',
                          icon: Icons.credit_card,
                        ),
                        10.heightBox,
                        Row(
                          children: [
                            Expanded(
                              child: buildTextField(_expiryController,
                                'MM/YY',
                              ),
                            ),
                            10.widthBox,
                            Expanded(child: buildTextField(_cvvController, 'CVV'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  14.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: kGreyTextColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Secure Encrypted Payment',
                        style: AppStyles.w400f12inter.copyWith(
                          color: kGreyTextColor,
                        ),
                      ),
                    ],
                  ),
                  20.heightBox,

                  Text(
                    'PRICE DETAILS',
                    style: AppStyles.w500f12inter.copyWith(color: kTextColor),
                  ),
                  8.heightBox,
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: kBorderF0),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Court Fee (2 hrs)',
                              style: AppStyles.w400f14inter.copyWith(
                                color: kGreyTextColor,
                              ),
                            ),
                            Text(
                              formatPrice(widget.amount),
                              style: AppStyles.w500f14inter.copyWith(
                                color: kDarkTextColor,
                              ),
                            ),
                          ],
                        ),
                        8.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Service Fee',
                              style: AppStyles.w400f14inter.copyWith(
                                color: kGreyTextColor,
                              ),
                            ),
                            Text(
                              formatPrice(_serviceFee),
                              style: AppStyles.w500f14inter.copyWith(
                                color: kDarkTextColor,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24, color: kBorderColor),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: AppStyles.w400f14inter.copyWith(
                                color: kGreyTextColor,
                              ),
                            ),
                            Text(
                              formatPrice(_total),
                              style: AppStyles.w600f16inter.copyWith(
                                color: kBlueColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  14.heightBox,

                  GestureDetector(
                    onTap: () =>
                        setState(() => _agreedToTerms = !_agreedToTerms),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          activeColor: kPrimaryColor,
                          side: BorderSide(color: kTextColor, width: 2),
                          onChanged: (val) =>
                              setState(() => _agreedToTerms = val ?? false),
                        ),
                        Expanded(
                          child: Text(
                            'I agree to the terms of use.',
                            style: AppStyles.w400f14inter.copyWith(
                              color: kTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomActionButton(
                buttonText: "Pay Now",
                isEnabled: _agreedToTerms,
                onTap: _onPayNow),
          ),
        ],
      ),
    );
  }
}

Widget buildTextField(TextEditingController controller,
    String hint, {
      IconData? icon,
    }) {
  return Container(
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 14),
    decoration: BoxDecoration(
      color: kWhiteColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: kBorderColor),
    ),
    child: Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: kTextColor, size: 18),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppStyles.w400f14inter.copyWith(color: kTextColor),
              border: InputBorder.none,
              isDense: true,
            ),
            style: AppStyles.w400f14inter,
          ),
        ),
      ],
    ),
  );
}
