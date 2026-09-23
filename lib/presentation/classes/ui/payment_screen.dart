import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:quadraclub_app/data/service_fees/service_fees_model.dart';
import 'package:quadraclub_app/data/service_fees/service_fees_repo.dart';
import 'package:quadraclub_app/di/locator.dart';
import 'package:quadraclub_app/presentation/agenda/bloc/agenda_bloc.dart';
import 'package:quadraclub_app/presentation/classes/bloc/classes_bloc.dart';
import 'package:quadraclub_app/presentation/classes/data/model/class_models.dart';
import 'package:quadraclub_app/utils/card_validators.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';

import '/app_exports.dart';

class PaymentForLessonScreen extends StatefulWidget {
  final Class classModel;
  final double distanceKm;

  const PaymentForLessonScreen({
    super.key,
    required this.classModel,
    required this.distanceKm,
  });

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

  FeeTier _convenienceFee = FeeTier.zero;

  double get _classPrice => widget.classModel.price?.toDouble() ?? 0.0;

  double get _total => _classPrice + _convenienceFee.current;

  @override
  void initState() {
    super.initState();

    _cardholderController.addListener(_revalidate);
    _cardNumberController.addListener(_revalidate);
    _expiryController.addListener(_revalidate);
    _cvvController.addListener(_revalidate);

    _loadServiceFees();
  }

  Future<void> _loadServiceFees() async {
    try {
      final fees = await locator.get<ServiceFeesRepo>().getServiceFees();
      if (!mounted) return;
      setState(() => _convenienceFee = fees.classes);
    } catch (_) {
      if (!mounted) return;
      setState(() => _convenienceFee = FeeTier.zero);
    }
  }
  // ============================================================
  // CARD VALIDATION
  // ============================================================

  void _revalidate() {
    if (_usePortfolio) {
      if (_fieldsValid) {
        setState(() {
          _fieldsValid = false;
        });
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
      setState(() {
        _fieldsValid = isValid;
      });
    }
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.paymentForLesson,
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
              context.read<AgendaBloc>().add(GetAllAgenda());
            });
          }

          if (state.status == ClassStats.failure) {
            context.showToast(
              state.error ?? l10n.somethingWentWrong,
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
                        l10n.afterPaymentCoachApproval,
                        style: AppStyles.w400f14inter.copyWith(
                          color: kTextColor,
                        ),
                      ),

                      16.heightBox,

                      InfoCard(
                        classModel: widget.classModel,
                        distanceKm: widget.distanceKm,
                      ),

                      20.heightBox,

                      // ======================================================
                      // PORTFOLIO
                      // ======================================================
                      Text(
                        l10n.paymentMethod,
                        style: AppStyles.w500f12inter.copyWith(
                          color: kDarkTextColor.withValues(alpha: 0.70),
                        ),
                      ),

                      8.heightBox,

                      PortfolioPaymentOption(
                        balance: portfolioBalance,
                        amount: _classPrice,
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

                      // ======================================================
                      // CARD OPTION
                      // ======================================================
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

              if (state.status == ClassStats.loading)
                Center(child: CustomLoadingView())
              else
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CustomActionButton(
                    buttonText: l10n.confirmLesson,
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
