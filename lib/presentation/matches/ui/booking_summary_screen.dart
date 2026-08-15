import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/payment_method_screen.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/match_card.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/request_sent_dialog.dart';
import 'package:quadraclub_app/utils/helper/date_formatter.dart';

import '/app_exports.dart';

class BookingSummaryScreen extends StatefulWidget {
  final MatchModel match;

  const BookingSummaryScreen({super.key, required this.match});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matchFee = 60.0; // Example fee
    final serviceFee = 2.0;
    final total = matchFee + serviceFee;

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.heightBox,
            _buildSectionHeader('COURT DETAILS'),
            8.heightBox,
            _buildCourtDetailsCard(widget.match),
            16.heightBox,
            
            // Payment Method Section
            _buildSectionHeader('PAYMENT METHOD'),
            8.heightBox,
            _buildPaymentMethodForm(),
            8.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 16,
                  color: kGreyTextColor,
                ),
                const SizedBox(width: 6),
                Text(
                  'Secure Encrypted Payment',
                  style: AppStyles.w400f14inter.copyWith(
                    color: kGreyTextColor,
                  ),
                ),
              ],
            ),
            16.heightBox,
            
            // Price Details Section
            _buildSectionHeader('PRICE DETAILS'),
            8.heightBox,
            _buildPriceDetails(matchFee, serviceFee, total),
            16.heightBox,
            GestureDetector(
              onTap: () =>
                  setState(() => _agreeToTerms = !_agreeToTerms),
              child: Row(
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    activeColor: kPrimaryColor,
                    side: BorderSide(color: kTextColor, width: 2),
                    onChanged: (val) =>
                        setState(() => _agreeToTerms = val ?? false),
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
            ).withPaddingSymmetric(20, 0),
            32.heightBox,
            
            // Pay Now Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CustomActionButton(
                buttonText: "Pay Now",
                onTap: _agreeToTerms ? _processPayment : null,
                isEnabled: _agreeToTerms,
              ),
            ),
            32.heightBox,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: AppStyles.w500f12inter.copyWith(
            color: kGreyTextColor.withValues(alpha: 0.7)),
      ),
    );
  }

  Widget _buildCourtDetailsCard(MatchModel match) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AppCachedImage(
                  imageUrl: match.imageAsset,
                  width: 64,
                  height: 64,
                ),
              ),
              8.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SportBadge(sport: match.sport),
                        buildSeatsBadge(match),
                      ],
                    ),
                    Text(
                      match.location,
                      style: AppStyles.w600f16inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                    Text(
                      "${match.city} • ${match
                          .distanceKm} miles • ${getFormatDateMonth(
                          match.date)}",
                      style: AppStyles.w400f14inter.copyWith(
                        color: kGreyTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          8.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonBadge(label: '${match.timeStart}-${match.timeEnd}'),
              4.widthBox,
              CommonBadge(label: match.category),
              4.widthBox,
              CommonBadge(label: "Ranking"),
              4.widthBox,
              buildCourtStatusBadge(match),
            ],
          ),
          12.heightBox,
        ],
      ),
    );
  }

  Widget _buildPaymentMethodForm() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: kWhiteColor,
        border: Border.all(color: kBorderF0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          buildTextField(
            _cardHolderController,
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
                child: buildTextField(
                  _expiryController,
                  'MM/YY',
                ),
              ),
              10.widthBox,
              Expanded(
                child: buildTextField(_cvvController, 'CVV'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetails(double matchFee, double serviceFee, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
                'Match Fee (2 hrs)',
                style: AppStyles.w400f14inter.copyWith(
                  color: kGreyTextColor,
                ),
              ),
              Text(
                formatPrice(matchFee),
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
                formatPrice(serviceFee),
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
                formatPrice(total),
                style: AppStyles.w600f16inter.copyWith(
                  color: kBlueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void _processPayment() {
    Navigator.pop(context);
    _showRequestSentDialog();
  }

  void _showRequestSentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RequestSentDialog(),
    );
  }
}
