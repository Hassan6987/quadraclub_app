import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';

import '/app_exports.dart';

class PaymentForLessonScreen extends StatefulWidget {
  final Class classModel;

  const PaymentForLessonScreen({super.key, required this.classModel});

  @override
  State<PaymentForLessonScreen> createState() => _PaymentForLessonScreenState();
}

class _PaymentForLessonScreenState extends State<PaymentForLessonScreen> {
  bool _usePortfolio = false;
  bool _agreedToTerms = false;
  bool _isProcessing = false;

  final _cardholderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  static const _convenienceFee = 2.0;
  static const _portfolioBalance = 259.0;

  double get _total => (widget.classModel.price ?? 0) + _convenienceFee;

  @override
  void dispose() {
    _cardholderController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Payment For Lesson",
        showActions: false,
        showBackIcon: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  'After payment, your request will be sent to the Coach for approval.',
                  style: AppStyles.w400f14inter.copyWith(color: kTextColor),
                ),
                16.heightBox,

                InfoCard(classModel: widget.classModel),

                PortfolioOption(
                  balance: _portfolioBalance,
                  isSelected: _usePortfolio,
                  onChanged: (v) => setState(() => _usePortfolio = v),
                ).withPaddingSymmetric(0, 16),

                Text(
                  'PAYMENT METHOD',
                  style: AppStyles.w500f12inter.copyWith(
                    color: kDarkTextColor.withValues(alpha: 0.70),
                  ),
                ),
                6.heightBox,
                PaymentForm(
                  cardholderController: _cardholderController,
                  cardNumberController: _cardNumberController,
                  expiryController: _expiryController,
                  cvvController: _cvvController,
                ),

                Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (v) =>
                          setState(() => _agreedToTerms = v ?? false),
                      activeColor: kPrimaryColor,
                      checkColor: Colors.black,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: const BorderSide(color: kTextColor),
                    ),
                    6.widthBox,
                    Text(
                      'I agree to the terms of use.',
                      style: AppStyles.w400f14inter.copyWith(color: kTextColor),
                    ),
                  ],
                ).withPaddingSymmetric(0, 16),

                PriceCard(
                  classPrice: widget.classModel.price?.toDouble() ?? 0.0,
                  convenienceFee: _convenienceFee,
                  total: _total,
                ),
              ],
            ).withPaddingSymmetric(20, 16),
            CommonDivider(),

            CustomActionButton(
              buttonText: 'Confirm Lesson',
              onTap: _handleConfirm,
              isEnabled: _agreedToTerms && !_isProcessing,
            ).withPaddingSymmetric(20, 16),
          ],
        ),
      ),
    );
  }

  Future<void> _handleConfirm() async {
    setState(() => _isProcessing = true);

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isProcessing = false);
    await showDialog(
      context: context,
      builder: (context) {
        return const ClassBookedDialog();
      },
    );
    if (!mounted) return;

    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
