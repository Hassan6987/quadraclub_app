// otp_verification_screen.dart

import 'dart:async';

import 'package:pinput/pinput.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/authentication/ui/reset_password_screen.dart';
import 'package:quadraclub_app/presentation/authentication/ui/widgets/auth_appbar.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';
import 'package:quadraclub_app/utils/extensions/padding_extension.dart';

import '/app_exports.dart';
import 'create_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final bool isReset;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    this.isReset = false,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
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
      widget.isReset
          ? Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ResetPasswordScreen(
                  email: widget.email,
                  otp: _otpController.text,
                ),
              ),
            )
          : context.read<AuthBloc>().add(
              VerifyCode(email: widget.email, otp: _otpController.text),
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            32.heightBox,

            Text(
              "OTP Verification",
              style: AppStyles.w500f24inter.copyWith(color: kTextPrimaryColor),
            ),
            8.heightBox,
            Text.rich(
              TextSpan(
                text: "Enter the 6-digit code sent to you at:\n",
                style: AppStyles.w400f16inter.copyWith(
                  color: kGreen37.withValues(alpha: 0.60),
                ),
                children: [
                  TextSpan(
                    text: widget.email,
                    style: AppStyles.w500f16inter.copyWith(color: kGreen37),
                  ),
                ],
              ),
            ),
            40.heightBox,
            Center(
              child: Pinput(
                length: 6,
                controller: _otpController,
                onChanged: _updateButtonState,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: kDarkColor, width: 2),
                  ),
                ),
              ),
            ),
            24.heightBox,
            CustomActionButton(
              buttonText: "Verify",
              onTap: _onVerify,
              isEnabled: _isButtonEnabled,
              backgroundColor: kNewBallGreen,
              buttonTextColor: kDarkColor,
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
                              color: kGreen37.withValues(alpha: 0.70),
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
                            widget.isReset
                                ? context.read<AuthBloc>().add(
                                    ForgotPassword(email: widget.email),
                                  )
                                : context.read<AuthBloc>().add(
                                    RequestCode(email: widget.email),
                                  );
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
          ],
        ).withPaddingAll(24),
      ),
    );
  }
}
