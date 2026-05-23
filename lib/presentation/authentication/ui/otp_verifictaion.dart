// otp_verification_screen.dart

import 'dart:async';

import 'package:pinput/pinput.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/authentication/ui/reset_password_screen.dart';
import 'package:quadraclub_app/presentation/authentication/ui/widgets/auth_appbar.dart';
import 'package:quadraclub_app/utils/components/custom_loading_view.dart';
import 'package:quadraclub_app/utils/const/dimensions_resource.dart';

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
      width: 50,
      height: 48,
      textStyle: AppStyles.titleMedium.copyWith(color: kBlackColor),
      decoration: BoxDecoration(
        color: kWhiteColor,
        border: Border.all(color: kTertiaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: const AuthAppBar(showBackButton: true),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStateStatus.verified) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CreatePasswordScreen(email: widget.email),
              ),
            );
          } else if (state.status == AuthStateStatus.failure) {
            context.showToast(
              state.error ?? "something went wrong, try again",
              isError: true,
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dim.PADDING_SIZE_LARGE),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Verification",
                style: AppStyles.headingSemibold.copyWith(color: kBlackColor),
              ),
              8.heightBox,
              Text.rich(
                TextSpan(
                  text: "We have sent an email verification code to:\n",
                  style: AppStyles.subtitleRegular.copyWith(color: kTextColor),
                  children: [
                    TextSpan(
                      text: widget.email,
                      style: AppStyles.subtitleSemiBold.copyWith(
                        color: kBlackColor,
                      ),
                    ),
                  ],
                ),
              ),
              32.heightBox,
              Text(
                "Enter Verification Code",
                style: AppStyles.subtitleMedium.copyWith(color: kBlackColor),
              ),
              8.heightBox,
              Center(
                child: Pinput(
                  length: 6,
                  controller: _otpController,
                  onChanged: _updateButtonState,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: kSecondaryColor, width: 2),
                    ),
                  ),
                ),
              ),
              40.heightBox,
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state.status == AuthStateStatus.loading) {
                    return Center(child: CustomLoadingView());
                  }
                  return CustomActionButton(
                    buttonText: "Verify & Continue",
                    onTap: _onVerify,
                    isEnabled: _isButtonEnabled,
                    backgroundColor: kSecondaryColor,
                    buttonTextColor: kWhiteColor,
                  );
                },
              ),
              30.heightBox,
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      "Didn't receive the code?",
                      style: AppStyles.subtitleRegular.copyWith(
                        color: kBlackColor,
                      ),
                    ),
                    4.heightBox,
                    _secondsRemaining > 0
                        ? Text(
                            "Resend in (0:$_secondsRemaining)",
                            style: AppStyles.subtitleSemiBold.copyWith(
                              color: kTextColor,
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
                                color: kSecondaryColor,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
