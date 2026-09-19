import 'package:cached_network_image/cached_network_image.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/agenda/bloc/agenda_bloc.dart';
import 'package:quadraclub_app/presentation/home/bloc/courts_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/individual_booking_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/match_booking_model.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/booking_confirmation_screen.dart';
import 'package:quadraclub_app/utils/card_validators.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/helper/date_formatter.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/booking/booking_models.dart';

class PaymentMethodScreen extends StatefulWidget {
  final Club club;
  final Court court;
  final String dateLabel;
  final String timeLabel;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final double amount;
  final bool isMatch;
  final List<String> invitedPlayers;
  final String? matchType;
  final String? matchFormat;
  final String? paymentType;
  final double distance;

  const PaymentMethodScreen({
    super.key,
    required this.club,
    required this.court,
    required this.dateLabel,
    required this.timeLabel,
    required this.amount,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    this.isMatch = false,
    this.invitedPlayers = const [],
    this.matchType,
    this.matchFormat,
    this.paymentType,
    required this.distance,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cardholderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _usePortfolio = false;
  bool _agreedToTerms = false;
  bool _fieldsValid = false;

  double get _serviceFee => (widget.amount * 2) / 100;

  double get _total => widget.amount + _serviceFee;

  @override
  void initState() {
    super.initState();

    _cardholderController.addListener(_revalidate);
    _cardNumberController.addListener(_revalidate);
    _expiryController.addListener(_revalidate);
    _cvvController.addListener(_revalidate);
  }

  /// Calculates the overall form validity silently.
  ///
  /// IMPORTANT:
  /// Do not call _formKey.currentState?.validate() here.
  /// Calling FormState.validate() would force all TextFormFields
  /// to show their validation errors even when the user hasn't
  /// interacted with them yet.
  void _revalidate() {
    // Portfolio doesn't need card validation.
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

  bool get _canPay {
    if (!_agreedToTerms) return false;

    if (_usePortfolio) return true;

    return _fieldsValid;
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

  void _onPayNow() {
    if (!_canPay) return;

    if (widget.isMatch) {
      final bookingModel = MatchBookingModel(
        clubId: widget.club.id ?? '',
        courtId: widget.court.id ?? '',
        bookingDate: widget.bookingDate,
        startTime: widget.startTime,
        endTime: widget.endTime,
        matchType: widget.matchType ?? '',
        format: widget.matchFormat ?? '',
        paymentType: widget.paymentType ?? '',
        invitedPlayers: widget.invitedPlayers,

        cardHolderName: _usePortfolio ? '' : _cardholderController.text.trim(),

        cardNo: _usePortfolio ? '' : _cardNumberController.text.trim(),

        cvc: _usePortfolio ? '' : _cvvController.text.trim(),

        cardExpiryDate: _usePortfolio ? '' : _expiryController.text.trim(),

        totalPrice: widget.amount.toInt(),
        serviceFee: _serviceFee.toInt(),
        isPortfolio: _usePortfolio,
      );

      context.read<CourtsBloc>().add(BookMatch(bookingData: bookingModel));
    } else {
      final bookingModel = IndividualBookingModel(
        clubId: widget.club.id ?? '',
        courtId: widget.court.id ?? '',
        bookingDate: widget.bookingDate,
        startTime: widget.startTime,
        endTime: widget.endTime,

        cardHolderName: _usePortfolio ? '' : _cardholderController.text.trim(),

        cardNo: _usePortfolio ? '' : _cardNumberController.text.trim(),

        cvc: _usePortfolio ? '' : _cvvController.text.trim(),

        cardExpiryDate: _usePortfolio ? '' : _expiryController.text.trim(),

        totalPrice: widget.amount.toInt(),
        serviceFee: _serviceFee.toInt(),
        isPortfolio: _usePortfolio,
      );

      context.read<CourtsBloc>().add(BookIndividual(bookingData: bookingModel));
    }
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
            margin: const EdgeInsets.all(8),
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
      body: BlocConsumer<CourtsBloc, CourtsState>(
        listener: (context, state) {
          if (state.status == CourtStateStatus.booked) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BookingConfirmationScreen(
                  club: widget.club,
                  dateLabel: widget.dateLabel,
                  timeLabel: widget.timeLabel,
                  blockLabel: widget.court.courtName ?? '',
                  distance: widget.distance,
                ),
              ),
            );

            context.read<AgendaBloc>().add(GetAllAgenda());
          } else if (state.status == CourtStateStatus.failure) {
            context.showToast(
              state.error ?? l10n.somethingWentWrong,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          // TODO: replace with the real portfolio/wallet balance once a
          // source is available on CourtsState.
          final portfolioBalance = state.balance.toDouble();
          final portfolioEnabled = portfolioBalance >= _total;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =======================================================
                      // COURT DETAILS
                      // =======================================================
                      Text(
                        l10n.courtDetails,
                        style: AppStyles.w500f12inter.copyWith(
                          color: kTextColor,
                        ),
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
                              child: CachedNetworkImage(
                                imageUrl: widget.club.photo ?? '',
                                height: 96,
                                width: 96,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        height: 96,
                                        width: 96,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                errorWidget: (context, url, error) {
                                  return Image.asset(
                                    Assets.png.clubLogo.path,
                                    height: 96,
                                    width: 96,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            12.widthBox,

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.club.name ?? '',
                                    style: AppStyles.w600f16inter.copyWith(
                                      color: kDarkTextColor,
                                    ),
                                  ),
                                  Text(
                                    '${widget.club.city ?? ''} • ${formatDistanceKm(widget.distance, AppLocalizations.of(context)!)}',
                                    style: AppStyles.w400f14inter.copyWith(
                                      color: kTextColor,
                                    ),
                                  ),
                                  Text(
                                    '${widget.dateLabel} | ${widget.timeLabel}',
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

                      // =======================================================
                      // PAYMENT METHOD
                      // =======================================================
                      Text(
                        l10n.paymentMethod,
                        style: AppStyles.w500f12inter.copyWith(
                          color: kTextColor,
                        ),
                      ),
                      8.heightBox,

                      PortfolioPaymentOption(
                        balance: portfolioBalance,
                        amount: _total,
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
                      ),

                      12.heightBox,

                      CardPaymentOption(
                        isSelected: !_usePortfolio,
                        onTap: _selectCard,
                      ),

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
                        ),
                      ],

                      20.heightBox,

                      // =======================================================
                      // PRICE DETAILS
                      // =======================================================
                      Text(
                        l10n.priceDetails,
                        style: AppStyles.w500f12inter.copyWith(
                          color: kTextColor,
                        ),
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
                                  l10n.courtFee,
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
                                  l10n.serviceFee,
                                  style: AppStyles.w400f14inter.copyWith(
                                    color: kGreyTextColor,
                                  ),
                                ),
                                Text(
                                  '${_serviceFee.toInt()} %',
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
                                  l10n.total,
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

                      // =======================================================
                      // TERMS
                      // =======================================================
                      GestureDetector(
                        onTap: () {
                          setState(() => _agreedToTerms = !_agreedToTerms);
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: _agreedToTerms,
                              activeColor: kPrimaryColor,
                              side: const BorderSide(
                                color: kTextColor,
                                width: 2,
                              ),
                              onChanged: (value) {
                                setState(() => _agreedToTerms = value ?? false);
                              },
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
                      ),
                    ],
                  ),
                ),
              ),

              // =============================================================
              // PAY NOW
              // =============================================================
              if (state.status == CourtStateStatus.booking)
                Center(child: CustomLoadingView()),

              if (state.status != CourtStateStatus.booking)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CustomActionButton(
                    buttonText: l10n.payNow,
                    isEnabled: _canPay,
                    onTap: _onPayNow,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ===========================================================================
// EXPIRY DATE FORMATTER
// ===========================================================================

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      return const TextEditingValue();
    }

    final limitedDigits = digits.length > 4 ? digits.substring(0, 4) : digits;

    String formatted;

    if (limitedDigits.length <= 2) {
      formatted = limitedDigits;
    } else {
      formatted =
          '${limitedDigits.substring(0, 2)}/${limitedDigits.substring(2)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// ===========================================================================
// CARD NUMBER FORMATTER
// ===========================================================================

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) {
      return const TextEditingValue();
    }

    final limitedDigits = digits.length > 16 ? digits.substring(0, 16) : digits;

    final buffer = StringBuffer();

    for (int i = 0; i < limitedDigits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }

      buffer.write(limitedDigits[i]);
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
