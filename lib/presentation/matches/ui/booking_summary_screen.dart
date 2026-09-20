import 'package:quadraclub_app/presentation/agenda/bloc/agenda_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';
import 'package:quadraclub_app/presentation/matches/bloc/matches_bloc.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/match_card.dart';
import 'package:quadraclub_app/presentation/matches/ui/widgets/request_sent_dialog.dart';
import 'package:quadraclub_app/utils/card_validators.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/helper/date_formatter.dart';

import '/app_exports.dart';

class BookingSummaryScreen extends StatefulWidget {
  final Booking match;
  final double distanceKm;
  final String? message;

  const BookingSummaryScreen({
    super.key,
    required this.match,
    required this.distanceKm,
    this.message,
  });

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cardholderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _usePortfolio = false;
  bool _agreedToTerms = false;
  bool _fieldsValid = false;

  double get _matchFee {
    if (widget.match.paymentType == "pay_my_part") {
      return widget.match.totalPrice?.toDouble() ?? 0.0;
    } else if (widget.match.paymentType == "pay_all_receive_later") {
      if (widget.match.format == MatchFormat.singles) {
        return (widget.match.totalPrice?.toDouble() ?? 0.0) / 2;
      } else {
        return (widget.match.totalPrice?.toDouble() ?? 0.0) / 4;
      }
    } else {
      return widget.match.totalPrice?.toDouble() ?? 0.0;
    }
  }

  @override
  void initState() {
    super.initState();
    _cardholderController.addListener(_revalidate);
    _cardNumberController.addListener(_revalidate);
    _expiryController.addListener(_revalidate);
    _cvvController.addListener(_revalidate);
  }

