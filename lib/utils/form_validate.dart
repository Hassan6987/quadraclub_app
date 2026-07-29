class ValidateForm {
  static String? validateEmail(value) {
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
      return 'Please enter your email';
    }
    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Please enter a valid email'
        : null;
  }

  static String? validateField(value, String message) {
    if (value.isEmpty && value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  static String? fullNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter name';
    }
    if (value.length < 5) {
      return 'Username must be at least 5 characters';
    }
    if (value.length > 20) {
      return 'Username must be less than 20 characters';
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateNumericField(String? value) {
    if (value == null || value.isEmpty) {
      return "cannot be empty";
    }
    if (double.tryParse(value) == null) {
      return "enter a valid number";
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return "Address can't be empty";
    }
    if (value.length < 10) {
      return 'Address must be at least 10 characters';
    }
    return null;
  }

  static String? validateCollege(String? value) {
    if (value == null || value.isEmpty) {
      return "College name can not be empty";
    }
    return null;
  }

  static String? validateLink(String? value) {
    // If the value is null or empty, it's considered valid (optional field).
    if (value == null || value.isEmpty) {
      return null;
    }

    const urlPattern =
        r'^(http|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?$';
    final regExp = RegExp(urlPattern, caseSensitive: false);

    if (!regExp.hasMatch(value)) {
      return "Please enter a valid URL (e.g., https://example.com)";
    }

    // If the value is not null, not empty, and matches the URL pattern, it's valid.
    return null;
  }

  static String? validateBreedName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter breed name';
    }
    return null;
  }

  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'password cannot be empty';
    }
    return null;
  }
}
