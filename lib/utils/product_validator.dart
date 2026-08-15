// lib/utils/validators/product_validator.dart

class ProductValidator {
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return 'Product title is required';
    }
    return null;
  }

  static String? validateCredits(String? value) {
    if (value == null || value.isEmpty) {
      return "Credits cannot be empty";
    }
    if (double.tryParse(value) == null) {
      return "Please enter a valid number";
    }
    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return 'Description is required';
    }
    return null;
  }
}
