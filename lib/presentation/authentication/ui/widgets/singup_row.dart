import 'package:quadraclub_app/app_exports.dart';

class SignupRichText extends StatelessWidget {
  final VoidCallback onSignUpTap;

  const SignupRichText({super.key, required this.onSignUpTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: AppStyles.w400f12inter.copyWith(
            fontSize: 14,
            color: kTertiaryColor,
          ),
          children: [
            TextSpan(text: "donNotHaveAccount"),
            TextSpan(
              text: 'signUp',
              style: const TextStyle(
                color: kPrimaryColor, // link color
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = onSignUpTap,
            ),
          ],
        ),
      ),
    );
  }
}
