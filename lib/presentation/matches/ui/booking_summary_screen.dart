import 'package:quadraclub_app/presentation/classes/ui/widgets/common_badge.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
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
        backgroundColor: kCardColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: kDarkTextColor),
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
            // Court Details Section
            _buildSectionHeader('COURT DETAILS'),
            12.heightBox,
            _buildCourtDetailsCard(),
            24.heightBox,
            
            // Payment Method Section
            _buildSectionHeader('PAYMENT METHOD'),
            12.heightBox,
            _buildPaymentMethodForm(),
            24.heightBox,
            
            // Price Details Section
            _buildSectionHeader('PRICE DETAILS'),
            12.heightBox,
            _buildPriceDetails(matchFee, serviceFee, total),
            24.heightBox,
            
            // Terms Checkbox
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _agreeToTerms ? kPrimaryColor : kWhiteColor,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: kBorderColor),
                    ),
                    child: _agreeToTerms
                        ? Icon(Icons.check, size: 14, color: kDarkTextColor)
                        : null,
                  ),
                ),
                8.widthBox,
                Expanded(
                  child: Text(
                    'I agree to the terms of use.',
                    style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
                  ),
                ),
              ],
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
        style: AppStyles.w600f14inter.copyWith(color: kGreyTextColor),
      ),
    );
  }

  Widget _buildCourtDetailsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kGreyColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: widget.match.imageAsset != null
                ? ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      widget.match.imageAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.sports_tennis, size: 48, color: kGreyTextColor);
                      },
                    ),
                  )
                : Icon(Icons.sports_tennis, size: 48, color: kGreyTextColor),
          ),
          12.heightBox,
          
          // Sport badge and seats
          Row(
            children: [
              SportBadge(sport: widget.match.sport),
              4.widthBox,
              CommonBadge(label: widget.match.category),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kRedColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kRedColor),
                ),
                child: Text(
                  '${widget.match.slotsLeft} Seats',
                  style: AppStyles.w500f10inter.copyWith(color: kRedColor),
                ),
              ),
            ],
          ).withPaddingSymmetric(12, 0),
          8.heightBox,
          
          // Location
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              widget.match.location,
              style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
            ),
          ),
          4.heightBox,
          
          // City, distance, date
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${widget.match.city} • ${widget.match.distanceKm} miles • ${widget.match.date.day} ${_getMonthName(widget.match.date.month)}',
              style: AppStyles.w400f12inter.copyWith(color: kGreyTextColor),
            ),
          ),
          8.heightBox,
          
          // Time
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.svg.clockTimer.path,
                  height: 16,
                  width: 16,
                  colorFilter: ColorFilter.mode(kGreyTextColor, BlendMode.srcIn),
                ),
                4.widthBox,
                Text(
                  '${widget.match.timeStart}-${widget.match.timeEnd}',
                  style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
                ),
              ],
            ),
          ),
          8.heightBox,
          
          // Tags
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 4,
              children: [
                CommonBadge(label: widget.match.category),
                CommonBadge(label: 'Ranking'),
                _buildCourtStatusBadge(),
              ],
            ),
          ),
          12.heightBox,
        ],
      ),
    );
  }

  Widget _buildCourtStatusBadge() {
    final isConfirmed = widget.match.courtStatus == CourtStatus.confirmed;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isConfirmed 
            ? kGreenColor.withValues(alpha: 0.1)
            : kGreyColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConfirmed ? kGreenColor : kGreyTextColor,
        ),
      ),
      child: Text(
        isConfirmed ? 'Court Confirmed' : 'Pending Confirmed',
        style: AppStyles.w500f10inter.copyWith(
          color: isConfirmed ? kGreenColor : kGreyTextColor,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodForm() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CustomTextField(
            controller: _cardHolderController,
            hintText: 'Cardholder name',
            borderRadius: 12,
          ),
          12.heightBox,
          CustomTextField(
            controller: _cardNumberController,
            hintText: 'Card number',
            borderRadius: 12,
            keyboardType: TextInputType.number,
          ),
          12.heightBox,
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _expiryController,
                  hintText: 'MM/YY',
                  borderRadius: 12,
                  keyboardType: TextInputType.number,
                ),
              ),
              12.widthBox,
              Expanded(
                child: CustomTextField(
                  controller: _cvvController,
                  hintText: 'CVV',
                  borderRadius: 12,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                ),
              ),
            ],
          ),
          16.heightBox,
          Row(
            children: [
              Icon(Icons.lock, size: 16, color: kGreenColor),
              8.widthBox,
              Text(
                'Secure Encrypted Payment',
                style: AppStyles.w400f12inter.copyWith(color: kGreenColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetails(double matchFee, double serviceFee, double total) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildPriceRow('Match Fee (2 hrs)', '\$${matchFee.toStringAsFixed(2)}'),
          12.heightBox,
          _buildPriceRow('Service Fee', '\$${serviceFee.toStringAsFixed(2)}'),
          16.heightBox,
          Divider(color: kBorderColor),
          16.heightBox,
          _buildPriceRow('Total', '\$${total.toStringAsFixed(2)}', isBold: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppStyles.w600f14inter.copyWith(color: kDarkTextColor)
              : AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
        ),
        Text(
          value,
          style: isBold
              ? AppStyles.w600f16inter.copyWith(color: kDarkTextColor)
              : AppStyles.w400f14inter.copyWith(color: kDarkTextColor),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  void _processPayment() {
    // TODO: Implement payment processing
    Navigator.pop(context);
  }
}