  @override
  void dispose() {
    _cardholderController.removeListener(_revalidate);
    _cardNumberController.removeListener(_revalidate);
    _expiryController.removeListener(_revalidate);
    _cvvController.removeListener(_revalidate);

    _cardholderController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  // ============================================================
  // VALIDATION (now backed by the global CardValidators)
  // ============================================================

  void _revalidate() {
    if (_usePortfolio) {
      if (_fieldsValid) {
        setState(() => _fieldsValid = false);
      }
      return;
    }

    final cardholderValid =
        CardValidators.validateCardholder(_cardholderController.text) == null;
    final cardNumberValid =
        CardValidators.validateCardNumber(_cardNumberController.text) == null;
    final expiryValid =
        CardValidators.validateExpiry(_expiryController.text) == null;
    final cvvValid =
        CardValidators.validateCVV(
          _cvvController.text,
          cardNumber: _cardNumberController.text,
        ) ==
        null;

    final isValid =
        cardholderValid && cardNumberValid && expiryValid && cvvValid;

    if (isValid != _fieldsValid && mounted) {
      setState(() => _fieldsValid = isValid);
    }
  }

  // ============================================================
  // PAYMENT SELECTION
  // ============================================================

  void _selectPortfolio(bool value) {
    if (!value) {
      setState(() => _usePortfolio = false);
      _revalidate();
      return;
    }
    setState(() {
      _usePortfolio = true;
      _fieldsValid = false;
    });
  }

  void _selectCard() {
    setState(() => _usePortfolio = false);
    _revalidate();
  }

  bool get _canConfirm {
    if (!_agreedToTerms) return false;
    if (_usePortfolio) return true;
    return _fieldsValid;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          l10n.bookingSummary,
          style: AppStyles.w600f16inter.copyWith(color: kDarkTextColor),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<MatchesBloc, MatchesState>(
        listener: (context, state) {
          if (state.status == MatchesStateStatus.booked) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => RequestSentDialog(),
            ).then((_) {
              if (!mounted) return;
              Navigator.of(context).popUntil((route) => route.isFirst);
              context.read<AgendaBloc>().add(GetAllAgenda());
            });
          }

          if (state.status == MatchesStateStatus.failure) {
            context.showToast(
              state.error ?? l10n.somethingWentWrong,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          final portfolioBalance = state.balance.toDouble();
          final portfolioEnabled = portfolioBalance >= _matchFee;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(l10n.courtDetails),
                      8.heightBox,
                      _buildCourtDetailsCard(widget.match),
                      20.heightBox,

                      _buildSectionHeader(l10n.paymentMethod),
                      8.heightBox,

                      PortfolioPaymentOption(
                        balance: portfolioBalance,
                        amount: _matchFee,
                        isEnabled: portfolioEnabled,
                        isSelected: _usePortfolio,
                        onTap: () {
                          if (!portfolioEnabled) {
                            context.showToast(
                              l10n.insufficientPortfolioBalance,
                              isError: true,
                            );
                            return;
                          }
                          _selectPortfolio(true);
                        },
                      ).withPaddingSymmetric(20, 0),

                      12.heightBox,

                      CardPaymentOption(
                        isSelected: !_usePortfolio,
                        onTap: _selectCard,
                      ).withPaddingSymmetric(20, 0),

                      if (!_usePortfolio) ...[
                        10.heightBox,
                        Form(
                          key: _formKey,
                          child: PaymentForm(
                            cardholderController: _cardholderController,
                            cardNumberController: _cardNumberController,
                            expiryController: _expiryController,
                            cvvController: _cvvController,
                            cardholderValidator: (v) =>
                                CardValidators.validateCardholder(v, l10n),
                            cardNumberValidator: (v) =>
                                CardValidators.validateCardNumber(v, l10n),
                            expiryValidator: (v) =>
                                CardValidators.validateExpiry(v, l10n),
                            cvvValidator: (v) => CardValidators.validateCVV(
                              v,
                              cardNumber: _cardNumberController.text,
                              l10n: l10n,
                            ),
                          ),
                        ).withPaddingSymmetric(20, 0),
                      ],

                      20.heightBox,
                      _buildSectionHeader(l10n.priceDetails),
                      8.heightBox,
                      _buildPriceDetails(_matchFee, 0, _matchFee),
                      16.heightBox,

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
                                l10n.agreeToTermsOfUse,
                                style: AppStyles.w400f14inter.copyWith(
                                  color: kTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).withPaddingSymmetric(20, 0),
                    ],
                  ),
                ),
              ),
              if (state.status == MatchesStateStatus.booking)
                Center(child: CustomLoadingView())
              else
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CustomActionButton(
                    buttonText: l10n.payNow,
                    onTap: _canConfirm ? _processPayment : null,
                    isEnabled: _canConfirm,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: AppStyles.w500f12inter.copyWith(
          color: kGreyTextColor.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _buildCourtDetailsCard(Booking match) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AppCachedImage(
                  imageUrl: match.club?.photo ?? '',
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
                        buildSeatsBadge(context, match),
                      ],
                    ),
                    Text(
                      match.club?.name ?? '',
                      style: AppStyles.w600f16inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),
                    Text(
                      "${match.club?.city} • ${formatDistanceKm(widget.distanceKm, AppLocalizations.of(context)!)} • ${getFormatDateMonth(match.bookingDate, locale: AppLocalizations.of(context)!.localeName)}",
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
              CommonBadge(label: '${match.startTime}-${match.endTime}'),
              4.widthBox,
              CommonBadge(
                label: localizedMatchCategory(context, match.category),
              ),
              4.widthBox,
              CommonBadge(label: AppLocalizations.of(context)!.ranking),
              4.widthBox,
              buildCourtStatusBadge(context, match),
            ],
          ),
          12.heightBox,
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
                AppLocalizations.of(context)!.matchFee,
                style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
              ),
              Text(
                formatPrice(matchFee),
                style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
              ),
            ],
          ),
          8.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.serviceFee,
                style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
              ),
              Text(
                formatPrice(serviceFee),
                style: AppStyles.w500f14inter.copyWith(color: kDarkTextColor),
              ),
            ],
          ),
          const Divider(height: 24, color: kBorderColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.total,
                style: AppStyles.w400f14inter.copyWith(color: kGreyTextColor),
              ),
              Text(
                formatPrice(total),
                style: AppStyles.w600f16inter.copyWith(color: kBlueColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _processPayment() {
    if (!_canConfirm) return;
    context.read<MatchesBloc>().add(
      JoinMatchBooking(
        bookingId: widget.match.id ?? '',
        isPortfolio: _usePortfolio,
        cvc: _cvvController.text,
        cardName: _cardholderController.text,
        cardNumber: _cardNumberController.text,
        expiry: _expiryController.text,
        message: widget.message,
        amount: _matchFee,
      ),
    );
  }
}
