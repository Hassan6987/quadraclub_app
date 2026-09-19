import 'package:quadraclub_app/l10n/app_localizations.dart';

class ValidateForm {
  static String? validateEmail(String? value, [AppLocalizations? l10n]) {
    const pattern =
        r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return l10n?.pleaseEnterYourEmail ?? 'Please enter your email';
    }
    return value.isNotEmpty && !regex.hasMatch(value)
        ? (l10n?.pleaseEnterValidEmail ?? 'Please enter a valid email')
        : null;
  }

  static String? validateField(String? value, String message) {
    if (value == null || value.isEmpty || value
        .trim()
        .isEmpty) {
      return message;
    }
    return null;
  }

  static String? passwordValidator(String? value, [AppLocalizations? l10n]) {
    if (value == null || value.isEmpty) {
      return l10n?.passwordCannotBeEmpty ?? 'Password cannot be empty';
    }
    if (value.length < 8) {
      return l10n?.passwordMinEightCharacters ??
          'Password must be at least 8 characters';
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return l10n?.passwordMustContainLowercase ??
          'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return l10n?.passwordMustContainUppercase ??
          'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return l10n?.passwordMustContainNumber ??
          'Password must contain at least one number';
    }
    return null;
  }

  static String? fullNameValidator(String? value, [AppLocalizations? l10n]) {
    if (value == null || value.isEmpty) {
      return l10n?.pleaseEnterName ?? 'Please enter name';
    }
    if (value.length < 5) {
      return l10n?.fullNameMinFiveCharacters ??
          'Full name must be at least 5 characters';
    }
    if (value.length > 40) {
      return l10n?.fullNameMaxFortyCharacters ??
          'Full name must be less than 40 characters';
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value,
      String? password, [
        AppLocalizations? l10n,
      ]) {
    if (value == null || value.isEmpty) {
      return l10n?.pleaseConfirmYourPassword ?? 'Please confirm your password';
    }
    if (value != password) {
      return l10n?.passwordsDoNotMatch ?? 'Passwords do not match';
    }
    return null;
  }

  static String? validateNumericField(String? value, [AppLocalizations? l10n]) {
    if (value == null || value.isEmpty) {
      return l10n?.cannotBeEmpty ?? 'Cannot be empty';
    }
    if (double.tryParse(value) == null) {
      return l10n?.enterAValidNumber ?? 'Enter a valid number';
    }
    return null;
  }

  static String? validateAddress(String? value, [AppLocalizations? l10n]) {
    if (value == null || value.isEmpty) {
      return l10n?.addressCannotBeEmpty ?? "Address can't be empty";
    }
    if (value.length < 10) {
      return l10n?.addressMinTenCharacters ??
          'Address must be at least 10 characters';
    }
    return null;
  }

  static String? validateCollege(String? value, [AppLocalizations? l10n]) {
    if (value == null || value.isEmpty) {
      return l10n?.collegeNameCannotBeEmpty ?? 'College name can not be empty';
    }
    return null;
  }

  static String? validateLink(String? value, [AppLocalizations? l10n]) {
    if (value == null || value.isEmpty) {
      return null;
    }

    const urlPattern =
        r'^(http|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?$';
    final regExp = RegExp(urlPattern, caseSensitive: false);

    if (!regExp.hasMatch(value)) {
      return l10n?.pleaseEnterValidUrl ??
          'Please enter a valid URL (e.g., https://example.com)';
    }

    return null;
  }

  static String? validateBreedName(String? value, [AppLocalizations? l10n]) {
    if (value == null || value.isEmpty) {
      return l10n?.pleaseEnterBreedName ?? 'Please enter breed name';
    }
    return null;
  }

  static String? validateLoginPassword(String? value,
      [AppLocalizations? l10n]) {
    if (value == null || value.isEmpty) {
      return l10n?.passwordCannotBeEmpty ?? 'Password cannot be empty';
    }
    return null;
  }
}
