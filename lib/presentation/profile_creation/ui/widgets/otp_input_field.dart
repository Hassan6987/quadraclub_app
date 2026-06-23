import 'package:pinput/pinput.dart';
import 'package:quadraclub_app/app_exports.dart';

class OtpInputField extends StatelessWidget {
  final int length;
  final Function(String) onCompleted;
  final TextEditingController? controller;

  const OtpInputField({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: AppStyles.w500f16inter.copyWith(
        color: kTextPrimaryColor,
      ),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE4E4E7),
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF01386C),
          width: 2,
        ),
      ),
    );

    return Pinput(
      length: length,
      controller: controller,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      onCompleted: onCompleted,
      keyboardType: TextInputType.number,
    );
  }
}
