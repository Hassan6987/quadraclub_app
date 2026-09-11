import 'package:cached_network_image/cached_network_image.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/home/bloc/courts_bloc.dart';
import 'package:quadraclub_app/presentation/home/data/models/clubs_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/individual_booking_model.dart';
import 'package:quadraclub_app/presentation/home/data/models/match_booking_model.dart';
import 'package:quadraclub_app/presentation/home/ui/booking/booking_confirmation_screen.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
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
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _validator = CreditCardValidator();

  final _cardholderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

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
    final cardholderValid =
        _validateCardholder(_cardholderController.text) == null;

    final cardNumberValid =
        _validateCardNumber(_cardNumberController.text) == null;

    final expiryValid = _validateExpiry(_expiryController.text) == null;

    final cvvValid = _validateCVV(_cvvController.text) == null;

    final isValid =
        cardholderValid && cardNumberValid && expiryValid && cvvValid;

    if (isValid != _fieldsValid && mounted) {
      setState(() {
        _fieldsValid = isValid;
      });
    }
  }

  String? _validateCardholder(String? value) {
    final v = value?.trim() ?? '';

    if (v.isEmpty) {
      return 'Enter the cardholder name';
    }

    if (!RegExp(r'^[a-zA-Z\s]{2,}$').hasMatch(v)) {
      return 'Enter a valid name';
    }

    return null;
  }

  String? _validateCardNumber(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\s'), '');

    if (digits.isEmpty) {
      return 'Enter your card number';
    }

    final result = _validator.validateCCNum(digits);

    if (!result.isValid) {
      return 'Enter a valid card number';
    }

    return null;
  }

  String? _validateExpiry(String? value) {
    final v = value?.trim() ?? '';

    if (v.isEmpty) {
      return 'Enter expiry date';
    }

    // Expected format is MM/YY.
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(v)) {
      return 'Enter expiry as MM/YY';
    }

    final parts = v.split('/');

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) {
      return 'Enter a valid expiry date';
    }

    if (month < 1 || month > 12) {
      return 'Enter a valid expiry month';
    }

    final now = DateTime.now();

    // Convert YY to 20YY.
    final expiryYear = 2000 + year;

    // A card is valid through the final day of its expiry month.
    final expiryDate = DateTime(expiryYear, month + 1, 0, 23, 59, 59);

    if (expiryDate.isBefore(now)) {
      return 'Card has expired';
    }

    return null;
  }

  String? _validateCVV(String? value) {
    final v = value?.trim() ?? '';

    if (v.isEmpty) {
      return 'Enter CVV';
    }

    final cardNumber = _cardNumberController.text.replaceAll(RegExp(r'\s'), '');

    // If the card number is not valid yet, don't try to determine
    // the card type. We still validate CVV length below.
    if (cardNumber.isNotEmpty) {
      final cardResult = _validator.validateCCNum(cardNumber);

      if (cardResult.isValid) {
        final result = _validator.validateCVV(v, cardResult.ccType);

        if (!result.isValid) {
          return 'Enter a valid CVV';
        }

        return null;
      }
    }

    // Fallback while card number is incomplete.
    if (v.length < 3 || v.length > 4) {
      return 'Enter a valid CVV';
    }

    return null;
  }

  bool get _canPay => _fieldsValid && _agreedToTerms;

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
    if (!_canPay) {
      return;
    }

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
        cardHolderName: _cardholderController.text.trim(),
        cardNo: _cardNumberController.text.trim(),
        cvc: _cvvController.text.trim(),
        cardExpiryDate: _expiryController.text..trim(),
        totalPrice: widget.amount.toInt(),
        serviceFee: _serviceFee.toInt(),
      );
      context.read<CourtsBloc>().add(BookMatch(bookingData: bookingModel));
    } else {
      final bookingModels = IndividualBookingModel(
        clubId: widget.club.id ?? '',
        courtId: widget.court.id ?? '',
        bookingDate: widget.bookingDate,
        startTime: widget.startTime,
        endTime: widget.endTime,
        cardHolderName: _cardholderController.text.trim(),
        cardNo: _cardNumberController.text.trim(),
        cvc: _cvvController.text.trim(),
        cardExpiryDate: _expiryController.text..trim(),
        totalPrice: widget.amount.toInt(),
        serviceFee: _serviceFee.toInt(),
      );

      context.read<CourtsBloc>().add(
        BookIndividual(bookingData: bookingModels),
      );
    }
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
            margin: const EdgeInsets.all(8),

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
                ),
              ),
            );
          } else if (state.status == CourtStateStatus.failure) {
            context.showToast(
              state.error ?? "Something Went wrong",
              isError: true,
            );
          }
        },
        builder: (context, state) {
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
                      // =========================================================
                      // COURT DETAILS
                      // =========================================================
                      Text(
                        'COURT DETAILS',
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
                                    '${widget.court.courtName ?? ''} • ${widget.club.city}',
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

                      // =========================================================
                      // PAYMENT METHOD
                      // =========================================================
                      Text(
                        'PAYMENT METHOD',
                        style: AppStyles.w500f12inter.copyWith(
                          color: kTextColor,
                        ),
                      ),

                      8.heightBox,

                      Form(
                        key: _formKey,

                        // IMPORTANT:
                        // We intentionally don't set autovalidateMode here.
                        //
                        // Each CustomTextField handles its own validation
                        // using AutovalidateMode.onUserInteraction.
                        //
                        // This prevents an interaction with one field from
                        // validating all fields.
                        child: Container(
                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            color: kWhiteColor,
                            border: Border.all(color: kBorderF0),
                            borderRadius: BorderRadius.circular(24),
                          ),

                          child: Column(
                            children: [
                              // =================================================
                              // CARDHOLDER
                              // =================================================
                              CustomTextField(
                                controller: _cardholderController,

                                hintText: 'Cardholder name',

                                validator: _validateCardholder,

                                keyboardType: TextInputType.name,

                                prefixIcon: const Icon(Icons.person_outline),

                                borderRadius: 14,

                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\s]'),
                                  ),
                                ],
                              ),

                              12.heightBox,

                              // =================================================
                              // CARD NUMBER
                              // =================================================
                              CustomTextField(
                                controller: _cardNumberController,

                                hintText: 'Card number',

                                validator: _validateCardNumber,

                                keyboardType: TextInputType.number,

                                prefixIcon: const Icon(
                                  Icons.credit_card_outlined,
                                ),

                                inputFormatters: [CardNumberInputFormatter()],

                                maxLength: 19,

                                borderRadius: 14,
                              ),

                              12.heightBox,

                              // =================================================
                              // EXPIRY + CVV
                              // =================================================
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      controller: _expiryController,

                                      hintText: 'MM/YY',

                                      validator: _validateExpiry,

                                      keyboardType: TextInputType.number,

                                      prefixIcon: const Icon(
                                        Icons.calendar_month_outlined,
                                      ),

                                      inputFormatters: [
                                        ExpiryDateInputFormatter(),
                                      ],

                                      maxLength: 5,

                                      borderRadius: 14,
                                    ),
                                  ),

                                  12.widthBox,

                                  Expanded(
                                    child: CustomTextField(
                                      controller: _cvvController,

                                      hintText: 'CVV',

                                      validator: _validateCVV,

                                      keyboardType: TextInputType.number,

                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                      ),

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
                            ],
                          ),
                        ),
                      ),

                      14.heightBox,

                      // =========================================================
                      // SECURITY LABEL
                      // =========================================================
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

                      // =========================================================
                      // PRICE DETAILS
                      // =========================================================
                      Text(
                        'PRICE DETAILS',
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
                                  'Court Fee',
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

                      // =========================================================
                      // TERMS
                      // =========================================================
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _agreedToTerms = !_agreedToTerms;
                          });
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
                                setState(() {
                                  _agreedToTerms = value ?? false;
                                });
                              },
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

              // ===============================================================
              // PAY NOW
              // ===============================================================
              if (state.status == CourtStateStatus.booking)
                Center(child: CustomLoadingView()),
              if (state.status != CourtStateStatus.booking)
                Padding(
                  padding: const EdgeInsets.all(16),

                  child: CustomActionButton(
                    buttonText: 'Pay Now',
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
//
// User types:
//
// 0      -> 0
// 02     -> 02
// 022    -> 02/2
// 0228   -> 02/28
//
// The user never needs to type "/" manually.
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
//
// User types:
//
// 4242
// 4242 4
// 4242 4242
// 4242 4242 4242
// 4242 4242 4242 4242
//
// The validator removes the spaces before validating.
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
