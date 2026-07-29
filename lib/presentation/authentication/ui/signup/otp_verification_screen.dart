import 'dart:async';

import 'package:pinput/pinput.dart';
import 'package:quadraclub_app/presentation/authentication/data/model/signup_data.dart';
import 'package:quadraclub_app/presentation/authentication/ui/signup/about_you_screen.dart';
import 'package:quadraclub_app/presentation/authentication/ui/signup/onboarding_app_bar.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';

import '/app_exports.dart';

class OtpVerificationScr extends StatefulWidget {
  final SignupData data;

  const OtpVerificationScr({super.key, required this.data});

  @override
  State<OtpVerificationScr> createState() => _OtpVerificationScrState();
}

class _OtpVerificationScrState extends State<OtpVerificationScr> {
  final TextEditingController _otpController = TextEditingController();
  bool _isButtonEnabled = false;

  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _updateButtonState(String value) {
    setState(() {
      _isButtonEnabled = value.length == 6;
    });
  }

  void _onVerify() {
    if (_isButtonEnabled) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AboutYouScreen(data: widget.data)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 48,
      textStyle: AppStyles.titleMedium.copyWith(color: kBlackColor),
      decoration: BoxDecoration(
        color: kWhiteColor,
        border: Border.all(color: kBorderColor, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
    );
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: const OnboardingAppBar(currentStep: 2, totalSteps: 5),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dim.PADDING_SIZE_LARGE),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.heightBox,
            Text(
              "OTP Verification",
              style: AppStyles.w600f18inter.copyWith(color: kTextPrimaryColor),
            ),
            8.heightBox,
            Text.rich(
              TextSpan(
                text: "Enter the 6-digit code sent to you at:\n",
                style: AppStyles.w400f14inter.copyWith(
                  color: kTextSecondary.withValues(alpha: 0.60),
                ),
                children: [
                  TextSpan(
                    text: widget.data.email,
                    style: AppStyles.w500f14inter.copyWith(color: kBlackColor),
                  ),
                ],
              ),
            ),
            32.heightBox,
            Center(
              child: Pinput(
                length: 6,
                controller: _otpController,
                onChanged: _updateButtonState,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: kDarkTextColor, width: 2),
                  ),
                ),
              ),
            ),
            24.heightBox,
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  _secondsRemaining > 0
                      ? RichText(
                          text: TextSpan(
                            text: "I didn't receive a code ",
                            style: AppStyles.subtitleRegular.copyWith(
                              color: kTextSecondary.withValues(alpha: 0.70),
                            ),
                            children: [
                              TextSpan(
                                text: " (0:$_secondsRemaining)",
                                style: AppStyles.w500f14inter.copyWith(
                                  color: kTextPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            // context.read<AuthBloc>().add(RequestCode(email: widget.email));
                            _startTimer();
                          },
                          child: Text(
                            "Resend Code",
                            style: AppStyles.subtitleSemiBold.copyWith(
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF6E0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Didn't receive the code? Check your spam folder or try resending it.",
                style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
              ),
            ),
            16.heightBox,
            CustomActionButton(
              buttonText: "Verify & Continue",
              onTap: _onVerify,
              isEnabled: _isButtonEnabled,
              backgroundColor: kPrimaryColor,
              buttonTextColor: kBlackColor,
              width: double.infinity,
            ),
            24.heightBox,
          ],
        ),
      ),
    );
  }
}
