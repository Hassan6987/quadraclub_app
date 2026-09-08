import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:quadraclub_app/presentation/classes/bloc/classes_bloc.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';
import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

import '/app_exports.dart';

class PaymentForLessonScreen extends StatefulWidget {
  final Class classModel;

  const PaymentForLessonScreen({super.key, required this.classModel});

  @override
  State<PaymentForLessonScreen> createState() => _PaymentForLessonScreenState();
}

class _PaymentForLessonScreenState extends State<PaymentForLessonScreen> {
  final _formKey = GlobalKey<FormState>();
  final _validator = CreditCardValidator();

  final _cardholderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _usePortfolio = false;
  bool _agreedToTerms = false;
  bool _fieldsValid = false;

  static const double _convenienceFee = 2.0;

  double get _classPrice => widget.classModel.price?.toDouble() ?? 0.0;

  double get _total => _classPrice + _convenienceFee;

  @override
  void initState() {
    super.initState();

    _cardholderController.addListener(_revalidate);
    _cardNumberController.addListener(_revalidate);
    _expiryController.addListener(_revalidate);
    _cvvController.addListener(_revalidate);
  }

  // ============================================================
  // CARD VALIDATION
  // ============================================================

  void _revalidate() {
    // Portfolio doesn't need card validation.
    if (_usePortfolio) {
      if (_fieldsValid) {
        setState(() {
          _fieldsValid = false;
        });
      }
      return;
    }

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

    final expiryYear = 2000 + year;

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

    if (v.length < 3 || v.length > 4) {
      return 'Enter a valid CVV';
    }

    return null;
  }

  // ============================================================
  // PAYMENT SELECTION
  // ============================================================

  void _selectPortfolio(bool value) {
    if (!value) {
      setState(() {
        _usePortfolio = false;
      });

      _revalidate();
      return;
    }

    setState(() {
      _usePortfolio = true;
      _fieldsValid = false;
    });
  }

  void _selectCard() {
    setState(() {
      _usePortfolio = false;
    });

    _revalidate();
  }

  // ============================================================
  // CAN CONFIRM
  // ============================================================

  bool get _canConfirm {
    if (!_agreedToTerms) {
      return false;
    }

    // Portfolio selected.
    if (_usePortfolio) {
      return true;
    }

    // Card selected.
    return _fieldsValid;
  }

  // ============================================================
  // CONFIRM ENROLLMENT
  // ============================================================

  void _handleConfirm() {
    if (!_canConfirm) {
      return;
    }

    final classId = widget.classModel.id ?? '';

    if (classId.isEmpty) {
      context.showToast('Class ID is missing', isError: true);
      return;
    }

    /*
     * IMPORTANT:
     *
     * These are the exact values your backend needs:
     *
     * classId
     * isPortfolio
     * card details when isPortfolio == false
     *
     * When portfolio is selected:
     *   isPortfolio = true
     *   card fields = null/empty
     *
     * When card is selected:
     *   isPortfolio = false
     *   card fields = actual card data
     */

    if (_usePortfolio) {
      context.read<ClassesBloc>().add(
        EnrollInClass(
          classId: classId,
          isPortfolio: true,
          cardName: null,
          cardNumber: null,
          cvc: null,
          expiry: null,
        ),
      );
    } else {
      context.read<ClassesBloc>().add(
        EnrollInClass(
          classId: classId,
          isPortfolio: false,
          cardName: _cardholderController.text.trim(),
          cardNumber: _cardNumberController.text.replaceAll(RegExp(r'\s'), ''),
          cvc: _cvvController.text.trim(),
          expiry: _expiryController.text.trim(),
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Payment For Lesson",
        showActions: false,
        showBackIcon: true,
      ),

      body: BlocConsumer<ClassesBloc, ClassesState>(
        listener: (context, state) {
          if (state.status == ClassStats.success) {
            showDialog(
              context: context,
              builder: (_) => const ClassBookedDialog(),
            ).then((_) {
              if (!mounted) return;
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
          }

          if (state.status == ClassStats.failure) {
            context.showToast(
              state.error ?? 'Something went wrong',
              isError: true,
            );
          }
        },

        builder: (context, state) {
          final portfolioBalance = state.balance.toDouble();

          final portfolioEnabled = portfolioBalance >= _classPrice;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'After payment, your request will be sent to the Coach for approval.',
                        style: AppStyles.w400f14inter.copyWith(
                          color: kTextColor,
                        ),
                      ),

                      16.heightBox,

                      InfoCard(classModel: widget.classModel),

                      20.heightBox,

                      // ======================================================
                      // PORTFOLIO
                      // ======================================================
                      Text(
                        'PAYMENT METHOD',
                        style: AppStyles.w500f12inter.copyWith(
                          color: kDarkTextColor.withValues(alpha: 0.70),
                        ),
                      ),

                      8.heightBox,

                      _PortfolioPaymentOption(
                        balance: portfolioBalance,
                        amount: _classPrice,
                        isEnabled: portfolioEnabled,
                        isSelected: _usePortfolio,
                        onTap: () {
                          if (!portfolioEnabled) {
                            context.showToast(
                              'Insufficient portfolio balance',
                              isError: true,
                            );
                            return;
                          }

                          _selectPortfolio(true);
                        },
                      ),

                      12.heightBox,

                      // ======================================================
                      // CARD OPTION
                      // ======================================================
                      _CardPaymentOption(
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

                            cardholderValidator: _validateCardholder,

                            cardNumberValidator: _validateCardNumber,

                            expiryValidator: _validateExpiry,

                            cvvValidator: _validateCVV,
                          ),
                        ),
                      ],

                      20.heightBox,

                      PriceCard(
                        classPrice: _classPrice,
                        convenienceFee: _convenienceFee,
                        total: _total,
                      ),

                      14.heightBox,

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
                              onChanged: (value) {
                                setState(() {
                                  _agreedToTerms = value ?? false;
                                });
                              },
                              activeColor: kPrimaryColor,
                              checkColor: Colors.black,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: const BorderSide(color: kTextColor),
                            ),
                            6.widthBox,
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

              if (state.status == ClassStats.loading)
                Center(child: CustomLoadingView())
              else
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CustomActionButton(
                    buttonText: 'Confirm Lesson',
                    onTap: _handleConfirm,
                    isEnabled: _canConfirm,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _PortfolioPaymentOption extends StatelessWidget {
  final double balance;
  final double amount;
  final bool isEnabled;
  final bool isSelected;
  final VoidCallback onTap;

  const _PortfolioPaymentOption({
    required this.balance,
    required this.amount,
    required this.isEnabled,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                      'Portfolio Balance',
                      style: AppStyles.w500f14inter.copyWith(
                        color: kDarkTextColor,
                      ),
                    ),

                    4.heightBox,

                    Text(
                      'Balance: ${formatPrice(balance)}',
                      style: AppStyles.w400f12inter.copyWith(
                        color: kGreyTextColor,
                      ),
                    ),

                    if (!isEnabled) ...[
                      4.heightBox,
                      Text(
                        'Insufficient balance',
                        style: AppStyles.w400f12inter.copyWith(
                          color: Colors.red,
                        ),
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

class _CardPaymentOption extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _CardPaymentOption({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
                Icons.credit_card_outlined,
                color: kPrimaryColor,
              ),
            ),

            12.widthBox,

            Expanded(
              child: Text(
                'Credit / Debit Card',
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
