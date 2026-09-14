// lib/utils/validators/card_validators.dart
import 'package:credit_card_validator/credit_card_validator.dart';

/// Global, reusable card-payment validators — mirrors the pattern used by
/// ValidateForm, but scoped to credit/debit card fields so any payment
/// screen (class lessons, match bookings, etc.) can share the same rules.
class CardValidators {
  static final CreditCardValidator _validator = CreditCardValidator();

  static String? validateCardholder(String? value) {
    final v = value?.trim() ?? '';

    if (v.isEmpty) {
      return 'Enter the cardholder name';
    }

    if (!RegExp(r'^[a-zA-Z\s]{2,}$').hasMatch(v)) {
      return 'Enter a valid name';
    }

    return null;
  }

  static String? validateCardNumber(String? value) {
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

  static String? validateExpiry(String? value) {
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

  /// [cardNumber] is optional — pass the current card-number field's text
  /// so the CVV length can be checked against the detected card type
  /// (Amex uses 4 digits, most others use 3). Falls back to a plain
  /// 3–4 digit length check if no card number is available yet.
  static String? validateCVV(String? value, {String? cardNumber}) {
    final v = value?.trim() ?? '';

    if (v.isEmpty) {
      return 'Enter CVV';
    }

    final digits = (cardNumber ?? '').replaceAll(RegExp(r'\s'), '');

    if (digits.isNotEmpty) {
      final cardResult = _validator.validateCCNum(digits);
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
}
