import 'dart:async';
import 'package:pinput/pinput.dart';
import 'package:quadraclub_app/app_exports.dart';



class Step2OtpVerification extends StatefulWidget {
  final String email;

  const Step2OtpVerification({super.key, required this.email});

  @override
  State<Step2OtpVerification> createState() => _Step2OtpVerificationState();
}

class _Step2OtpVerificationState extends State<Step2OtpVerification> {
  final _otpController = TextEditingController();
  bool _isButtonEnabled = false;

  Timer? _timer;
  int _resendSeconds = 12;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _resendSeconds = 12;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _onResendCode() {
    if (_resendSeconds == 0) {
      _startResendTimer();
      // TODO: Implement resend OTP logic
    }
  }

  void _onVerifyAndContinue() {
    if (_otpController.text.length == 6) {
      // Navigate to next step
      // TODO: Implement navigation
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _updateButtonState(String value) {
    setState(() {
      _isButtonEnabled = value.length == 6;
    });
  }

  void _onContinue() {
    Navigator.pushNamed(
      context,
      RouteName.aboutYou,
    );
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
      body: SafeArea(
        child: Column(
          children: [
            ProfileCreationAppBar(
              onBackPressed: () => Navigator.pop(context),
              currentStep: 2,
            ),
            24.heightBox,

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),

                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'OTP Verification',
                              style: AppStyles.w600f18inter,
                            ),
                            Text(
                              'Enter the 6-digit code sent to you at:',
                              style: AppStyles.w400f14inter.copyWith(
                                color: kTextSecondary.withValues(alpha: 0.70),
                              ),
                            ),
                            2.heightBox,
                            Text(
                              widget.email,
                              style: AppStyles.w500f14inter.copyWith(
                                color: kTextPrimaryColor,
                              ),
                            ),
                            40.heightBox,
                            Pinput(
                              length: 6,
                              controller: _otpController,
                              onChanged: _updateButtonState,
                              defaultPinTheme: defaultPinTheme,
                              focusedPinTheme: defaultPinTheme.copyWith(
                                decoration: defaultPinTheme.decoration!
                                    .copyWith(
                                      border: Border.all(
                                        color: kDarkTextColor,
                                        width: 2,
                                      ),
                                    ),
                              ),
                            ),
                            32.heightBox,
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  _resendSeconds > 0
                                      ? RichText(
                                          text: TextSpan(
                                            text: "Resend code in",
                                            style: AppStyles.subtitleRegular
                                                .copyWith(
                                                  color: kTextSecondary
                                                      .withValues(alpha: 0.70),
                                                ),
                                            children: [
                                              TextSpan(
                                                text: " (0:$_resendSeconds)",
                                                style: AppStyles.w500f14inter
                                                    .copyWith(
                                                      color: kTextPrimaryColor,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            _startResendTimer();
                                          },
                                          child: Text(
                                            "Resend Code",
                                            style: AppStyles.subtitleSemiBold
                                                .copyWith(color: kPrimaryColor),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: kLightColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Didn't receive the code? Check your spam folder or try resending it.",
                                style: AppStyles.w400f14inter.copyWith(
                                  color: kBlack12Color,
                                ),
                              ),
                            ),
                            32.heightBox,
                            CustomActionButton(
                              buttonText: "Continue",
                              onTap: _onContinue,
                              isEnabled: true,
                              backgroundColor: kPrimaryColor,
                              buttonTextColor: kTextPrimaryColor,
                            ),

                            24.heightBox,
                          ],
                        ).withPaddingSymmetric(24, 0),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
