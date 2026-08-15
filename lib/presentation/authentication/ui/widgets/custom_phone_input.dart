import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '/app_exports.dart'; // keep your styles/colors

class CustomPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String initialCountryCode;
  final Function(String completeNumber)? onChanged;
  final String? Function(String?)? validator;

  const CustomPhoneField({
    super.key,
    required this.controller,
    this.initialCountryCode = 'SA', // Changed default to Saudi Arabia
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // Get Saudi Arabia country object
    final saudiCountry = countries.firstWhere(
      (country) => country.code == 'SA',
    );

    return IntlPhoneField(
      controller: controller,
      initialCountryCode: initialCountryCode,
      // Restrict to only Saudi Arabia
      countries: [saudiCountry],
      // Disable country selection dropdown
      showDropdownIcon: false,
      // Show country flag but make it non-interactive
      showCountryFlag: true,
      decoration: InputDecoration(
        hintText: "5XX XXX XXXX",
        // Saudi mobile number format
        hintStyle: AppStyles.w400f12inter.copyWith(
          fontSize: 14,
          color: const Color(0xff606060),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kPrimaryColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kPrimaryColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kPrimaryColor, width: 1),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (validator != null) return validator!(value?.number);
        if (value == null || value.number.isEmpty) {
          return 'EnterValidPhoneNumber';
        }
        // Saudi mobile numbers validation
        // Should be 9 digits starting with 5
        if (value.number.length != 9) {
          return 'EnterValidPhoneNumber';
        }
        if (!value.number.startsWith('5')) {
          return 'EnterValidSaudiNumber'; // You may need to add this translation
        }
        return null;
      },
      onChanged: (phone) {
        if (onChanged != null) {
          // Only call onChanged if it's a valid Saudi number format
          if (phone.countryCode == '+966') {
            onChanged!(phone.completeNumber);
          }
        }
      },
    );
  }
}
